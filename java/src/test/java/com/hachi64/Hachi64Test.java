package com.hachi64;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.junit.jupiter.params.provider.ValueSource;

import java.nio.charset.StandardCharsets;
import java.util.HashSet;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.*;

/**
 * 哈吉米64 编解码器测试类
 */
public class Hachi64Test {

    @Test
    public void testEncodeDecodeConsistency() {
        String[] testCases = {
            "Hello, World!",
            "rust",
            "a",
            "ab",
            "abc",
            "Python",
            "Hachi64",
            "",
            "The quick brown fox jumps over the lazy dog"
        };

        for (String testData : testCases) {
            byte[] bytes = testData.getBytes(StandardCharsets.UTF_8);
            String encoded = Hachi64.encode(bytes);
            byte[] decoded = Hachi64.decode(encoded);
            
            assertArrayEquals(bytes, decoded, 
                "编码解码不一致: " + testData + " -> " + encoded + " -> " + new String(decoded, StandardCharsets.UTF_8));
        }
    }

    @ParameterizedTest
    @CsvSource(delimiter = '|', value = {
        "Hello|豆米啊拢嘎米多=",
        "abc|西阿南呀",
        "a|西律==",
        "ab|西阿迷=",
        "Python|抖咪酷丁息米都慢",
        "Hello, World!|豆米啊拢嘎米多拢迷集伽漫咖苦播库迷律==",
        "Base64|律苦集叮希斗西丁",
        "Hachi64|豆米集呀息米库咚背哈=="
    })
    public void testSpecificEncodings(String input, String expected) {
        byte[] bytes = input.getBytes(StandardCharsets.UTF_8);
        String encoded = Hachi64.encode(bytes);
        
        assertEquals(expected, encoded, 
            "编码结果不匹配: " + input + " -> 期望 " + expected + ", 实际 " + encoded);
    }

    @Test
    public void testBinaryData() {
        byte[] testData = new byte[256];
        for (int i = 0; i < 256; i++) {
            testData[i] = (byte) i;
        }
        
        String encoded = Hachi64.encode(testData);
        byte[] decoded = Hachi64.decode(encoded);
        
        assertArrayEquals(testData, decoded, "二进制数据编码解码失败");
    }

    @Test
    public void testNoPaddingEncodeDecode() {
        String[] testCases = {"a", "ab", "abc", "Hello"};

        for (String testData : testCases) {
            byte[] bytes = testData.getBytes(StandardCharsets.UTF_8);
            String encodedNoPad = Hachi64.encode(bytes, false);
            byte[] decoded = Hachi64.decode(encodedNoPad, false);
            
            assertArrayEquals(bytes, decoded, 
                "无填充编码解码不一致: " + testData + " -> " + encodedNoPad + " -> " + new String(decoded, StandardCharsets.UTF_8));
        }
    }

    @Test
    public void testPaddingBehavior() {
        byte[] testData = "a".getBytes(StandardCharsets.UTF_8);

        String encodedWithPadding = Hachi64.encode(testData, true);
        String encodedWithoutPadding = Hachi64.encode(testData, false);

        // 有填充的应该有 == 结尾
        assertTrue(encodedWithPadding.endsWith("=="), 
            "有填充编码应该以==结尾: " + encodedWithPadding);

        // 无填充的不应该有 = 
        assertFalse(encodedWithoutPadding.contains("="),
            "无填充编码不应该包含=: " + encodedWithoutPadding);

        // 两种方式解码应该都能得到原始数据
        byte[] decodedWithPadding = Hachi64.decode(encodedWithPadding, true);
        byte[] decodedWithoutPadding = Hachi64.decode(encodedWithoutPadding, false);

        assertArrayEquals(testData, decodedWithPadding);
        assertArrayEquals(testData, decodedWithoutPadding);
    }

    @Test
    public void testDecodeInvalidInput() {
        // 测试包含不在字母表中的字符
        assertThrows(IllegalArgumentException.class, () -> {
            Hachi64.decode("包含无效字符X的字符串");
        });

        // 测试空字符串
        byte[] result = Hachi64.decode("");
        assertEquals(0, result.length, "空字符串应该解码为空字节");
    }

