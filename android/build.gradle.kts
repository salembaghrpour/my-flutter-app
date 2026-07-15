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
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// قطعه کد اصلاح شده و ایمن برای تزریق خودکار Namespace به پکیج‌های قدیمی
subprojects {
    val configureNamespace: (Project) -> Unit = { proj ->
        val androidExt = proj.extensions.findByName("android") as? com.android.build.gradle.BaseExtension
        if (androidExt != null && androidExt.namespace == null) {
            androidExt.namespace = proj.group.toString()
        }
    }

    if (state.executed) {
        configureNamespace(this)
    } else {
        afterEvaluate {
            configureNamespace(this)
        }
    }
}
