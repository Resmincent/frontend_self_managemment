# Keep TensorFlow Lite classes
-keep class org.tensorflow.** { *; }
-keep class org.tensorflow.lite.** { *; }
-keep class org.tensorflow.lite.gpu.** { *; }

# Keep GPU Delegate
-keep class org.tensorflow.lite.gpu.GpuDelegate { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegate$Options { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegateFactory { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegateFactory$Options { *; }

# Keep constructors
-keepclassmembers class * {
    public <init>(...);
}

# Supress warning
-dontwarn org.tensorflow.lite.gpu.GpuDelegateFactory$Options
