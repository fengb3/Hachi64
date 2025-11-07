# Hachi64 Ruby Implementation

哈吉米64 编解码器的 Ruby 实现 - 使用64个中文字符进行 Base64 风格的编码和解码。

## 安装

### 从源码安装

```bash
cd ruby
gem build hachi64.gemspec
gem install hachi64-0.1.0.gem
```

### 在项目中使用

如果不想安装 gem，可以直接在项目中引用：

```ruby
require_relative 'lib/hachi64'
```

### 运行示例

查看并运行 `example.rb` 来了解基本用法：

```bash
ruby example.rb
```

## 使用方法

### 基本使用

```ruby
require 'hachi64'

# 编码
data = "Hello, World!"
encoded = Hachi64.encode(data)
puts encoded # 输出: 豆米啊拢嘎米多拢迷集伽漫咖苦播库迷律==

# 解码
decoded = Hachi64.decode(encoded)
puts decoded # 输出: Hello, World!
```

### 不使用填充

```ruby
# 编码时不使用填充
encoded = Hachi64.encode("Hello", padding: false)
puts encoded # 输出: 豆米啊拢嘎米多

# 解码时指定无填充
decoded = Hachi64.decode(encoded, padding: false)
puts decoded # 输出: Hello
```

### 处理二进制数据

```ruby
# Hachi64 可以处理任意二进制数据
binary_data = File.read("image.png", mode: "rb")
encoded = Hachi64.encode(binary_data)
decoded = Hachi64.decode(encoded)

# 验证数据完整性
puts binary_data == decoded # 输出: true
```

## API 文档

### `Hachi64.encode(data, padding: true)`

将字节字符串编码为哈吉米64字符串。

**参数:**
- `data` (String): 要编码的数据（二进制字符串）
- `padding` (Boolean): 是否使用 `=` 进行填充（默认为 `true`）

**返回:**
- (String): 编码后的字符串

**示例:**
```ruby
Hachi64.encode("Hello")  # => "豆米啊拢嘎米多="
Hachi64.encode("Hello", padding: false)  # => "豆米啊拢嘎米多"
```

### `Hachi64.decode(encoded_str, padding: true)`

将哈吉米64字符串解码为字节字符串。

**参数:**
- `encoded_str` (String): 要解码的字符串
- `padding` (Boolean): 输入字符串是否使用 `=` 进行填充（应与编码时的设置一致，默认为 `true`）

**返回:**
- (String): 解码后的字节字符串

**异常:**
- `ArgumentError`: 如果输入包含无效字符

**示例:**
```ruby
Hachi64.decode("豆米啊拢嘎米多=")  # => "Hello"
Hachi64.decode("豆米啊拢嘎米多", padding: false)  # => "Hello"
```

### `Hachi64::HACHI_ALPHABET`

哈吉米64字符集常量，包含64个中文字符。

```ruby
puts Hachi64::HACHI_ALPHABET
# => "哈蛤呵吉急集米咪迷南男难北背杯绿律虑豆斗抖啊阿额西希息嘎咖伽花华哗压鸭呀库酷苦奶乃耐龙隆拢曼慢漫波播玻叮丁订咚东冬囊路陆多都弥济"
```

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
cd ruby
bundle install  # 安装开发依赖
bundle exec rspec
```

或者直接使用 RSpec（如果已全局安装）：

```bash
cd ruby
rspec
```

## 特性

- ✅ 完整的编码/解码功能
- ✅ 支持有/无填充模式
- ✅ 处理任意二进制数据
- ✅ 与其他语言实现兼容
- ✅ 完整的 RSpec 测试覆盖
- ✅ 清晰的错误处理
- ✅ 符合 Ruby 编码规范

## 开发

### 安装依赖

```bash
bundle install
```

### 运行测试

```bash
bundle exec rspec
```

### 构建 gem

```bash
gem build hachi64.gemspec
```

## 许可证

本项目遵循父项目的许可证。
