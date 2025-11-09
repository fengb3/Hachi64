plugins {
    kotlin("multiplatform") version "2.0.21"
    id("maven-publish")
    id("signing")
}

group = "com.hachi64"
version = "0.1.0"

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

publishing {
    publications.withType<MavenPublication> {
        pom {
            name.set("Hachi64")
            description.set("哈吉米64 编解码器 - 使用64个中文字符进行 Base64 风格的编码和解码")
            url.set("https://github.com/fengb3/Hachi64")
            
            licenses {
                license {
                    name.set("MIT License")
                    url.set("https://opensource.org/licenses/MIT")
                }
            }
            
            developers {
                developer {
                    id.set("fengb3")
                    name.set("fengb3")
                    url.set("https://github.com/fengb3")
                }
            }
            
            scm {
                connection.set("scm:git:git://github.com/fengb3/Hachi64.git")
                developerConnection.set("scm:git:ssh://github.com:fengb3/Hachi64.git")
                url.set("https://github.com/fengb3/Hachi64/tree/main")
            }
        }
    }
    
    repositories {
        maven {
            name = "central"
            url = uri("https://central.sonatype.com/api/v1/publisher/upload?publishingType=AUTOMATIC")
            credentials {
                username = System.getenv("MAVEN_USERNAME")
                password = System.getenv("MAVEN_PASSWORD")
            }
        }
    }
}

signing {
    useInMemoryPgpKeys(
        System.getenv("GPG_PRIVATE_KEY"),
        System.getenv("GPG_PASSPHRASE")
    )
    sign(publishing.publications)
}
