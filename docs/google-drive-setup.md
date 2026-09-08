# إعداد مزامنة Google Drive

الكود جاهز بالكامل، لكنه **لن يعمل حتى تُنشئ مفاتيح OAuth بنفسك**. لا يمكن
لأحد غيرك إنشاؤها: تحتاج حسابك على Google وبصمة مفتاح التوقيع الخاص بجهازك.

بلا هذه الخطوات سيظهر خطأ `clientConfigurationError` وشاشة «المزامنة غير مُعدّة».

---

## 1. أنشئ مشروعاً على Google Cloud

1. افتح <https://console.cloud.google.com/>
2. **New Project** → سمِّه مثلاً `attendance-budget`
3. من **APIs & Services → Library** فعّل **Google Drive API**

## 2. اضبط شاشة الموافقة

**APIs & Services → OAuth consent screen**

- نوع المستخدم: **External**
- اسم التطبيق، بريد الدعم، بريد المطوّر
- **Scopes** → أضف `https://www.googleapis.com/auth/drive.appdata` فقط

  هذا النطاق يمنح الوصول لمجلد التطبيق الخاص وحده، لا لملفات المستخدم.
  طلب نطاق أوسع يستوجب مراجعة أمنية من Google بلا فائدة هنا.

- **Test users** → أضف بريدك ما دام التطبيق في وضع الاختبار

  في وضع Testing لا يستطيع الدخول إلا من أضفته هنا (حتى 100 حساب). النشر
  العام يتطلب مراجعة من Google.

## 3. أنشئ عميل OAuth لأندرويد

**Credentials → Create Credentials → OAuth client ID → Android**

| الحقل | القيمة |
|---|---|
| Package name | `com.example.attendance_budget_app` |
| SHA-1 | من الأمر أدناه |

استخرج بصمة مفتاح التصحيح:

```bash
keytool -list -v -alias androiddebugkey \
  -keystore ~/.android/debug.keystore \
  -storepass android -keypass android | grep SHA1
```

> **مهم:** بصمة مفتاح **الإصدار** مختلفة. عند بناء نسخة للنشر أضف عميلاً
> ثانياً ببصمة مفتاح التوقيع الحقيقي، وإلا فشل الدخول في النسخة المنشورة
> بينما ينجح في التصحيح.
>
> إن استخدمت **Play App Signing** فالبصمة المطلوبة هي التي تعرضها Play
> Console تحت *Release → Setup → App signing*، لا بصمة مفتاحك المحلي.

لا يحتاج أندرويد أي ملف؛ الربط يتم بالحزمة والبصمة.

## 4. أنشئ عميل OAuth لـ iOS

**Credentials → Create Credentials → OAuth client ID → iOS**

- Bundle ID: `com.example.attendanceBudgetApp` (تأكّد منه من Xcode)

ثم:

1. نزّل `GoogleService-Info.plist` وضعه في `ios/Runner/`
2. أضف مخطط العنوان المعكوس في `ios/Runner/Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <!-- REVERSED_CLIENT_ID من GoogleService-Info.plist -->
      <string>com.googleusercontent.apps.XXXXXXXX-YYYYYYYY</string>
    </array>
  </dict>
</array>
```

## 5. تحقّق

```bash
flutter run
```

الملف الشخصي ← **النسخ الاحتياطي** ← «ربط حساب Google».

- ظهور شاشة اختيار الحساب = الإعداد سليم
- `clientConfigurationError` = البصمة أو اسم الحزمة لا يطابق ما في Console
- `DEVELOPER_ERROR` على أندرويد = السبب نفسه غالباً

---

## ماذا يُرفع بالضبط

نسخة JSON واحدة اسمها `attendance_backup.json` داخل **`appDataFolder`**:

- الملف الشخصي · جهات العمل · سجلات الدوام · المعاملات · الديون · الحسابات ·
  الفئات · حدود الميزانية · إعدادات التذكيرات
- **لا يُرفع** سجل التنبيهات: مشتق ويعاد توليده، وحجمه ينمو بلا حد

`appDataFolder` مجلد خاص لا يظهر في Drive الخاص بالمستخدم ولا يستطيع أي
تطبيق آخر قراءته، ويُحذف تلقائياً إن أزال المستخدم صلاحية التطبيق.

**النسخة واحدة تُستبدل، لا تاريخ نسخ.** تعدّدها يستهلك حصة المستخدم ويجعل
«أي نسخة أستعيد؟» سؤالاً بلا إجابة.

**الاستعادة تستبدل ولا تدمج.** دمج صفوف بمعرّفات متضاربة من جهازين ينتج
أرقاماً مالية خاطئة بصمت؛ الاستبدال يُبقي الحالة مفهومة. العملية داخل
معاملة واحدة: إما أن تكتمل أو لا يتغيّر شيء.
