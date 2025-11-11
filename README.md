<div align="center">

# 🐱 哈基米64 (Hachi64)

### *使用哈基米64字符集来进行编码和解码*
#### 既要编码也要解码吗? 哈基米64 你这家伙! 😸

<br>

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Languages](https://img.shields.io/badge/languages-12-blue.svg)](#多语言支持)
<!-- [![GitHub Stars](https://img.shields.io/github/stars/fengb3/Hachi64?style=social)](https://github.com/fengb3/Hachi64) -->

</div>

---

## 📋 目录

- [✨ 概述](#-概述)
- [ 多语言支持](#-多语言支持)
- [📄 License](#-license)

---

## ✨ 概述

本项目提供了使用哈基米64个字符集来创建哈基米风格编码的工具。哈基米64(Hachi64)使用64个中文字符，这些字符按发音相似性分组，使编码后的字符串看起来更加和谐统一 (没想到把。

<br>

<table>
<tr>
<td width="50%" valign="top">

### 🎯 字符集特点

- ✅ **64个唯一中文字符**  
  完全符合Base64编码要求
- 🎵 **发音分组**  
  大部分音组包含3个同音字或近音字，分布平衡
- 🎨 **视觉和谐**  
  编码结果看起来像哈基米风格的文字
- 🔄 **完全可逆**  
  编码解码过程无损，与原始数据完全一致

</td>
<td width="50%" valign="top">

### 🎪 适用场景

- 🎭 创建具有哈基米风格的编码数据
- 🧘 在需要Base64功能的同时保持精神层面的抽象
- 🐈 代码运行的同时保持对猫猫的喜爱
- 🛡️ 避免特定上下文被网络模因污染

</td>
</tr>
</table>

<br>

<details>
<summary><b>🔤 字符集分组详情</b> (点击展开查看完整的64个字符)</summary>

<br>

哈基米64字符集按发音相似性分组，共19个音组，64个字符：

<table>
<tr>
<td width="25%"><b>哈音组</b> (3个)<br>哈、蛤、呵</td>
<td width="25%"><b>吉音组</b> (6个)<br>吉、急、集、都、弥、济</td>
<td width="25%"><b>米音组</b> (6个)<br>米、咪、迷</td>
<td width="25%"><b>南音组</b> (6个)<br>南、男、难、囊、路、陆</td>
</tr>
<tr>
<td><b>北音组</b> (3个)<br>北、背、杯</td>
<td><b>绿音组</b> (3个)<br>绿、律、虑</td>
<td><b>豆音组</b> (4个)<br>豆、斗、抖、多</td>
<td><b>啊音组</b> (3个)<br>啊、阿、额</td>
</tr>
<tr>
<td><b>西音组</b> (3个)<br>西、希、息</td>
<td><b>嘎音组</b> (3个)<br>嘎、咖、伽</td>
<td><b>花音组</b> (3个)<br>花、华、哗</td>
<td><b>压音组</b> (3个)<br>压、鸭、呀</td>
</tr>
<tr>
<td><b>库音组</b> (3个)<br>库、酷、苦</td>
<td><b>奶音组</b> (3个)<br>奶、乃、耐</td>
<td><b>龙音组</b> (3个)<br>龙、隆、拢</td>
<td><b>曼音组</b> (3个)<br>曼、慢、漫</td>
</tr>
<tr>
<td><b>波音组</b> (3个)<br>波、播、玻</td>
<td><b>叮音组</b> (3个)<br>叮、丁、订</td>
<td><b>咚音组</b> (3个)<br>咚、东、冬</td>
<td></td>
</tr>
</table>

> **总计64个字符**，发音分布相对平衡，编码结果具有良好的视觉和听觉和谐性。

</details>

> **⚠️ 注意：** 使用哈基米字母表会使您编码的数据与标准 Base64 解码器不兼容。仅在您完全控制编码、解码过程以及猫猫时才使用此功能。

---

## 🚀 快速开始

```bash
# 示例: "Hello" 编码后的结果
输入: Hello
输出: 豆米啊拢嘎米多=
```

选择您喜欢的编程语言，立即开始使用！👇

---

## 💻 多语言支持

<table>
<tr>
<td align="center"><b>语言</b></td>
<td align="center"><b>包管理器</b></td>
<td align="center"><b>版本</b></td>
<td align="center"><b>文档</b></td>
</tr>
<tr>
<td>🔷 <b>C++</b></td>
<td>Header-only</td>
<td><img src="https://img.shields.io/badge/library-header--only-blue" alt="Header-only"></td>
<td><a href="./cpp/README.md">📖 文档</a></td>
</tr>
<tr>
<td>🟣 <b>C# (.NET)</b></td>
<td>NuGet</td>
<td><img src="https://img.shields.io/nuget/v/Hachi64?label=NuGet&color=blue" alt="NuGet"></td>
<td><a href="./csharp/README.md">📖 文档</a></td>
</tr>
<tr>
<td>🎯 <b>Dart</b></td>
<td>pub.dev</td>
<td><img src="https://img.shields.io/pub/v/hachi64?label=pub.dev&color=blue" alt="Pub Version"></td>
<td><a href="./dart/README.md">📖 文档</a></td>
</tr>
<tr>
<td>🐹 <b>Go</b></td>
<td>Go Module</td>
<td><img src="https://img.shields.io/badge/go%20module-v0.1.1-blue" alt="Go Module"></td>
<td><a href="./go/README.md">📖 文档</a></td>
</tr>
<tr>
<td>☕ <b>Java</b></td>
<td>Maven Central</td>
<td><img src="https://img.shields.io/maven-central/v/io.github.fengb3/hachi64?label=Maven%20Central&color=blue" alt="Maven Central"></td>
<td><a href="./java/README.md">📖 文档</a></td>
</tr>
<tr>
<td>🟨 <b>JavaScript/TypeScript</b></td>
<td>npm</td>
<td><img src="https://img.shields.io/npm/v/hachi64?label=npm&color=blue" alt="npm"></td>
<td><a href="./js/README.md">📖 文档</a></td>
</tr>
<tr>
<td>🟪 <b>Kotlin</b></td>
<td>Maven (source)</td>
<td><img src="https://img.shields.io/badge/status-source%20only-orange" alt="Status"></td>
<td><a href="./kotlin/README.md">📖 文档</a></td>
</tr>
<tr>
<td>🐘 <b>PHP</b></td>
<td>Packagist</td>
<td><img src="https://img.shields.io/packagist/v/hachi64/hachi64?label=Packagist&color=blue" alt="Packagist"></td>
<td><a href="./php/README.md">📖 文档</a></td>
</tr>
<tr>
<td>🐍 <b>Python</b></td>
<td>PyPI</td>
<td><img src="https://img.shields.io/pypi/v/hachi64?label=PyPI&color=blue" alt="PyPI"></td>
<td><a href="./python/README.md">📖 文档</a></td>
</tr>
<tr>
<td>💎 <b>Ruby</b></td>
<td>RubyGems</td>
<td><img src="https://img.shields.io/gem/v/hachi64?label=RubyGems&color=blue" alt="Gem Version"></td>
<td><a href="./ruby/README.md">📖 文档</a></td>
</tr>
<tr>
<td>🦀 <b>Rust</b></td>
<td>crates.io</td>
<td><img src="https://img.shields.io/crates/v/hachi64?label=crates.io&color=blue" alt="Crates.io"></td>
<td><a href="./rust/README.md">📖 文档</a></td>
</tr>
<tr>
<td>🍎 <b>Swift</b></td>
<td>SPM</td>
<td><img src="https://img.shields.io/badge/version-0.1.1-blue" alt="Version"></td>
<td><a href="./swift/README.md">📖 文档</a></td>
</tr>
</table>

<br>

<details>
<summary><b>📦 安装和使用示例</b> (点击展开)</summary>

<br>

### C++
```cpp
// Header-only 库，只需包含头文件
#include "hachi64/hachi64.hpp"

std::string encoded = hachi64::encode({72, 101, 108, 108, 111});  // "豆米啊拢嘎米多="
std::vector<uint8_t> decoded = hachi64::decode(encoded);          // "Hello"
```

### C# (.NET)
```bash
dotnet add package Hachi64 --version 0.1.0
```
```csharp
byte[] data = Encoding.UTF8.GetBytes("Hello");
string encoded = Hachi64.Encode(data);           // "豆米啊拢嘎米多="
byte[] decoded = Hachi64.Decode(encoded);        // "Hello"
```

### Dart
```yaml
dependencies:
  hachi64: ^0.1.1
```
```dart
final encoded = Hachi64.encode(Uint8List.fromList(utf8.encode('Hello')));  // "豆米啊拢嘎米多="
final decoded = Hachi64.decode(encoded);                                   // "Hello"
```

### Go
```bash
go get github.com/fengb3/Hachi64/go@v0.1.1
```
```go
encoded := hachi64.Encode([]byte("Hello"), true)    // "豆米啊拢嘎米多="
decoded, _ := hachi64.Decode(encoded, true)         // "Hello"
```

### Java
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

### JavaScript/TypeScript
```bash
npm install hachi64@0.1.2
```
```typescript
import { encode, decode } from 'hachi64';
const encoded = encode(Buffer.from('Hello'));  // "豆米啊拢嘎米多="
const decoded = decode(encoded);               // "Hello"
```

### Kotlin
```kotlin
// 从源码构建或使用 mavenLocal
implementation("com.hachi64:hachi64:1.0.0")
```
```kotlin
val encoded = Hachi64.encode("Hello".encodeToByteArray())  // "豆米啊拢嘎米多="
val decoded = Hachi64.decode(encoded).decodeToString()     // "Hello"
```

### PHP
```bash
composer require hachi64/hachi64:0.1.2
```
```php
$encoded = Hachi64::encode("Hello");  // "豆米啊拢嘎米多="
$decoded = Hachi64::decode($encoded); // "Hello"
```

### Python
```bash
pip install hachi64
```
```python
from hachi64 import hachi64
encoded = hachi64.encode(b"Hello")  # "豆米啊拢嘎米多="
decoded = hachi64.decode(encoded)   # b"Hello"
```

### Ruby
```bash
gem install hachi64
```
```ruby
encoded = Hachi64.encode("Hello")  # "豆米啊拢嘎米多="
decoded = Hachi64.decode(encoded)  # "Hello"
```

### Rust
```toml
[dependencies]
hachi64 = "0.1.6"
```
```rust
use hachi64::{encode, decode};
let encoded = encode(b"Hello");       // "豆米啊拢嘎米多="
let decoded = decode(&encoded)?;      // b"Hello"
```

### Swift
```swift
dependencies: [
    .package(url: "https://github.com/fengb3/Hachi64.git", from: "0.1.1")
]
```
```swift
let encoded = Hachi64.encode("Hello".data(using: .utf8)!)  // "豆米啊拢嘎米多="
let decoded = try Hachi64.decode(encoded)                  // "Hello"
```

</details>

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

### 🌟 喜欢这个项目？

给我们一个 ⭐ Star 吧！

<br>

Made with 💖 and 🐱 by the Hachi64 community

<br>

[🐛 报告问题](https://github.com/fengb3/Hachi64/issues) • [💡 功能建议](https://github.com/fengb3/Hachi64/issues) • [🤝 贡献代码](https://github.com/fengb3/Hachi64/pulls)

</div>
