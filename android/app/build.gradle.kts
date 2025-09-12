plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// 读取签名配置
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file ('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream (keystorePropertiesFile))
}

android {
    namespace = "feassh.app.vibcat"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "feassh.app.vibcat"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        release {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties['keyAlias']
                keyPassword = keystoreProperties['keyPassword']
                storeFile = file(keystoreProperties['storeFile'])
                storePassword = keystoreProperties['storePassword']
            }
        }
    }

    buildTypes {
        release {
            // 使用自定义签名配置，如果存在的话
            if (keystorePropertiesFile.exists()) {
                signingConfig = signingConfigs.release
            } else {
                // 如果没有自定义签名配置，使用debug签名
                // Signing with the debug keys for now, so `flutter run --release` works.
                signingConfig = signingConfigs.getByName("debug")
            }

            minifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}
