plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.attendance_budget_app"
    // إضافات local_auth_android و path_provider_android و flutter_plugin_android_lifecycle
    // تُترجم على SDK 36؛ الترجمة على أقل منه تحذير يتحول لخطأ في إصدارات لاحقة.
    compileSdk = 36
    // Use an installed NDK version (r27d) to satisfy plugin requirements
    ndkVersion = "27.3.13750724"

    compileOptions {
        isCoreLibraryDesugaringEnabled = true

        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.attendance_budget_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        // isar_community_flutter_libs and some plugins require minSdk 23
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}
dependencies {
    // Add this line (use latest version if needed, 2.0.1 is standard)
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.1")
}

flutter {
    source = "../.."
}
