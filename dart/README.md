# 哈吉米64 (Hachi64) - Dart 实现

Dart 实现的哈吉米64编解码器，使用64个中文字符进行 Base64 风格的编码和解码。适用于 Flutter 和 Dart Web 应用。

## 功能特性

- 使用64个中文字符（哈吉米字符集）进行编码
- 完全可逆的编码解码过程
- 支持带填充和不带填充的编码模式
- 兼容标准 Base64 的编码原理
- **多平台支持**: Flutter (iOS/Android), Web, Desktop
- 零依赖（除了开发测试依赖）

## 快速开始

### 环境要求

- Dart SDK 2.12.0 或更高版本
- 对于 Flutter 项目: Flutter SDK 2.0.0 或更高版本

### 安装

从 pub.dev 安装：

```yaml
dependencies:
  hachi64: ^0.1.1
```

然后运行：

```bash
dart pub get
# 或者在 Flutter 项目中
flutter pub get
```

### 构建和测试

```bash
# 获取依赖
dart pub get

# 运行测试
dart test

# 运行测试并显示详细输出
dart test --reporter expanded
```

## 使用方法

### 基本用法

```dart
import 'dart:typed_data';
import 'dart:convert';
import 'package:hachi64/hachi64.dart';

void main() {
  // 编码
  final data = utf8.encode('Hello, World!');
  final encoded = Hachi64.encode(Uint8List.fromList(data));
  print('编码结果: $encoded');
  // 输出: 豆米啊拢嘎米多拢迷集伽漫咖苦播库迷律==
  
  // 解码
  final decoded = Hachi64.decode(encoded);
  final original = utf8.decode(decoded);
  print('解码结果: $original');
  // 输出: Hello, World!
}
```

### 不带填充的编码

```dart
import 'dart:typed_data';
import 'dart:convert';
import 'package:hachi64/hachi64.dart';

void main() {
  final data = utf8.encode('Hello');
  
  // 编码时不使用 '=' 填充
  final encodedNoPad = Hachi64.encode(
    Uint8List.fromList(data), 
    padding: false
  );
  print(encodedNoPad); // 输出: 豆米啊拢嘎米多
  
  // 解码时指定无填充
  final decoded = Hachi64.decode(encodedNoPad, padding: false);
  print(utf8.decode(decoded)); // 输出: Hello
}
```

### 在 Flutter 中使用

```dart
import 'package:flutter/material.dart';
import 'package:hachi64/hachi64.dart';
import 'dart:typed_data';
import 'dart:convert';

class Hachi64Demo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = utf8.encode('Flutter is awesome!');
    final encoded = Hachi64.encode(Uint8List.fromList(data));
    final decoded = Hachi64.decode(encoded);
    
    return Column(
      children: [
        Text('原始文本: Flutter is awesome!'),
        Text('编码结果: $encoded'),
        Text('解码结果: ${utf8.decode(decoded)}'),
      ],
    );
  }
}
```

## API 文档

### `Hachi64` 类

#### 静态方法

##### `encode(Uint8List data, {bool padding = true}) → String`

将字节数组编码为哈吉米64字符串。

**参数:**
- `data`: 要编码的字节数组 (Uint8List)
- `padding`: 是否使用 `=` 进行填充（默认为 `true`）

**返回:**
- 编码后的字符串

**示例:**
```dart
final bytes = Uint8List.fromList([72, 101, 108, 108, 111]);
final encoded = Hachi64.encode(bytes);
print(encoded); // 豆米啊拢嘎米多=
```

##### `decode(String encodedStr, {bool padding = true}) → Uint8List`

将哈吉米64字符串解码为字节数组。

**参数:**
- `encodedStr`: 要解码的字符串
- `padding`: 输入字符串是否使用 `=` 进行填充（应与编码时的设置一致，默认为 `true`）

**返回:**
- 解码后的字节数组 (Uint8List)

**异常:**
- `FormatException`: 如果输入包含无效字符

**示例:**
```dart
final decoded = Hachi64.decode('豆米啊拢嘎米多=');
print(String.fromCharCodes(decoded)); // Hello
```

### 常量

#### `hachiAlphabet`

哈吉米64字符集常量，包含64个中文字符。

```dart
const String hachiAlphabet = "哈蛤呵吉急集米咪迷南男难北背杯绿律虑豆斗抖啊阿额西希息嘎咖伽花华哗压鸭呀库酷苦奶乃耐龙隆拢曼慢漫波播玻叮丁订咚东冬囊路陆多都弥济";
```

## 字符集说明

哈吉米64使用以下64个中文字符：

```
哈蛤呵吉急集米咪迷南男难北背杯绿律虑豆斗抖啊阿额西希息嘎咖伽花华哗压鸭呀库酷苦奶乃耐龙隆拢曼慢漫波播玻叮丁订咚东冬囊路陆多都弥济
```

这些字符按发音相似性分组，使编码结果具有良好的视觉和听觉和谐性。主要音组包括：

- **哈音组**(3个): 哈、蛤、呵
- **吉音组**(6个): 吉、急、集、都、弥、济  
- **米音组**(3个): 米、咪、迷
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

## 编码示例

| 原始数据 | 编码结果 |
|---------|---------|
| `Hello` | `豆米啊拢嘎米多=` |
| `abc` | `西阿南呀` |
| `Python` | `抖咪酷丁息米都慢` |
| `Hello, World!` | `豆米啊拢嘎米多拢迷集伽漫咖苦播库迷律==` |
| `Base64` | `律苦集叮希斗西丁` |
| `Hachi64` | `豆米集呀息米库咚背哈==` |

