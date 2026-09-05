import 'dart:convert';
import 'dart:developer' as developer;

import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import 'backup_service.dart';

/// حساب مرتبط ونسخته الأخيرة على Drive.
class DriveStatus {
  const DriveStatus({
    this.email,
    this.lastBackupAt,
    this.lastBackupSize,
  });

  final String? email;
  final DateTime? lastBackupAt;
  final int? lastBackupSize;

  bool get isSignedIn => email != null;
  bool get hasBackup => lastBackupAt != null;
}

/// خطأ مزامنة برسالة عربية جاهزة للعرض.
class DriveSyncException implements Exception {
  const DriveSyncException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// يرفع نسخة قاعدة البيانات إلى Google Drive ويستعيدها.
///
/// النسخة تُكتب في **`appDataFolder`** لا في ملفات المستخدم: مجلد خاص
/// بالتطبيق لا يظهر في Drive ولا يمكن لتطبيق آخر قراءته، ويُحذف مع
/// التطبيق إن أزال المستخدم صلاحيته. هذا يجعل بياناته المالية غير مكشوفة
/// ولا تُلوّث مساحته.
class DriveSyncService {
  DriveSyncService({BackupService backup = const BackupService()})
      : _backup = backup;

  final BackupService _backup;

  static const _fileName = 'attendance_backup.json';

  /// نطاق واحد فقط. `drive.file` أو النطاق الكامل يمنحان وصولاً لكل ملفات
  /// المستخدم — لا نحتاجه ولا يصح طلبه.
  static const _scopes = [drive.DriveApi.driveAppdataScope];

  GoogleSignIn get _signIn => GoogleSignIn.instance;

  bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    await _signIn.initialize();
    _initialized = true;
  }

  Future<DriveStatus> status() async {
    await _ensureInitialized();
    final account = await _silentAccount();
    if (account == null) return const DriveStatus();

    try {
      final file = await _findBackup(account);
      return DriveStatus(
        email: account.email,
        lastBackupAt: file?.modifiedTime?.toLocal(),
        lastBackupSize: int.tryParse(file?.size ?? ''),
      );
    } on Exception {
      // الحساب مرتبط لكن القراءة فشلت (بلا شبكة مثلاً) — نعرض الحساب فقط.
      return DriveStatus(email: account.email);
    }
  }

  Future<GoogleSignInAccount?> _silentAccount() async {
    await _ensureInitialized();
    return await _signIn.attemptLightweightAuthentication();
  }

  /// يفتح شاشة اختيار الحساب. يعيد null إن ألغى المستخدم.
  Future<String?> signIn() async {
    await _ensureInitialized();
    try {
      final account = await _signIn.authenticate(scopeHint: _scopes);
      return account.email;
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) return null;
      throw DriveSyncException(_readable(error));
    }
  }

  Future<void> signOut() async {
    await _ensureInitialized();
    await _signIn.disconnect();
  }

  /// يرفع نسخة جديدة، مستبدلاً السابقة.
  ///
  /// نسخة واحدة تُستبدل لا تاريخ نسخ: تعدّدها يستهلك حصة المستخدم ويجعل
  /// "أي نسخة أستعيد؟" سؤالاً بلا إجابة واضحة.
  Future<DateTime> upload() async {
    final api = await _api();
    final json = await _backup.exportJson();
    final bytes = utf8.encode(json);

    final media = drive.Media(Stream.value(bytes), bytes.length);
    final existing = await _findBackupWith(api);

    final saved = existing == null
        ? await api.files.create(
            drive.File()
              ..name = _fileName
              ..parents = ['appDataFolder'],
            uploadMedia: media,
            $fields: 'id,modifiedTime',
          )
        : await api.files.update(
            drive.File(),
            existing.id!,
            uploadMedia: media,
            $fields: 'id,modifiedTime',
          );

    developer.log(
      'رُفعت نسخة إلى Drive (${bytes.length} بايت)',
      name: 'backup.drive',
      level: 500,
    );
    return saved.modifiedTime?.toLocal() ?? DateTime.now();
  }

  /// ينزّل آخر نسخة ويستبدل بها المحتوى الحالي. يعيد عدد الصفوف المستعادة.
  Future<int> restore() async {
    final api = await _api();
    final file = await _findBackupWith(api);
    if (file == null) {
      throw const DriveSyncException('لا توجد نسخة محفوظة على Drive');
    }

    final media = await api.files.get(
      file.id!,
      downloadOptions: drive.DownloadOptions.fullMedia,
    ) as drive.Media;

    final chunks = <int>[];
    await for (final chunk in media.stream) {
      chunks.addAll(chunk);
    }

    return await _backup.restoreJson(utf8.decode(chunks));
  }

  Future<drive.File?> _findBackup(GoogleSignInAccount account) async =>
      _findBackupWith(await _apiFor(account));

  Future<drive.File?> _findBackupWith(drive.DriveApi api) async {
    final list = await api.files.list(
      spaces: 'appDataFolder',
      q: "name = '$_fileName'",
      $fields: 'files(id,name,size,modifiedTime)',
    );
    final files = list.files;
    return (files == null || files.isEmpty) ? null : files.first;
  }

  Future<drive.DriveApi> _api() async {
    final account = await _silentAccount();
    if (account == null) {
      throw const DriveSyncException('سجّل الدخول بحساب Google أولاً');
    }
    return _apiFor(account);
  }

  Future<drive.DriveApi> _apiFor(GoogleSignInAccount account) async {
    final authorization =
        await account.authorizationClient.authorizationForScopes(_scopes) ??
            await account.authorizationClient.authorizeScopes(_scopes);

    return drive.DriveApi(
      _AuthorizedClient(http.Client(), authorization.accessToken),
    );
  }

  static String _readable(GoogleSignInException error) {
    return switch (error.code) {
      GoogleSignInExceptionCode.canceled => 'أُلغيت العملية',
      GoogleSignInExceptionCode.interrupted =>
        'انقطع الاتصال — تحقّق من الشبكة',
      GoogleSignInExceptionCode.clientConfigurationError =>
        'إعداد Google غير مكتمل. راجع docs/google-drive-setup.md',
      _ => 'تعذّر تسجيل الدخول: ${error.description ?? error.code.name}',
    };
  }
}

/// يضيف ترويسة الاعتماد لكل طلب — `googleapis` يتوقع عميلاً مُصرَّحاً.
class _AuthorizedClient extends http.BaseClient {
  _AuthorizedClient(this._inner, this._accessToken);

  final http.Client _inner;
  final String _accessToken;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = 'Bearer $_accessToken';
    return _inner.send(request);
  }
}
