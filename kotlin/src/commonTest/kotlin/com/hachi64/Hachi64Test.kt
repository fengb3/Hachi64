package com.hachi64

import kotlin.test.*

/**
 * 哈吉米64 编解码器测试类
 */
class Hachi64Test {

    @Test
    fun testEncodeDecodeConsistency() {
        val testCases = listOf(
            "Hello, World!",
            "rust",
            "a",
            "ab",
            "abc",
            "Python",
            "Hachi64",
            "",
            "The quick brown fox jumps over the lazy dog"
        )

        for (testData in testCases) {
            val bytes = testData.encodeToByteArray()
            val encoded = Hachi64.encode(bytes)
            val decoded = Hachi64.decode(encoded)
            
            assertContentEquals(
                bytes, decoded,
                "编码解码不一致: $testData -> $encoded -> ${decoded.decodeToString()}"
            )
        }
    }

    @Test
    fun testSpecificEncodings() {
        val testCases = mapOf(
            "Hello" to "豆米啊拢嘎米多=",
            "abc" to "西阿南呀",
            "a" to "西律==",
            "ab" to "西阿迷=",
            "Python" to "抖咪酷丁息米都慢",
            "Hello, World!" to "豆米啊拢嘎米多拢迷集伽漫咖苦播库迷律==",
            "Base64" to "律苦集叮希斗西丁",
            "Hachi64" to "豆米集呀息米库咚背哈=="
        )

        for ((input, expected) in testCases) {
            val bytes = input.encodeToByteArray()
            val encoded = Hachi64.encode(bytes)
            
            assertEquals(
                expected, encoded,
                "编码结果不匹配: $input -> 期望 $expected, 实际 $encoded"
            )
        }
    }

    @Test
    fun testBinaryData() {
        val testData = ByteArray(256) { it.toByte() }
        
        val encoded = Hachi64.encode(testData)
        val decoded = Hachi64.decode(encoded)
        
        assertContentEquals(testData, decoded, "二进制数据编码解码失败")
    }

    @Test
    fun testNoPaddingEncodeDecode() {
        val testCases = listOf("a", "ab", "abc", "Hello")

        for (testData in testCases) {
            val bytes = testData.encodeToByteArray()
            val encodedNoPad = Hachi64.encode(bytes, false)
            val decoded = Hachi64.decode(encodedNoPad, false)
            
            assertContentEquals(
                bytes, decoded,
                "无填充编码解码不一致: $testData -> $encodedNoPad -> ${decoded.decodeToString()}"
            )
        }
    }

    @Test
    fun testPaddingBehavior() {
        val testData = "a".encodeToByteArray()

        val encodedWithPadding = Hachi64.encode(testData, true)
        val encodedWithoutPadding = Hachi64.encode(testData, false)

        // 有填充的应该有 == 结尾
        assertTrue(
            encodedWithPadding.endsWith("=="),
            "有填充编码应该以==结尾: $encodedWithPadding"
        )

        // 无填充的不应该有 = 
        assertFalse(
            encodedWithoutPadding.contains("="),
            "无填充编码不应该包含=: $encodedWithoutPadding"
        )

        // 两种方式解码应该都能得到原始数据
        val decodedWithPadding = Hachi64.decode(encodedWithPadding, true)
        val decodedWithoutPadding = Hachi64.decode(encodedWithoutPadding, false)

        assertContentEquals(testData, decodedWithPadding)
        assertContentEquals(testData, decodedWithoutPadding)
    }

    @Test
    fun testDecodeInvalidInput() {
        // 测试包含不在字母表中的字符
        assertFailsWith<IllegalArgumentException> {
            Hachi64.decode("包含无效字符X的字符串")
        }

        // 测试空字符串
        val result = Hachi64.decode("")
        assertEquals(0, result.size, "空字符串应该解码为空字节")
    }

    @Test
    fun testAlphabetCoverage() {
        // 验证字母表长度
        assertEquals(64, Hachi64.HACHI_ALPHABET.length, "字母表长度应该为64")

        // 验证字母表无重复字符
        val uniqueChars = Hachi64.HACHI_ALPHABET.toSet()
        assertEquals(64, uniqueChars.size, "字母表应该包含64个唯一字符")

        // 测试长数据以确保所有字符都可能被使用
        val longData = ByteArray(256 * 3) { (it % 256).toByte() }
        
        val encoded = Hachi64.encode(longData)
        val decoded = Hachi64.decode(encoded)
        
        assertContentEquals(longData, decoded, "长数据编码解码应该一致")
    }

    @Test
    fun testEmptyInput() {
        val emptyBytes = ByteArray(0)
        val encoded = Hachi64.encode(emptyBytes)
        val decoded = Hachi64.decode(encoded)
        
        assertEquals("", encoded)
        assertEquals(0, decoded.size)
    }

    @Test
    fun testVariousLengths() {
        val lengths = listOf(1, 2, 3, 10, 100, 1000)
        
        for (length in lengths) {
            val testData = ByteArray(length) { (it % 256).toByte() }
            
            val encoded = Hachi64.encode(testData)
            val decoded = Hachi64.decode(encoded)
            
            assertContentEquals(testData, decoded)
        }
    }

    @Test
    fun testRoundtripWithLongText() {
        val testString = "The quick brown fox jumps over the lazy dog. 这是一段中文文本测试。1234567890!@#\$%^&*()"
        val testData = testString.encodeToByteArray()
        val encoded = Hachi64.encode(testData)
        val decoded = Hachi64.decode(encoded)
        val decodedText = decoded.decodeToString()
        
        assertContentEquals(testData, decoded)
        assertEquals(testString, decodedText)
    }

    @Test
    fun testSingleBytePadding() {
        // Test data that will result in different padding scenarios
        val data1 = byteArrayOf(0x01)  // 1 byte -> needs ==
        val data2 = byteArrayOf(0x01, 0x02)  // 2 bytes -> needs =
        val data3 = byteArrayOf(0x01, 0x02, 0x03)  // 3 bytes -> no padding
        
        val encoded1 = Hachi64.encode(data1, true)
        val encoded2 = Hachi64.encode(data2, true)
        val encoded3 = Hachi64.encode(data3, true)
        
        assertTrue(encoded1.endsWith("=="))
        assertTrue(encoded2.endsWith("="))
        assertFalse(encoded3.endsWith("="))
        
        assertContentEquals(data1, Hachi64.decode(encoded1, true))
        assertContentEquals(data2, Hachi64.decode(encoded2, true))
        assertContentEquals(data3, Hachi64.decode(encoded3, true))
    }

    @Test
    fun testAllByteValues() {
        // Test encoding/decoding of all possible byte values
        for (i in 0 until 256) {
            val testData = byteArrayOf(i.toByte())
            val encoded = Hachi64.encode(testData)
            val decoded = Hachi64.decode(encoded)
            assertContentEquals(testData, decoded, "Failed for byte value: $i")
        }
    }
}