## 项目结构

```
dart/
├── lib/
│   └── hachi64.dart           # 主实现文件
├── test/
│   └── hachi64_test.dart      # 单元测试
├── pubspec.yaml               # 包配置文件
└── README.md                  # 本文档
```

## 测试

本实现包含全面的单元测试，覆盖以下场景：

- ✅ 编码解码一致性测试
- ✅ 特定编码结果验证
- ✅ 二进制数据处理
- ✅ 有/无填充模式
- ✅ 错误处理
- ✅ 字母表验证
- ✅ 边界情况测试

运行测试：

```bash
dart test
```

查看测试覆盖率：

```bash
dart test --coverage=coverage
dart pub global activate coverage
dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage.lcov --report-on=lib
```

## 性能

Hachi64 Dart 实现针对性能进行了优化：

- 使用 `StringBuffer` 进行高效字符串构建
- 预先构建反向映射表以加速解码
- 优化的位运算处理
- 最小化内存分配

## 多平台兼容性

本实现支持以下平台：

- ✅ **Dart VM** - 命令行应用
- ✅ **Flutter iOS** - iOS 应用
- ✅ **Flutter Android** - Android 应用
- ✅ **Flutter Web** - Web 应用
- ✅ **Flutter Desktop** - Windows/macOS/Linux 桌面应用

## 开发说明

### 添加新的测试

在 `test/hachi64_test.dart` 中添加新的测试用例。使用 `group()` 组织相关测试。

### 代码风格

本项目遵循 Dart 官方代码风格指南。使用 `dart format` 格式化代码：

```bash
dart format lib test
```

### 静态分析

运行静态分析检查代码质量：

```bash
dart analyze
```

## 注意事项

**重要提示：** 使用哈吉米字母表会使您编码的数据与标准 Base64 解码器不兼容。仅在您完全控制编码和解码过程时才使用此功能。

## 常见问题

### Q: 为什么编码结果全是中文？
A: 这正是哈吉米64的特色！它使用64个精心挑选的中文字符代替标准 Base64 的字符集，使编码结果看起来像是有意义的中文文本。

### Q: 可以和标准 Base64 互相转换吗？
A: 不能直接转换。哈吉米64使用的是自定义字符集，与标准 Base64 不兼容。

### Q: 性能如何？
A: Dart 实现经过优化，在编码和解码性能上与标准 Base64 相当。

### Q: 可以在 Flutter Web 中使用吗？
A: 可以！本实现完全支持 Flutter Web。

## 许可证

与主项目保持一致。

## 相关链接

- [项目主页](../../README.md)
- [实现指南](../../docs/implemtation_guide.md)
- [Python 实现](../python/README.md)
- [Go 实现](../go/README.md)
- [Java 实现](../java/README.md)
- [Kotlin 实现](../kotlin/README.md)
- [Rust 实现](../rust/README.md)
- [JavaScript/TypeScript 实现](../js/README.md)
- [C# 实现](../csharp/README.md)

---

# Hachi64 - Dart Implementation

A Dart implementation of the Hachi64 encoder/decoder, using 64 Chinese characters for Base64-style encoding. Perfect for Flutter and Dart Web applications.

## Features

- Encodes using 64 Chinese characters (Hachi alphabet)
- Fully reversible encoding/decoding process
- Supports both padded and unpadded encoding modes
- Compatible with standard Base64 encoding principles
- **Multi-platform support**: Flutter (iOS/Android), Web, Desktop
- Zero runtime dependencies

## Quick Start

### Requirements

- Dart SDK 2.12.0 or higher
- For Flutter projects: Flutter SDK 2.0.0 or higher

### Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  hachi64:
    path: ../dart  # if using local path
```

Then run:

```bash
dart pub get
# or in Flutter projects
flutter pub get
```

### Build and Test

```bash
# Get dependencies
dart pub get

# Run tests
dart test

# Run tests with verbose output
dart test --reporter expanded
```

## Usage

### Basic Usage

```dart
import 'dart:typed_data';
import 'dart:convert';
import 'package:hachi64/hachi64.dart';

void main() {
  // Encode
  final data = utf8.encode('Hello, World!');
  final encoded = Hachi64.encode(Uint8List.fromList(data));
  print('Encoded: $encoded');
  // Output: 豆米啊拢嘎米多拢迷集伽漫咖苦播库迷律==
  
  // Decode
  final decoded = Hachi64.decode(encoded);
  final original = utf8.decode(decoded);
  print('Decoded: $original');
  // Output: Hello, World!
}
```

### Encoding without Padding

```dart
import 'dart:typed_data';
import 'dart:convert';
import 'package:hachi64/hachi64.dart';

void main() {
  final data = utf8.encode('Hello');
  
  // Encode without '=' padding
  final encodedNoPad = Hachi64.encode(
    Uint8List.fromList(data), 
    padding: false
  );
  print(encodedNoPad); // Output: 豆米啊拢嘎米多
  
  // Decode without padding
  final decoded = Hachi64.decode(encodedNoPad, padding: false);
  print(utf8.decode(decoded)); // Output: Hello
}
```

## License

Consistent with the main project.

## Contributing

See the main project repository for contribution guidelines.
