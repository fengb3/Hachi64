# Hachi64 Go Implementation

哈吉米64 编解码器的 Go 实现 - 使用64个中文字符进行 Base64 风格的编码和解码。

## 安装

```bash
go get github.com/fengb3/Hachi64/go
```

## 使用方法

### 基本使用

```go
package main

import (
    "fmt"
    "github.com/fengb3/Hachi64/go"
)

func main() {
    // 编码
    data := []byte("Hello, World!")
    encoded := hachi64.Encode(data, true)
    fmt.Println(encoded) // 输出: 豆米啊拢嘎米多拢迷集伽漫咖苦播库迷律==

    // 解码
    decoded, err := hachi64.Decode(encoded, true)
    if err != nil {
        panic(err)
    }
    fmt.Println(string(decoded)) // 输出: Hello, World!
}
```

### 不使用填充

```go
// 编码时不使用填充
encoded := hachi64.Encode([]byte("Hello"), false)
fmt.Println(encoded) // 输出: 豆米啊拢嘎米多

// 解码时指定无填充
decoded, err := hachi64.Decode(encoded, false)
if err != nil {
    panic(err)
}
fmt.Println(string(decoded)) // 输出: Hello
```

## API 文档

### `Encode(data []byte, padding bool) string`

将字节数组编码为哈吉米64字符串。

**参数:**
- `data`: 要编码的字节数组
- `padding`: 是否使用 `=` 进行填充（通常设为 `true`）

**返回:**
- 编码后的字符串

### `Decode(encodedStr string, padding bool) ([]byte, error)`

将哈吉米64字符串解码为字节数组。

**参数:**
- `encodedStr`: 要解码的字符串
- `padding`: 输入字符串是否使用 `=` 进行填充（应与编码时的设置一致）

**返回:**
- 解码后的字节数组
- 错误（如果输入包含无效字符）

### `HachiAlphabet`

哈吉米64字符集常量，包含64个中文字符。

## 编码示例

以下是一些使用哈吉米64编码的示例：

| 原始数据 | 编码结果 |
|---------|---------|
| `Hello` | `豆米啊拢嘎米多=` |
| `abc` | `西阿南呀` |
| `Python` | `抖咪酷丁息米都慢` |
| `Hello, World!` | `豆米啊拢嘎米多拢迷集伽漫咖苦播库迷律==` |
| `Base64` | `律苦集叮希斗西丁` |
| `Hachi64` | `豆米集呀息米库咚背哈==` |

## 测试

运行单元测试：

```bash
go test -v
```

运行基准测试：

```bash
go test -bench=.
```

## 特性

- ✅ 完整的编码/解码功能
- ✅ 支持有/无填充模式
- ✅ 处理任意二进制数据
- ✅ 与其他语言实现兼容
- ✅ 完整的单元测试覆盖
- ✅ 清晰的错误处理

## 许可证

本项目遵循父项目的许可证。
