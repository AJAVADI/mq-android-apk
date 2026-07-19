plugins {
    id("com.android.application")
    id("kotlin-android")
    // پلاگین Flutter باید بعد از پلاگین‌های Android و Kotlin اعمال شود
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.v2"

    // تنظیم نسخه SDK طبق نیاز پکیج‌های اندرویدی پروژه
    compileSdk = 35

    // تنظیم نسخه NDK طبق نیاز پکیج‌های native پروژه
    ndkVersion = "27.0.12077973"

    compileOptions {
        // تنظیم سازگاری Java
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17

        // فعال‌سازی Core Library Desugaring برای flutter_local_notifications
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        // تنظیم نسخه JVM برای Kotlin
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // شناسه اپلیکیشن اندروید
        applicationId = "com.example.v2"

        // مقدارهای پیش‌فرض Flutter
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // فعلاً برای تست، نسخه release هم با کلید debug امضا می‌شود
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // وابستگی لازم برای Core Library Desugaring
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
