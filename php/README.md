# Hachi64 - PHP 实现

哈吉米64 (Hachi64) 的 PHP 实现。使用64个中文字符进行 Base64 风格的编码和解码。

## 安装

### 使用 Composer

```bash
composer require hachi64/hachi64
```

### 手动安装

将 `src/Hachi64.php` 文件复制到你的项目中，并使用 `require` 或 `include` 引入。

## 使用方法

```php
<?php

require_once 'vendor/autoload.php';

use Hachi64\Hachi64;

// 编码
$data = "Hello, World!";
$encoded = Hachi64::encode($data);
echo "编码结果: " . $encoded . "\n";
// 输出: 编码结果: 豆米啊拢嘎米多拢迷集伽漫咖苦播库迷律==

// 解码
$decoded = Hachi64::decode($encoded);
echo "解码结果: " . $decoded . "\n";
// 输出: 解码结果: Hello, World!

// 无填充编码
$encodedNoPad = Hachi64::encode($data, false);
echo "无填充编码: " . $encodedNoPad . "\n";

// 无填充解码
$decodedNoPad = Hachi64::decode($encodedNoPad, false);
echo "无填充解码: " . $decodedNoPad . "\n";
```

## API 文档

### `Hachi64::encode($data, $padding = true)`

将字节数据编码为哈吉米64字符串。

**参数:**
- `$data` (string): 要编码的字节数据
- `$padding` (bool): 是否使用 '=' 进行填充，默认为 `true`

**返回值:**
- (string): 编码后的哈吉米64字符串

**异常:**
- `InvalidArgumentException`: 当 `$data` 为 `null` 时抛出

**示例:**
```php
$encoded = Hachi64::encode("Hello");
// 返回: "豆米啊拢嘎米多="
```

### `Hachi64::decode($encodedStr, $padding = true)`

将哈吉米64字符串解码为原始字节数据。

**参数:**
- `$encodedStr` (string): 要解码的哈吉米64字符串
- `$padding` (bool): 输入字符串是否使用 '=' 进行填充，默认为 `true`

**返回值:**
- (string): 解码后的字节数据

**异常:**
- `InvalidArgumentException`: 当 `$encodedStr` 为 `null` 或包含无效字符时抛出

**示例:**
```php
$decoded = Hachi64::decode("豆米啊拢嘎米多=");
// 返回: "Hello"
```

## 字符集

哈吉米64使用以下64个中文字符集：

```
哈蛤呵吉急集米咪迷南男难北背杯绿律虑豆斗抖啊阿额西希息嘎咖伽花华哗压鸭呀库酷苦奶乃耐龙隆拢曼慢漫波播玻叮丁订咚东冬囊路陆多都弥济
```

这些字符按发音相似性分组，使编码后的字符串看起来更加和谐统一。

## 编码示例

| 原始数据 | 编码结果 |
|---------|---------|
| `"Hello"` | `豆米啊拢嘎米多=` |
| `"abc"` | `西阿南呀` |
| `"Python"` | `抖咪酷丁息米都慢` |
| `"Hello, World!"` | `豆米啊拢嘎米多拢迷集伽漫咖苦播库迷律==` |
| `"Base64"` | `律苦集叮希斗西丁` |
| `"Hachi64"` | `豆米集呀息米库咚背哈==` |

## 运行测试

```bash
# 安装依赖
composer install

# 运行测试
composer test

# 或者直接使用 PHPUnit
./vendor/bin/phpunit tests
```

## 系统要求

- PHP 7.0 或更高版本
- mbstring 扩展（用于处理多字节字符）

## 许可证

MIT License

## 相关链接

- [项目主页](https://github.com/fengb3/Hachi64)
- [实现指南](../docs/implemtation_guide.md)
