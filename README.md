# 哈吉米64 编解码器

使用哈吉米64字符集来进行 Base64 编码和解码的库。

## 概述

Base64 是将二进制数据编码为 ASCII 字符串格式的标准。它的工作原理是将每3个字节的二进制数据转换为4个来自64个字符字母表的字符。

本项目提供了通过提供自哈吉米64个字符集来创建哈吉米64 风格编码的工具。这对于以下情况非常有用：

*   创建URL安全或文件名安全的标识符，而不依赖于标准的URL安全 Base64 变体。
*   避免在特定上下文中可能具有特殊含义的字符。
*   实现遗留的或非标准的类 Base64 编码方案。

**警告：** 使用哈吉米字母表会使您编码的数据与标准 Base64 解码器不兼容。仅在您完全控制编码和解码过程时才使用此功能。

## 核心算法设计

### 编码 (Encode) 算法

**输入:**
*   `data`: 一段二进制数据 (字节数组)。
*   `alphabet`: 一个包含64个唯一字符的自定义字符串。
*   `padding`: 一个布尔值，决定是否使用 `=` 进行填充。

**输出:**
*   一个使用自定义字母表编码后的字符串。

**流程:**
1.  **验证输入:** 检查 `alphabet` 是否正好包含64个唯一字符。
2.  **分组:** 将输入的 `data` 按每3个字节（24位）为一组进行切分。
3.  **处理主干部分:** 对于每一个3字节的组，将其转换为4个6位的块，并使用 `alphabet` 查表得到4个字符。
4.  **处理剩余部分 (Padding):**
    *   **剩1个字节:** 补位后得到2个字符，如果 `padding` 为 `true`，则追加两个 `=`。
    *   **剩2个字节:** 补位后得到3个字符，如果 `padding` 为 `true`，则追加一个 `=`。
5.  **返回结果:** 返回拼接好的完整字符串。

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

### `encode` 伪代码

```
FUNCTION encode(data, alphabet, padding = TRUE):
    IF length(alphabet) != 64 OR has_duplicates(alphabet):
        THROW error "字母表必须是64个唯一字符"

    result = ""
    i = 0
    WHILE i < length(data):
        chunk = data.slice(i, i + 3)
        i = i + 3

        // 将3个字节转换为4个索引
        byte1 = chunk[0]
        byte2 = (length(chunk) > 1) ? chunk[1] : 0
        byte3 = (length(chunk) > 2) ? chunk[2] : 0

        index1 = byte1 >> 2
        index2 = ((byte1 & 0x03) << 4) | (byte2 >> 4)
        index3 = ((byte2 & 0x0F) << 2) | (byte3 >> 6)
        index4 = byte3 & 0x3F

        result += alphabet[index1] + alphabet[index2]

        IF length(chunk) > 1:
            result += alphabet[index3]
        ELSE IF padding:
            result += "=="

        IF length(chunk) > 2:
            result += alphabet[index4]
        ELSE IF length(chunk) > 1 AND padding:
            result += "="

    RETURN result
```

### `decode` 伪代码

```
FUNCTION decode(encoded_string, alphabet):
    reverse_map = create_map_from_char_to_index(alphabet)
    
    pad_count = count_trailing_char(encoded_string, '=')
    string_no_padding = remove_trailing_chars(encoded_string, '=')

    result_bytes = new byte_array()
    i = 0
    WHILE i < length(string_no_padding):
        chunk = string_no_padding.slice(i, i + 4)
        i = i + 4

        index1 = reverse_map[chunk[0]]
        index2 = reverse_map[chunk[1]]
        index3 = (length(chunk) > 2) ? reverse_map[chunk[2]] : 0
        index4 = (length(chunk) > 3) ? reverse_map[chunk[3]] : 0

        byte1 = (index1 << 2) | (index2 >> 4)
        byte2 = ((index2 & 0x0F) << 4) | (index3 >> 2)
        byte3 = ((index3 & 0x03) << 6) | index4

        result_bytes.append(byte1)
        IF length(chunk) > 2:
            result_bytes.append(byte2)
        IF length(chunk) > 3:
            result_bytes.append(byte3)

    // 移除因填充而产生的多余字节
    IF pad_count > 0:
        result_bytes = result_bytes.slice(0, length(result_bytes) - pad_count)

    RETURN result_bytes
```
