# Hachi64 Rust 实现

哈基米64编解码器的 Rust 实现，使用64个中文字符进行 Base64 风格的编码和解码。

## 特性

- 使用固定的哈基米64字符集（64个中文字符）
- 支持带填充和不带填充两种模式
- 提供多种调用方式（实例方法、静态方法、便捷函数）
- 完全符合 Base64 编码标准
- 类型安全，性能优异

## 快速开始

### 添加依赖

```toml
[dependencies]
hachi64 = "0.1.6"
```

或使用 cargo 命令：

```bash
cargo add hachi64
```

### 基本用法

```rust
use hachi64::{Hachi64, encode, decode};

fn main() {
    // 方式 1: 使用便捷函数（推荐）
    let encoded = encode(b"Hello");
    println!("编码结果: {}", encoded);  // 豆米啊拢嘎米多=
    
    let decoded = decode(&encoded).unwrap();
    println!("解码结果: {:?}", String::from_utf8(decoded).unwrap());  // Hello
    
    // 方式 2: 使用实例方法
    let encoder = Hachi64::new();
    let encoded = encoder.encode(b"Hello");
    let decoded = encoder.decode(&encoded).unwrap();
    
    // 方式 3: 使用静态方法
    let encoded = Hachi64::encode_static(b"Hello");
    let decoded = Hachi64::decode_static(&encoded).unwrap();
}
```

### 不使用填充

```rust
use hachi64::Hachi64;

let encoder = Hachi64::with_padding(false);
let encoded = encoder.encode(b"Hello");
println!("{}", encoded);  // 豆米啊拢嘎米多
```

## 编码示例

根据主 README 文档中的示例：

| 原始数据 | 编码结果 | 
|---------|---------|
| `"Hello"` | `豆米啊拢嘎米多=` |
| `"abc"` | `西阿南呀` |
| `"Python"` | `抖咪酷丁息米都慢` |
| `"Hello, World!"` | `豆米啊拢嘎米多拢迷集伽漫咖苦播库迷律==` |
| `"Base64"` | `律苦集叮希斗西丁` |
| `"Hachi64"` | `豆米集呀息米库咚背哈==` |

## API 文档

### 结构体

#### `Hachi64`

哈基米64编码器/解码器。

**方法:**

- `new() -> Self` - 创建新实例（默认带填充）
- `with_padding(padding: bool) -> Self` - 创建新实例并指定填充选项
- `encode(&self, data: &[u8]) -> String` - 编码字节数组
- `decode(&self, encoded_str: &str) -> Result<Vec<u8>, HachiError>` - 解码字符串
- `encode_static(data: &[u8]) -> String` - 静态编码方法
- `decode_static(encoded_str: &str) -> Result<Vec<u8>, HachiError>` - 静态解码方法

### 便捷函数

- `encode(data: &[u8]) -> String` - 使用默认设置编码
- `decode(encoded_str: &str) -> Result<Vec<u8>, HachiError>` - 使用默认设置解码

### 错误类型

#### `HachiError`

- `InvalidInput` - 输入字符串包含不在字符集中的字符

## 运行测试

```bash
cargo test
```

## 许可证

MIT
