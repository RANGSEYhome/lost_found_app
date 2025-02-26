plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // Add Google services plugin
}

android {
    namespace = "com.example.lost_found_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973" // Required by flutter_secure_storage

    packagingOptions {
        resources.excludes.add("META-INF/DEPENDENCIES")
        resources.excludes.add("META-INF/NOTICE")
        resources.excludes.add("META-INF/LICENSE")
        resources.excludes.add("META-INF/LICENSE.txt")
        resources.excludes.add("META-INF/NOTICE.txt")
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11

        // Add this for desugaring support
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.lost_found_app"
        minSdk = flutter.minSdkVersion
        targetSdk = 33
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("com.google.android.play:core:1.10.3") // Play Core
    implementation("com.google.api-client:google-api-client:1.32.1") // Google API client
    implementation("com.google.http-client:google-http-client-android:1.42.0") // Use Android-compatible HTTP client
    implementation("com.google.errorprone:error_prone_annotations:2.11.0") // Error-prone annotations
    implementation("org.joda:joda-convert:2.2.2") // Joda-Time conversion
    implementation("javax.annotation:javax.annotation-api:1.3.2") // JavaX annotations
    implementation("com.squareup.okhttp3:okhttp:4.9.3") // OkHttp (alternative to HttpClient)

    // Add Firebase Cloud Messaging dependency
    implementation("com.google.firebase:firebase-messaging:23.3.1")

    // Add core library desugaring dependency
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")
}

configurations.all {
    exclude(group = "org.apache.httpcomponents", module = "httpclient")
    exclude(group = "commons-logging", module = "commons-logging")
}
