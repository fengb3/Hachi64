# 哈基米64(Hachi64) 实现指南

## 简介

本指南详细介绍了哈基米64(Hachi64) 编解码器的实现细节。哈基米64使用一个独特的64个中文字符集(哈基米字符集)来进行Base64风格的编码和解码。本文档涵盖了核心算法设计、伪代码实现以及编码示例，帮助开发者理解和实现哈基米64编解码功能。

## 核心算法设计

### 编码 (Encode) 算法

**输入:**
*   `data`: 一段二进制数据 (字节数组)。
*   `padding`: 一个布尔值，决定是否使用 `=` 进行填充（默认为 `TRUE`）。

**输出:**
*   一个使用哈基米64字符集编码后的字符串。

**流程:**
1.  **初始化:** 使用固定的哈基米64字符集作为编码字母表，创建空的结果数组。
2.  **逐块处理:** 从数据起始位置开始，每次读取最多3个字节作为一个处理块：
    *   **提取字节值:** 从当前块中获取1-3个字节的值，不足部分用0填充。
    *   **位运算分组:** 将这些字节（最多24位）分解为4个6位的索引值：
        - `idx1 = byte1 >> 2` (取第1个字节的高6位)
        - `idx2 = ((byte1 & 0x03) << 4) | (byte2 >> 4)` (取第1个字节的低2位和第2个字节的高4位)
        - `idx3 = ((byte2 & 0x0F) << 2) | (byte3 >> 6)` (取第2个字节的低4位和第3个字节的高2位)
        - `idx4 = byte3 & 0x3F` (取第3个字节的低6位)
3.  **字符映射:** 将每个6位索引值（0-63）映射到字母表中对应的字符：
    *   **前两个字符:** 始终添加 `alphabet[idx1]` 和 `alphabet[idx2]`（因为至少有1个输入字节）。
    *   **第三个字符:** 如果块中有2个或更多字节，添加 `alphabet[idx3]`；否则如果 `padding` 为 `true`，添加 `=`。
    *   **第四个字符:** 如果块中有3个字节，添加 `alphabet[idx4]`；否则如果 `padding` 为 `true`，添加 `=`。
4.  **继续迭代:** 移动到下一个3字节块，重复步骤2-3，直到处理完所有输入数据。
5.  **返回结果:** 将结果数组拼接成字符串并返回。

### 解码 (Decode) 算法

**输入:**
*   `encoded_string`: 一个经过编码的字符串。
*   `alphabet`: 用于编码的同一个自定义字母表。

**输出:**
*   解码后的原始二进制数据 (字节数组)。

**流程:**
1.  **创建反向映射表:** 创建一个从 `alphabet` 中每个字符到其索引（0-63）的映射。
2.  **处理填充:** 计算并移除字符串末尾的 `=` 字符。
3.  **分组:** 将处理过的字符串按每4个字符为一组进行切分。
4.  **处理所有组:** 将每4个字符转换回4个6位的值，再拼接成3个字节。
5.  **处理尾部:** 根据填充数量，从结果字节数组的末尾移除相应数量的多余字节。
6.  **返回结果:** 返回解码后的字节数组。

## 伪代码实现

### 哈基米64字符集
```
// 当前使用的64个中文字符集 (哈基米字符集)
// 应当为常量定义
HACHI_ALPHABET="哈蛤呵吉急集米咪迷南男难北背杯绿律虑豆斗抖啊阿额西希息嘎咖伽花华哗压鸭呀库酷苦奶乃耐龙隆拢曼慢漫波播玻叮丁订咚东冬囊路陆多都弥济"

```

### 类设计 (可选)

如果使用面向对象编程的语言，可使用一个 `Hachi64` 类，包含静态方法 `encode` 和 `decode`：

```
CLASS Hachi64:
    STATIC_METHOD encode(data, padding = TRUE):
        // 编码实现 (见下方详细代码)
        
    STATIC_METHOD decode(encoded_str, padding = TRUE):
        // 解码实现 (见下方详细代码)

// 创建默认实例以支持 hachi64.encode/decode 调用格式
hachi64 = new Hachi64()
```

如果不使用面向对象编程的语言，可以直接实现两个独立的函数 `encode(data, padding)` 和 `decode(encoded_str, padding)`。

