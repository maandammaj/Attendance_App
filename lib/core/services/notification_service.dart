import 'dart:developer' as developer;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:isar_community/isar.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../data/local/database/isar_database.dart';
import '../../data/models/notification_model.dart';
import '../constants/notification_ids.dart';

/// نطاقات معرّفات التنبيهات — كل نوع يملك نطاقه ليمكن إلغاؤه وحده.
///
/// القنوات مفصولة كذلك حتى يستطيع المستخدم كتم نوع دون الباقي من إعدادات النظام.
class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  bool _exactAlarmsAllowed = true;

  /// هل يسمح النظام بالتنبيهات المجدولة بدقة؟ تُقرأ بعد `init`.
  bool get exactAlarmsAllowed => _exactAlarmsAllowed;

  static const _channels = <AndroidNotificationChannel>[
    AndroidNotificationChannel(
      NotificationChannels.attendance,
      'تذكيرات الدوام',
      description: 'بداية ونهاية الوردية، واكتمال الساعات، ونسيان تسجيل الخروج',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      enableLights: true,
    ),
    AndroidNotificationChannel(
      NotificationChannels.debt,
      'تذكيرات الديون',
      description: 'الاستحقاقات القادمة والمتأخرات',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    ),
    AndroidNotificationChannel(
      NotificationChannels.finance,
      'تنبيهات مالية',
      description: 'تجاوز الميزانية ونسبة الدين ومعدل الصرف',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    ),
    AndroidNotificationChannel(
      NotificationChannels.summary,
      'الملخصات الدورية',
      description: 'الملخص اليومي والأسبوعي والتقرير الشهري',
      importance: Importance.defaultImportance,
      playSound: true,
    ),
    AndroidNotificationChannel(
      NotificationChannels.general,
      'تنبيهات عامة',
      importance: Importance.defaultImportance,
      playSound: true,
    ),
  ];

  Future<void> init() async {
    if (_initialized) return;

    tzdata.initializeTimeZones();
    await _configureLocalTimeZone();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _notifications.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: _onTap,
    );

    final android = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      // القنوات القديمة تُحذف أولاً: إعداداتها متجمّدة ولا تُصلَح بالتعديل.
      for (final id in NotificationChannels.retired) {
        await android.deleteNotificationChannel(id);
      }
      for (final channel in _channels) {
        await android.createNotificationChannel(channel);
      }
    }

    _initialized = true;
  }

  /// معرّف التنبيه الذي فتح التطبيق، تقرأه الشاشة الأولى لتوجّه المستخدم.
  static String? launchPayload;

  static void _onTap(NotificationResponse response) {
    launchPayload = response.payload;
  }

  Future<void> _configureLocalTimeZone() async {
    // بدون هذه الخطوة يجدول zonedSchedule على UTC وتصل التنبيهات في وقت خاطئ.
    final offset = DateTime.now().timeZoneOffset;
    for (final name in tz.timeZoneDatabase.locations.keys) {
      final location = tz.timeZoneDatabase.locations[name]!;
      if (tz.TZDateTime.now(location).timeZoneOffset == offset) {
        tz.setLocalLocation(location);
        return;
      }
    }
  }

  /// يطلب أذونات الإشعارات. يُستدعى مرة واحدة عند أول تشغيل بعد بناء الواجهة.
  Future<bool> requestPermissions() async {
    final android = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final granted = await android.requestNotificationsPermission() ?? false;
      _exactAlarmsAllowed =
          await android.requestExactAlarmsPermission() ?? false;
      return granted;
    }

    final ios = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      return await ios.requestPermissions(alert: true, badge: true, sound: true) ??
          false;
    }
    return true;
  }

  NotificationDetails _detailsFor(
    NotificationCategory category, {
    String? bigText,
  }) {
    final channel = NotificationChannels.forCategory(category);
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channel,
        _channels.firstWhere((c) => c.id == channel).name,
        importance:
            _channels.firstWhere((c) => c.id == channel).importance,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        // التصنيف يجعل النظام يعامل التذكير كمنبّه لا كرسالة دعائية،
        // فينجو من كتم الإشعارات التلقائي في وضع توفير البطارية.
        category: AndroidNotificationCategory.reminder,
        visibility: NotificationVisibility.public,
        styleInformation:
            bigText == null ? null : BigTextStyleInformation(bigText),
      ),
      iOS: const DarwinNotificationDetails(),
    );
  }

  /// يعرض تنبيهاً فورياً ويحفظه في السجل.
  ///
  /// [dedupeKey] يمنع تكرار نفس التنبيه في اليوم نفسه — التنبيهات الذكية
  /// تُقيَّم في كل دورة تشغيل، فبدونه يتكرر نفس التحذير عند كل فتح للتطبيق.
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    NotificationCategory category = NotificationCategory.general,
    String? payload,
    String? dedupeKey,
  }) async {
    final isar = await IsarDatabase.instance;

    if (dedupeKey != null && await _alreadySentToday(isar, dedupeKey)) return;

    await isar.writeTxn(() async {
      await isar.notificationModels.put(NotificationModel()
        ..title = title
        ..body = body
        ..timestamp = DateTime.now()
        ..category = category
        ..payload = payload
        ..dedupeKey = dedupeKey);
    });

    await _notifications.show(
      id,
      title,
      body,
      _detailsFor(category, bigText: body.length > 60 ? body : null),
      payload: payload,
    );
  }

  Future<bool> _alreadySentToday(Isar isar, String key) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final existing = await isar.notificationModels
        .filter()
        .dedupeKeyEqualTo(key)
        .timestampGreaterThan(startOfDay)
        .findFirst();
    return existing != null;
  }

  /// يجدول تنبيهاً لمرة واحدة. يتجاهل الأوقات الماضية بدل رمي استثناء.
  Future<void> scheduleOnce({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    NotificationCategory category = NotificationCategory.general,
    String? payload,
  }) async {
    if (!scheduledTime.isAfter(DateTime.now())) return;
    await _zonedSchedule(
      id: id,
      title: title,
      body: body,
      when: tz.TZDateTime.from(scheduledTime, tz.local),
      category: category,
      payload: payload,
    );
  }

  /// يجدول تنبيهاً يتكرر أسبوعياً في يوم ووقت محددين.
  ///
  /// [dayOfWeek] بترقيم `DateTime.weekday` (1 = الاثنين … 7 = الأحد)،
  /// وهو نفس ترقيم `WorkDayConfig.dayOfWeek` المخزَّن.
  Future<void> scheduleWeekly({
    required int id,
    required String title,
    required String body,
    required int dayOfWeek,
    required int hour,
    required int minute,
    NotificationCategory category = NotificationCategory.general,
    String? payload,
  }) async {
    await _zonedSchedule(
      id: id,
      title: title,
      body: body,
      when: _nextInstanceOfWeekday(dayOfWeek, hour, minute),
      category: category,
      payload: payload,
      matchComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  /// يجدول تنبيهاً يومياً في ساعة ودقيقة محددتين.
  Future<void> scheduleDaily({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    NotificationCategory category = NotificationCategory.general,
    String? payload,
  }) async {
    await _zonedSchedule(
      id: id,
      title: title,
      body: body,
      when: _nextInstanceOfTime(hour, minute),
      category: category,
      payload: payload,
      matchComponents: DateTimeComponents.time,
    );
  }

  Future<void> _zonedSchedule({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime when,
    required NotificationCategory category,
    String? payload,
    DateTimeComponents? matchComponents,
  }) async {
    try {
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        when,
        _detailsFor(category),
        androidScheduleMode: _exactAlarmsAllowed
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: matchComponents,
        payload: payload,
      );
    } on Exception catch (error, stackTrace) {
      // منع فشل جدولة واحدة من إسقاط دورة إعادة الجدولة كاملة.
      developer.log(
        'تعذّرت جدولة التنبيه $id',
        name: 'notifications.schedule',
        level: 900,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  tz.TZDateTime _nextInstanceOfWeekday(int dayOfWeek, int hour, int minute) {
    var scheduled = _nextInstanceOfTime(hour, minute);
    while (scheduled.weekday != dayOfWeek) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  /// يلغي كل التنبيهات المجدولة ضمن نطاق معرّفات واحد.
  Future<void> cancelRange(IdRange range) async {
    for (int id = range.start; id < range.end; id++) {
      await _notifications.cancel(id);
    }
  }

  Future<void> cancel(int id) => _notifications.cancel(id);

  Future<void> cancelAll() => _notifications.cancelAll();

  Future<List<PendingNotificationRequest>> pending() =>
      _notifications.pendingNotificationRequests();

  /// حالة التسليم كما يراها النظام — أساس شرح "لماذا لا تصل التنبيهات".
  ///
  /// ثلاثة أسباب تمنع الوصول ولا يظهر أيٌّ منها كخطأ في الكود: الإذن مرفوض،
  /// الجدولة الدقيقة ممنوعة (أندرويد 12+)، أو النظام يقتل التطبيق في الخلفية.
  Future<NotificationDiagnostics> diagnose() async {
    final android = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (android == null) {
      final ios = _notifications.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      final granted =
          await ios?.checkPermissions().then((p) => p?.isEnabled ?? false) ??
              true;
      return NotificationDiagnostics(
        permissionGranted: granted,
        exactAlarmsAllowed: true,
        pendingCount: (await pending()).length,
      );
    }

    return NotificationDiagnostics(
      permissionGranted: await android.areNotificationsEnabled() ?? false,
      exactAlarmsAllowed: await android.canScheduleExactNotifications() ?? false,
      pendingCount: (await pending()).length,
    );
  }

  /// يطلق تنبيهاً فورياً للتحقق من الصوت والوصول بلا انتظار جدولة.
  Future<void> sendTestNotification() async {
    await showNotification(
      id: NotificationIds.attendanceLive.idFor(9),
      title: 'تجربة التنبيهات',
      body: 'إن وصلك هذا مع صوت فالإعدادات سليمة.',
      category: NotificationCategory.attendance,
    );
  }

  /// يفتح إعدادات الجدولة الدقيقة لينحها المستخدم.
  Future<void> requestExactAlarms() async {
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
    _exactAlarmsAllowed = true;
  }
}

/// ما يمنع التنبيهات من الوصول، بصيغة قابلة للعرض للمستخدم.
class NotificationDiagnostics {
  const NotificationDiagnostics({
    required this.permissionGranted,
    required this.exactAlarmsAllowed,
    required this.pendingCount,
  });

  final bool permissionGranted;
  final bool exactAlarmsAllowed;

  /// عدد التنبيهات المجدولة فعلياً في النظام. صفر مع تفعيل التذكيرات يعني
  /// أن الجدولة فشلت لا أن لا شيء مستحق.
  final int pendingCount;

  bool get isHealthy => permissionGranted && exactAlarmsAllowed;
}