    @Test
    public void testAlphabetCoverage() {
        // 验证字母表长度
        assertEquals(64, Hachi64.HACHI_ALPHABET.length(), "字母表长度应该为64");

        // 验证字母表无重复字符
        Set<Character> uniqueChars = new HashSet<>();
        for (char c : Hachi64.HACHI_ALPHABET.toCharArray()) {
            uniqueChars.add(c);
        }
        assertEquals(64, uniqueChars.size(), "字母表应该包含64个唯一字符");

        // 测试长数据以确保所有字符都可能被使用
        byte[] longData = new byte[256 * 3];
        for (int i = 0; i < longData.length; i++) {
            longData[i] = (byte) (i % 256);
        }
        
        String encoded = Hachi64.encode(longData);
        byte[] decoded = Hachi64.decode(encoded);
        
        assertArrayEquals(longData, decoded, "长数据编码解码应该一致");
    }

    @Test
    public void testEmptyInput() {
        byte[] emptyBytes = new byte[0];
        String encoded = Hachi64.encode(emptyBytes);
        byte[] decoded = Hachi64.decode(encoded);
        
        assertEquals("", encoded);
        assertEquals(0, decoded.length);
    }

    @Test
    public void testNullInput() {
        assertThrows(IllegalArgumentException.class, () -> {
            Hachi64.encode(null);
        });
        
        assertThrows(IllegalArgumentException.class, () -> {
            Hachi64.decode(null);
        });
    }

    @ParameterizedTest
    @ValueSource(ints = {1, 2, 3, 10, 100, 1000})
    public void testVariousLengths(int length) {
        byte[] testData = new byte[length];
        for (int i = 0; i < length; i++) {
            testData[i] = (byte) (i % 256);
        }
        
        String encoded = Hachi64.encode(testData);
        byte[] decoded = Hachi64.decode(encoded);
        
        assertArrayEquals(testData, decoded);
    }

    @Test
    public void testRoundtripWithLongText() {
        String testString = "The quick brown fox jumps over the lazy dog. 这是一段中文文本测试。1234567890!@#$%^&*()";
        byte[] testData = testString.getBytes(StandardCharsets.UTF_8);
        String encoded = Hachi64.encode(testData);
        byte[] decoded = Hachi64.decode(encoded);
        String decodedText = new String(decoded, StandardCharsets.UTF_8);
        
        assertArrayEquals(testData, decoded);
        assertEquals(testString, decodedText);
    }

    @Test
    public void testSingleBytePadding() {
        // Test data that will result in different padding scenarios
        byte[] data1 = new byte[]{0x01};  // 1 byte -> needs ==
        byte[] data2 = new byte[]{0x01, 0x02};  // 2 bytes -> needs =
        byte[] data3 = new byte[]{0x01, 0x02, 0x03};  // 3 bytes -> no padding
        
        String encoded1 = Hachi64.encode(data1, true);
        String encoded2 = Hachi64.encode(data2, true);
        String encoded3 = Hachi64.encode(data3, true);
        
        assertTrue(encoded1.endsWith("=="));
        assertTrue(encoded2.endsWith("="));
        assertFalse(encoded3.endsWith("="));
        
        assertArrayEquals(data1, Hachi64.decode(encoded1, true));
        assertArrayEquals(data2, Hachi64.decode(encoded2, true));
        assertArrayEquals(data3, Hachi64.decode(encoded3, true));
    }

    @Test
    public void testAllByteValues() {
        // Test encoding/decoding of all possible byte values
        for (int i = 0; i < 256; i++) {
            byte[] testData = new byte[]{(byte) i};
            String encoded = Hachi64.encode(testData);
            byte[] decoded = Hachi64.decode(encoded);
            assertArrayEquals(testData, decoded, "Failed for byte value: " + i);
        }
    }
}
