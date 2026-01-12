buildscript {
    repositories {
        google()
        mavenCentral()
    }
}

plugins {
    // JANGAN pakai version di sini
    id("com.android.application") apply false
    id("org.jetbrains.kotlin.android") apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
