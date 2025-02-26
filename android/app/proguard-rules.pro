# Keep Play Core classes
-keep class com.google.android.play.core.** { *; }
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }

# Keep Google API client classes
-keep class com.google.api.client.** { *; }
-keep class com.google.api.client.http.** { *; }
-keep class com.google.api.client.util.** { *; }

# Keep error-prone annotations
-keep class com.google.errorprone.annotations.** { *; }

# Keep javax annotations
-keep class javax.annotation.** { *; }

# Keep Joda-Time classes
-keep class org.joda.time.** { *; }

# Keep Tink classes
-keep class com.google.crypto.tink.** { *; }