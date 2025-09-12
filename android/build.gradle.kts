import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

extra["compileSdk"] = 35
//extra["minSdk"] = 21
extra["targetSdk"] = 35

allprojects {
    repositories {
        google()
        mavenCentral()
    }

    // 为所有模块统一配置 Android 设置
    afterEvaluate {
        if (hasProperty("android")) {
            configure<com.android.build.gradle.BaseExtension> {
                compileSdkVersion(rootProject.extra["compileSdk"] as Int)

                defaultConfig {
//                    minSdk = rootProject.extra["minSdk"] as Int
                    targetSdk = rootProject.extra["targetSdk"] as Int
                }

                compileOptions {
                    sourceCompatibility = JavaVersion.VERSION_11
                    targetCompatibility = JavaVersion.VERSION_11
                }
            }
        }
    }

    tasks.withType<KotlinCompile>().configureEach {
        kotlinOptions {
            jvmTarget = JavaVersion.VERSION_11.toString()
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

// Fixed:
// Could not create an instance of type com.android.build.api.variant.impl.LibraryVariantBuilderImpl.
//  > Namespace not specified. Specify a namespace in the module's build file: /Users/xxx/.pub-cache/hosted/pub.flutter-io.cn/isar_flutter_libs-3.1.0+1/android/build.gradle. See https://d.android.com/r/tools/upgrade-assistant/set-namespace for information about setting the namespace.
subprojects {
    afterEvaluate {
        if (extensions.findByName("android") != null) {
            extensions.configure<com.android.build.gradle.BaseExtension>("android") {
                if (namespace == null) {
                    namespace = group.toString()
                }
            }
        }
    }
}

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}