# 哈吉米64(Hachi64) 编解码器

*使用哈吉米64字符集来进行编码和解码。既要编码也要解码吗? 哈吉米64 你这家伙!*

## 概述

本项目提供了使用哈吉米64个字符集来创建哈吉米风格编码的工具。哈吉米64(Hachi64)使用64个中文字符，这些字符按发音相似性分组，使编码后的字符串看起来更加和谐统一 (没想到把。

### 字符集特点
- **64个唯一中文字符**：完全符合Base64编码要求
- **发音分组**：大部分音组包含3个同音字或近音字，分布平衡
- **视觉和谐**：编码结果看起来像哈吉米风格的文字
- **完全可逆**：编码解码过程无损，与原始数据完全一致

### 适用场景
- 创建具有哈吉米风格的编码数据
- 在需要Base64功能的同时保持精神层面的抽象
- 代码运行的同时保持对猫猫的喜爱
- 避免特定上下文不被网络模因污染

**注意：** 使用哈吉米字母表会使您编码的数据与标准 Base64 解码器不兼容。仅在您完全控制编码,解码过程以及猫猫时才使用此功能。

## 多语言支持

### C++
![Header-only](https://img.shields.io/badge/library-header--only-blue)

```bash
# Header-only 库，只需包含头文件
#include "hachi64/hachi64.hpp"
```
```cpp
std::string encoded = hachi64::encode({72, 101, 108, 108, 111});  // "豆米啊拢嘎米多="
std::vector<uint8_t> decoded = hachi64::decode(encoded);          // "Hello"
```
[📖 详细文档](./cpp/README.md)

---

### C# (.NET)
![NuGet](https://img.shields.io/nuget/v/Hachi64?label=NuGet&color=blue)

```bash
dotnet add package Hachi64 --version 0.1.0
```
```csharp
byte[] data = Encoding.UTF8.GetBytes("Hello");
string encoded = Hachi64.Encode(data);           // "豆米啊拢嘎米多="
byte[] decoded = Hachi64.Decode(encoded);        // "Hello"
```
[📖 详细文档](./csharp/README.md)

---

### Dart
![Pub Version](https://img.shields.io/pub/v/hachi64?label=pub.dev&color=blue)

```yaml
dependencies:
  hachi64: ^0.1.1
```
```dart
final encoded = Hachi64.encode(Uint8List.fromList(utf8.encode('Hello')));  // "豆米啊拢嘎米多="
final decoded = Hachi64.decode(encoded);                                   // "Hello"
```
[📖 详细文档](./dart/README.md)

---

### Go
![Go Version](https://img.shields.io/github/go-mod/go-version/fengb3/Hachi64?filename=go%2Fgo.mod&label=Go)
![Go Module](https://img.shields.io/badge/go%20module-v0.1.1-blue)

```bash
go get github.com/fengb3/Hachi64/go@v0.1.1
```
```go
encoded := hachi64.Encode([]byte("Hello"), true)    // "豆米啊拢嘎米多="
decoded, _ := hachi64.Decode(encoded, true)         // "Hello"
```
[📖 详细文档](./go/README.md)

---

### Java
![Maven Central](https://img.shields.io/maven-central/v/io.github.fengb3/hachi64?label=Maven%20Central&color=blue)

```xml
<dependency>
    <groupId>io.github.fengb3</groupId>
    <artifactId>hachi64</artifactId>
    <version>0.1.0</version>
</dependency>
```
```java
String encoded = Hachi64.encode("Hello".getBytes(StandardCharsets.UTF_8));  // "豆米啊拢嘎米多="
byte[] decoded = Hachi64.decode(encoded);                                   // "Hello"
```
[📖 详细文档](./java/README.md)

---

### JavaScript/TypeScript
![npm](https://img.shields.io/npm/v/hachi64?label=npm&color=blue)

```bash
npm install hachi64@0.1.2
```
```typescript
import { encode, decode } from 'hachi64';
const encoded = encode(Buffer.from('Hello'));  // "豆米啊拢嘎米多="
const decoded = decode(encoded);               // "Hello"
```
[📖 详细文档](./js/README.md)

---

### Kotlin
![Kotlin Multiplatform](https://img.shields.io/badge/Kotlin-Multiplatform-blue)
![Status](https://img.shields.io/badge/status-source%20only-orange)

```kotlin
// 从源码构建或使用 mavenLocal
implementation("com.hachi64:hachi64:1.0.0")
```
```kotlin
val encoded = Hachi64.encode("Hello".encodeToByteArray())  // "豆米啊拢嘎米多="
val decoded = Hachi64.decode(encoded).decodeToString()     // "Hello"
```
[📖 详细文档](./kotlin/README.md)

---

### PHP
![Packagist Version](https://img.shields.io/packagist/v/hachi64/hachi64?label=Packagist&color=blue)

```bash
composer require hachi64/hachi64:0.1.2
```
```php
$encoded = Hachi64::encode("Hello");  // "豆米啊拢嘎米多="
$decoded = Hachi64::decode($encoded); // "Hello"
```
[📖 详细文档](./php/README.md)

---

### Python
![PyPI](https://img.shields.io/pypi/v/hachi64?label=PyPI&color=blue)

```bash
pip install hachi64
```
```python
from hachi64 import hachi64
encoded = hachi64.encode(b"Hello")  # "豆米啊拢嘎米多="
decoded = hachi64.decode(encoded)   # b"Hello"
```
[📖 详细文档](./python/README.md)

---

### Ruby
![Gem Version](https://img.shields.io/gem/v/hachi64?label=RubyGems&color=blue)

```bash
gem install hachi64
```
```ruby
encoded = Hachi64.encode("Hello")  # "豆米啊拢嘎米多="
decoded = Hachi64.decode(encoded)  # "Hello"
```
[📖 详细文档](./ruby/README.md)

---

### Rust
![Crates.io](https://img.shields.io/crates/v/hachi64?label=crates.io&color=blue)

```toml
[dependencies]
hachi64 = "0.1.6"
```
```rust
use hachi64::{encode, decode};
let encoded = encode(b"Hello");       // "豆米啊拢嘎米多="
let decoded = decode(&encoded)?;      // b"Hello"
```
[📖 详细文档](./rust/README.md)

---

### Swift
![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-blue)
![Version](https://img.shields.io/badge/version-0.1.1-blue)

```swift
dependencies: [
    .package(url: "https://github.com/fengb3/Hachi64.git", from: "0.1.1")
]
```
```swift
let encoded = Hachi64.encode("Hello".data(using: .utf8)!)  // "豆米啊拢嘎米多="
let decoded = try Hachi64.decode(encoded)                  // "Hello"
```
[📖 详细文档](./swift/README.md)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 字符集分组

哈吉米64字符集按发音相似性分组，主要音组包括：

- **哈音组**(3个): 哈、蛤、呵
- **吉音组**(6个): 吉、急、集、都、弥、济  
- **米音组**(6个): 米、咪、迷
- **南音组**(6个): 南、男、难、囊、路、陆
- **北音组**(3个): 北、背、杯
- **绿音组**(3个): 绿、律、虑
- **豆音组**(4个): 豆、斗、抖、多
- **啊音组**(3个): 啊、阿、额
- **西音组**(3个): 西、希、息
- **嘎音组**(3个): 嘎、咖、伽
- **花音组**(3个): 花、华、哗
- **压音组**(3个): 压、鸭、呀
- **库音组**(3个): 库、酷、苦
- **奶音组**(3个): 奶、乃、耐
- **龙音组**(3个): 龙、隆、拢
- **曼音组**(3个): 曼、慢、漫
- **波音组**(3个): 波、播、玻
- **叮音组**(3个): 叮、丁、订
- **咚音组**(3个): 咚、东、冬

总计64个字符，发音分布相对平衡，编码结果具有良好的视觉和听觉和谐性。
