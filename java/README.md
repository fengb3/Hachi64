# 哈吉米64 (Hachi64) - Java 实现

Java 实现的哈吉米64编解码器，使用64个中文字符进行 Base64 风格的编码和解码。

## 功能特性

- 使用64个中文字符（哈吉米字符集）进行编码
- 完全可逆的编码解码过程
- 支持带填充和不带填充的编码模式
- 兼容标准 Base64 的编码原理

## 快速开始

### 环境要求

- Java 8 或更高版本
- Maven 3.6 或更高版本

### 构建项目

```bash
cd java
mvn clean install
```

### 运行测试

```bash
mvn test
```

## 使用方法

### 基本用法

```java
import com.hachi64.Hachi64;
import java.nio.charset.StandardCharsets;

public class Example {
    public static void main(String[] args) {
        // 编码
        byte[] data = "Hello, World!".getBytes(StandardCharsets.UTF_8);
        String encoded = Hachi64.encode(data);
        System.out.println("编码结果: " + encoded);
        // 输出: 豆米啊拢嘎米多拢迷集伽漫咖苦播库迷律==
        
        // 解码
        byte[] decoded = Hachi64.decode(encoded);
        String original = new String(decoded, StandardCharsets.UTF_8);
        System.out.println("解码结果: " + original);
        // 输出: Hello, World!
    }
}
```

### 不带填充的编码

```java
// 编码时不使用 '=' 填充
String encodedNoPad = Hachi64.encode(data, false);

// 解码时指定无填充
byte[] decoded = Hachi64.decode(encodedNoPad, false);
```

## API 文档

### `Hachi64` 类

#### 静态方法

- `static String encode(byte[] data)` - 使用默认填充模式编码字节数组
- `static String encode(byte[] data, boolean padding)` - 编码字节数组，可选择是否使用填充
- `static byte[] decode(String encodedStr)` - 使用默认填充模式解码字符串
- `static byte[] decode(String encodedStr, boolean padding)` - 解码字符串，可选择是否使用填充

#### 常量

- `static final String HACHI_ALPHABET` - 哈吉米64字符集（64个中文字符）

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

## 项目结构

```
java/
├── pom.xml                              # Maven 项目配置
├── README.md                            # 本文档
└── src/
    ├── main/
    │   └── java/
    │       └── com/
    │           └── hachi64/
    │               └── Hachi64.java     # 主实现类
    └── test/
        └── java/
            └── com/
                └── hachi64/
                    └── Hachi64Test.java # 单元测试
```

## 许可证

与主项目保持一致。

## 相关链接

- [项目主页](../../README.md)
- [实现指南](../../docs/implementation_guide.md)
- [Python 实现](../python/README.md)
- [C# 实现](../csharp/README.md)
- [Rust 实现](../rust/README.md)
