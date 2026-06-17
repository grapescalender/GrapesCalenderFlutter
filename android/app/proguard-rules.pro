# ──────────────────────────────────────────────────────────────────────────────
# Flutter / Dart keep rules
# ──────────────────────────────────────────────────────────────────────────────
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# ──────────────────────────────────────────────────────────────────────────────
# Google Error-Prone annotations
# (used by Google Tink, pulled in by flutter_secure_storage)
# R8 complains about these because they're compile-only annotations that are
# not present at runtime — we just tell R8 to ignore them.
# ──────────────────────────────────────────────────────────────────────────────
-dontwarn com.google.errorprone.annotations.**
-keep class com.google.errorprone.annotations.** { *; }

# ──────────────────────────────────────────────────────────────────────────────
# javax.annotation (JSR-305 / FindBugs / SpotBugs nullability annotations)
# Also used by Tink internally.
# ──────────────────────────────────────────────────────────────────────────────
-dontwarn javax.annotation.**
-keep class javax.annotation.** { *; }
-dontwarn javax.annotation.concurrent.**
-keep class javax.annotation.concurrent.** { *; }

# ──────────────────────────────────────────────────────────────────────────────
# Google Tink (used by flutter_secure_storage for AES encryption)
# ──────────────────────────────────────────────────────────────────────────────
-keep class com.google.crypto.tink.** { *; }
-dontwarn com.google.crypto.tink.**

# ──────────────────────────────────────────────────────────────────────────────
# flutter_secure_storage
# ──────────────────────────────────────────────────────────────────────────────
-keep class com.it_nomads.fluttersecurestorage.** { *; }

# ──────────────────────────────────────────────────────────────────────────────
# Kotlin / Coroutines
# ──────────────────────────────────────────────────────────────────────────────
-keep class kotlin.** { *; }
-keep class kotlinx.coroutines.** { *; }
-dontwarn kotlinx.coroutines.**

# ──────────────────────────────────────────────────────────────────────────────
# Keep all model classes that use Gson / JSON serialisation
# (adjust the package if you have custom model packages)
# ──────────────────────────────────────────────────────────────────────────────
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# ──────────────────────────────────────────────────────────────────────────────
# Suppress notes about duplicate class definitions in combined JARs
# ──────────────────────────────────────────────────────────────────────────────
-dontnote **
