# 哈吉米64 (Hachi64) - Kotlin 多平台实现

Kotlin Multiplatform 实现的哈吉米64编解码器，使用64个中文字符进行 Base64 风格的编码和解码。支持 JVM、JavaScript 和 Native 平台。

## 功能特性

- 使用64个中文字符（哈吉米字符集）进行编码
- 完全可逆的编码解码过程
- 支持带填充和不带填充的编码模式
- 兼容标准 Base64 的编码原理
- **多平台支持**: JVM, JavaScript (Node.js), Kotlin/Native

## 快速开始

**注意：** 此库尚未发布到 Maven Central 或其他公共仓库。要使用它：

### 选项 1: 从源码构建

```bash
cd kotlin
gradle build
gradle publishToMavenLocal
```

然后在你的项目中添加 mavenLocal() 仓库并引用：

```kotlin
repositories {
    mavenLocal()
    mavenCentral()
}

dependencies {
    implementation("com.hachi64:hachi64:1.0.0")
}
```

### 选项 2: 作为子项目包含

在你的 settings.gradle.kts 中：

```kotlin
includeBuild("../path/to/Hachi64/kotlin")
```

### 环境要求

- JDK 8 或更高版本
- Gradle 8.0 或更高版本

### 运行测试

```bash
# 运行所有平台的测试
gradle allTests

# 只运行 JVM 测试
gradle jvmTest

# 只运行 JavaScript 测试
gradle jsTest
```

## 使用方法

### 基本用法

```kotlin
import com.hachi64.Hachi64

fun main() {
    // 编码
    val data = "Hello, World!".encodeToByteArray()
    val encoded = Hachi64.encode(data)
    println("编码结果: $encoded")
    // 输出: 豆米啊拢嘎米多拢迷集伽漫咖苦播库迷律==
    
    // 解码
    val decoded = Hachi64.decode(encoded)
    val original = decoded.decodeToString()
    println("解码结果: $original")
    // 输出: Hello, World!
}
```

### 不带填充的编码

```kotlin
// 编码时不使用 '=' 填充
val encodedNoPad = Hachi64.encode(data, false)

// 解码时指定无填充
val decoded = Hachi64.decode(encodedNoPad, false)
```

## API 文档

### `Hachi64` 对象

#### 方法

- `fun encode(data: ByteArray): String` - 使用默认填充模式编码字节数组
- `fun encode(data: ByteArray, padding: Boolean): String` - 编码字节数组，可选择是否使用填充
- `fun decode(encodedStr: String): ByteArray` - 使用默认填充模式解码字符串
- `fun decode(encodedStr: String, padding: Boolean): ByteArray` - 解码字符串，可选择是否使用填充

#### 常量

- `const val HACHI_ALPHABET: String` - 哈吉米64字符集（64个中文字符）

## 字符集说明

哈吉米64使用以下64个中文字符：

```
哈蛤呵吉急集米咪迷南男难北背杯绿律虑豆斗抖啊阿额西希息嘎咖伽花华哗压鸭呀库酷苦奶乃耐龙隆拢曼慢漫波播玻叮丁订咚东冬囊路陆多都弥济
```

这些字符按发音相似性分组，使编码结果具有良好的视觉和听觉和谐性。

## 编码示例

| 原始数据 | 编码结果 |
|---------|---------|
| `Hello` | `豆米啊拢嘎米多=` |
| `abc` | `西阿南呀` |
| `Python` | `抖咪酷丁息米都慢` |
| `Hello, World!` | `豆米啊拢嘎米多拢迷集伽漫咖苦播库迷律==` |
| `Base64` | `律苦集叮希斗西丁` |
| `Hachi64` | `豆米集呀息米库咚背哈==` |

## 多平台支持

本实现基于 Kotlin Multiplatform，支持以下目标平台：

### 已启用的平台
- **JVM** - Java虚拟机平台
- **JavaScript (Node.js)** - Node.js 环境

### 可选的 Native 平台
以下 Native 平台在 `build.gradle.kts` 中已定义但默认注释掉了，因为它们需要下载预编译的 Kotlin/Native 二进制文件。在本地开发环境中，如果有网络访问权限，可以取消注释以启用：

- `linuxX64` - Linux x64
- `macosX64` - macOS x64
- `macosArm64` - macOS ARM64 (Apple Silicon)
- `mingwX64` - Windows x64

要启用 Native 平台，只需在 `build.gradle.kts` 中取消注释相应的平台配置即可。

## 项目结构

```
kotlin/
├── build.gradle.kts                          # Gradle 项目配置
├── settings.gradle.kts                       # Gradle 设置
├── README.md                                 # 本文档
└── src/
    ├── commonMain/
    │   └── kotlin/
    │       └── com/
    │           └── hachi64/
    │               └── Hachi64.kt            # 主实现类
    └── commonTest/
        └── kotlin/
            └── com/
                └── hachi64/
                    └── Hachi64Test.kt        # 单元测试
```

## 依赖管理

本项目使用 Gradle 进行依赖管理。主要依赖：

- Kotlin Multiplatform Plugin 2.0.21
- Kotlin Test (用于单元测试)

## 开发说明

### 添加新的测试

在 `src/commonTest/kotlin/com/hachi64/Hachi64Test.kt` 中添加新的测试用例。由于使用了 `commonTest`，这些测试将在所有启用的平台上运行。

### 发布

本库可以发布到 Maven Central 或其他 Maven 仓库。需要在 `build.gradle.kts` 中配置发布信息。

## 许可证

与主项目保持一致。

## 相关链接

- [项目主页](../../README.md)
- [实现指南](../../docs/implemtation_guide.md)
- [Java 实现](../java/README.md)
- [Python 实现](../python/README.md)
- [C# 实现](../csharp/README.md)
- [Rust 实现](../rust/README.md)
- [JavaScript/TypeScript 实现](../js/README.md)
