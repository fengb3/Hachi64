plugins {
    kotlin("multiplatform") version "2.0.21"
}

group = "com.hachi64"
version = "1.0.0"

repositories {
    mavenCentral()
}

kotlin {
    // JVM target
    jvm {
        compilations.all {
            kotlinOptions.jvmTarget = "1.8"
        }
        testRuns["test"].executionTask.configure {
            useJUnitPlatform()
        }
    }
    
    // JS target - Node.js only (browser requires additional setup)
    js(IR) {
        nodejs()
    }
    
    // Native targets - commented out as they require network access to download prebuilt binaries
    // Uncomment these when running locally with internet access:
    // linuxX64()
    // macosX64()
    // macosArm64()
    // mingwX64()
    
    sourceSets {
        val commonMain by getting {
            dependencies {
            }
        }
        val commonTest by getting {
            dependencies {
                implementation(kotlin("test"))
            }
        }
        val jvmMain by getting {
            dependencies {
            }
        }
        val jvmTest by getting {
            dependencies {
            }
        }
        val jsMain by getting {
            dependencies {
            }
        }
        val jsTest by getting {
            dependencies {
            }
        }
    }
}