### `encode` 伪代码

```

STATIC_METHOD Hachi64.encode(data, padding = TRUE):
    alphabet = HACHI_ALPHABET
    result = []
    data_len = length(data)
    i = 0

    WHILE i < data_len:
        chunk = data.slice(i, i + 3)
        i = i + 3

        // 获取字节值，不足的用0填充
        byte1 = chunk[0]
        byte2 = (length(chunk) > 1) ? chunk[1] : 0
        byte3 = (length(chunk) > 2) ? chunk[2] : 0

        // 将24位分成4个6位索引
        idx1 = byte1 >> 2
        idx2 = ((byte1 & 0x03) << 4) | (byte2 >> 4)
        idx3 = ((byte2 & 0x0F) << 2) | (byte3 >> 6)
        idx4 = byte3 & 0x3F

        // 添加前两个字符（总是存在）
        result.append(alphabet[idx1])
        result.append(alphabet[idx2])

        // 处理第三个字符
        IF length(chunk) > 1:
            result.append(alphabet[idx3])
        ELSE IF padding:
            result.append('=')

        // 处理第四个字符
        IF length(chunk) > 2:
            result.append(alphabet[idx4])
        ELSE IF padding:
            result.append('=')
    
    RETURN join(result)
```

### `decode` 伪代码

```
STATIC_METHOD Hachi64.decode(encoded_str, padding = TRUE):
    alphabet = HACHI_ALPHABET
    reverse_map = create_reverse_mapping(alphabet)  // char -> index
    
    // 处理空字符串
    IF encoded_str is empty:
        RETURN empty_bytes

    pad_count = 0
    IF padding:
        pad_count = count_occurrences(encoded_str, '=')
        IF pad_count > 0:
            encoded_str = remove_suffix(encoded_str, '=' * pad_count)

    result = new_byte_array()
    data_len = length(encoded_str)
    i = 0

    WHILE i < data_len:
        chunk = encoded_str.slice(i, i + 4)
        i = i + 4

        TRY:
            idx1 = reverse_map[chunk[0]]
            idx2 = (length(chunk) > 1) ? reverse_map[chunk[1]] : 0
            idx3 = (length(chunk) > 2) ? reverse_map[chunk[2]] : 0
            idx4 = (length(chunk) > 3) ? reverse_map[chunk[3]] : 0
        CATCH invalid_character_error:
            THROW "Invalid character in input: " + error_char

        // 将4个6位索引重组为3个字节
        byte1 = (idx1 << 2) | (idx2 >> 4)
        result.append(byte1)
        
        IF length(chunk) > 2:
            byte2 = ((idx2 & 0x0F) << 4) | (idx3 >> 2)
            result.append(byte2)
            
        IF length(chunk) > 3:
            byte3 = ((idx3 & 0x03) << 6) | idx4
            result.append(byte3)

    // 注意：当前实现中padding不影响最终字节数
    // 因为编码过程中的逻辑已经确保了正确的字节边界
    
    RETURN bytes(result)
```


### 调用风格 伪代码

如果使用面向对象编程语言，可以通过实例方法或类静态方法调用：

```
// 类静态方法调用
encoded = Hachi64.encode(data)
decoded = Hachi64.decode(encoded)
```

确保调用方式为 `Hachi64.encode` 和 `Hachi64.decode` 这种形式。可以是 `类名称.静态方法名`，或直接 `包名称.函数名` 的调用形式。


## 编码示例

以下是一些使用哈基米64编码的示例 (可用于单元测试)：

| 原始数据 | 编码结果 | 说明 |
|---------|---------|------|
| `"Hello"` | `豆米啊拢嘎米多=` | 英文单词编码 |
| `"abc"` | `西阿南呀` | 简单三字符 |
| `"Python"` | `抖咪酷丁息米都慢` | 编程语言名称 |
| `"Hello, World!"` | `豆米啊拢嘎米多拢迷集伽漫咖苦播库迷律==` | 经典问候语 |
| `"Base64"` | `律苦集叮希斗西丁` | 标准编码名称 |
| `"Hachi64"` | `豆米集呀息米库咚背哈==` | 本项目名称 |

注意编码结果全部由哈基米字符组成，看起来像是有意义的哈基米文学(不是。
