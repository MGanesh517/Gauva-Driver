# =====================
# Flutter
# =====================
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.** { *; }
-dontwarn io.flutter.embedding.**

# =====================
# Firebase
# =====================
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Firebase Messaging / Analytics
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# =====================
# Pusher
# =====================
-keep class com.pusher.** { *; }
-dontwarn com.pusher.**

# =====================
# Kotlin
# =====================
-keep class kotlin.** { *; }
-dontwarn kotlin.**

# =====================
# SLF4J logging (Firebase / networking)
# =====================
-keep class org.slf4j.** { *; }
-dontwarn org.slf4j.**

# =====================
# Google Maps + Location
# =====================
-keep class com.google.android.gms.maps.** { *; }
-keep interface com.google.android.gms.maps.** { *; }
-keep class com.google.android.gms.location.** { *; }

# =====================
# Optional: reflection-based libraries
# =====================
-keepattributes *Annotation*,EnclosingMethod,Signature
