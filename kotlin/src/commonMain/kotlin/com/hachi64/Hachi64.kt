package com.hachi64

/**
 * 哈基米64 编解码器 - 使用64个中文字符进行 Base64 风格的编码和解码
 *
 * Hachi64 使用一个独特的64个中文字符集(哈基米字符集)来进行Base64风格的编码和解码。
 * 字符按发音相似性分组，使编码后的字符串看起来更加和谐统一。
 */
object Hachi64 {
    
    /**
     * 哈基米64字符集：64个中文字符，按同音字分组
     */
    const val HACHI_ALPHABET = "哈蛤呵吉急集米咪迷南男难北背杯绿律虑豆斗抖啊阿额西希息嘎咖伽花华哗压鸭呀库酷苦奶乃耐龙隆拢曼慢漫波播玻叮丁订咚东冬囊路陆多都弥济"
    
    private val reverseMap: Map<Char, Int> by lazy {
        HACHI_ALPHABET.mapIndexed { index, char -> char to index }.toMap()
    }
    
    /**
     * 使用哈基米64字符集编码字节数组
     *
     * @param data 要编码的字节数组
     * @return 编码后的字符串
     */
    fun encode(data: ByteArray): String {
        return encode(data, true)
    }
    
    /**
     * 使用哈基米64字符集编码字节数组
     *
     * @param data 要编码的字节数组
     * @param padding 是否使用 '=' 进行填充
     * @return 编码后的字符串
     */
    fun encode(data: ByteArray, padding: Boolean): String {
        if (data.isEmpty()) {
            return ""
        }
        
        val result = StringBuilder((data.size / 3 + 1) * 4)
        
        var i = 0
        while (i < data.size) {
            // 获取字节值，不足的用0填充
            val byte1 = data[i].toInt() and 0xFF
            val byte2 = if (i + 1 < data.size) data[i + 1].toInt() and 0xFF else 0
            val byte3 = if (i + 2 < data.size) data[i + 2].toInt() and 0xFF else 0
            
            val chunkLength = minOf(3, data.size - i)
            
            // 将24位分成4个6位索引
            val idx1 = byte1 shr 2
            val idx2 = ((byte1 and 0x03) shl 4) or (byte2 shr 4)
            val idx3 = ((byte2 and 0x0F) shl 2) or (byte3 shr 6)
            val idx4 = byte3 and 0x3F
            
            // 添加前两个字符（总是存在）
            result.append(HACHI_ALPHABET[idx1])
            result.append(HACHI_ALPHABET[idx2])
            
            // 处理第三个字符
            if (chunkLength > 1) {
                result.append(HACHI_ALPHABET[idx3])
            } else if (padding) {
                result.append('=')
            }
            
            // 处理第四个字符
            if (chunkLength > 2) {
                result.append(HACHI_ALPHABET[idx4])
            } else if (padding) {
                result.append('=')
            }
            
            i += 3
        }
        
        return result.toString()
    }
    
    /**
     * 解码使用哈基米64字符集编码的字符串
     *
     * @param encodedStr 要解码的字符串
     * @return 解码后的字节数组
     * @throws IllegalArgumentException 输入字符串包含无效字符时抛出
     */
    fun decode(encodedStr: String): ByteArray {
        return decode(encodedStr, true)
    }
    
    /**
     * 解码使用哈基米64字符集编码的字符串
     *
     * @param encodedStr 要解码的字符串
     * @param padding 输入字符串是否使用 '=' 进行填充
     * @return 解码后的字节数组
     * @throws IllegalArgumentException 输入字符串包含无效字符时抛出
     */
    fun decode(encodedStr: String, padding: Boolean): ByteArray {
        if (encodedStr.isEmpty()) {
            return ByteArray(0)
        }
        
        // 处理填充
        var processedStr = encodedStr
        var padCount = 0
        if (padding) {
            padCount = encodedStr.takeLastWhile { it == '=' }.length
            if (padCount > 0) {
                processedStr = encodedStr.substring(0, encodedStr.length - padCount)
            }
        }
        
        // 使用列表存储结果
        val result = mutableListOf<Byte>()
        
        // 按每4个字符为一组进行处理
        var i = 0
        while (i < processedStr.length) {
            val chunkLength = minOf(4, processedStr.length - i)
            
            // 获取索引值
            val idx1 = reverseMap[processedStr[i]] 
                ?: throw IllegalArgumentException("Invalid character in input: ${processedStr[i]}")
            
            val idx2 = if (chunkLength > 1) {
                reverseMap[processedStr[i + 1]]
                    ?: throw IllegalArgumentException("Invalid character in input: ${processedStr[i + 1]}")
            } else 0
            
            val idx3 = if (chunkLength > 2) {
                reverseMap[processedStr[i + 2]]
                    ?: throw IllegalArgumentException("Invalid character in input: ${processedStr[i + 2]}")
            } else 0
            
            val idx4 = if (chunkLength > 3) {
                reverseMap[processedStr[i + 3]]
                    ?: throw IllegalArgumentException("Invalid character in input: ${processedStr[i + 3]}")
            } else 0
            
            // 将4个6位索引重组为3个字节
            val byte1 = ((idx1 shl 2) or (idx2 shr 4)).toByte()
            result.add(byte1)
            
            if (chunkLength > 2) {
                val byte2 = (((idx2 and 0x0F) shl 4) or (idx3 shr 2)).toByte()
                result.add(byte2)
            }
            
            if (chunkLength > 3) {
                val byte3 = (((idx3 and 0x03) shl 6) or idx4).toByte()
                result.add(byte3)
            }
            
            i += 4
        }
        
        return result.toByteArray()
    }
}
