allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    
    // Configure NDK versions - allow rive_common to use its required version
    project.pluginManager.withPlugin("com.android.application") {
        project.extensions.configure<com.android.build.gradle.AppExtension> {
            if (project.name != "rive_common") {
                ndkVersion = "27.0.12077973"
            }
        }
    }
    project.pluginManager.withPlugin("com.android.library") {
        project.extensions.configure<com.android.build.gradle.LibraryExtension> {
            if (project.name != "rive_common") {
                ndkVersion = "27.0.12077973"
            }
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
