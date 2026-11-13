# Reglas ProGuard / R8 para BusTrack Mobile (Release)
# OWASP MASVS-RES-1 y MASVS-CODE-2: Ofuscación y protección de código

# Conservar clases de Flutter y sus plugins
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class com.bustrackapp.** { *; }

# Mantener anotaciones necesarias
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile

# Prevenir eliminación de constructores requeridos por reflection
-keepclassmembers class * {
    void set*(***);
    *** get*();
}
