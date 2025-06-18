plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // Must be last
}

android {
    namespace = "com.terloservices.gpa_cal"
    compileSdk = flutter.compileSdkVersion

    ndkVersion = "29.0.13113456"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.terloservices.gpa_cal"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = 3 // ✅ Use Int, NOT String
        versionName = "1.2.1" // ✅ Update to match your intended release
    }

    signingConfigs {
        create("release") {
            storeFile = file("my-key.jks")
            storePassword = "@Sark123"
            keyAlias = "my-key-alias"
            keyPassword = "@Sark123"
        }
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
