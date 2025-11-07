<?php

use PHPUnit\Framework\TestCase;
use Hachi64\Hachi64;

/**
 * 哈吉米64 编解码器测试类
 */
class Hachi64Test extends TestCase
{
    /**
     * 测试编码和解码的一致性
     */
    public function testEncodeDecodeConsistency()
    {
        $testCases = [
            "Hello, World!",
            "rust",
            "a",
            "ab",
            "abc",
            "Python",
            "Hachi64",
            "",
            "The quick brown fox jumps over the lazy dog"
        ];
        
        foreach ($testCases as $testData) {
            $encoded = Hachi64::encode($testData);
            $decoded = Hachi64::decode($encoded);
            
            $this->assertEquals($testData, $decoded, 
                "编码解码不一致: {$testData} -> {$encoded} -> {$decoded}");
        }
    }
    
    /**
     * 测试特定的编码结果，确保使用中文字母表
     * @dataProvider specificEncodingsProvider
     */
    public function testSpecificEncodings($input, $expected)
    {
        $encoded = Hachi64::encode($input);
        
        $this->assertEquals($expected, $encoded, 
            "编码结果不匹配: {$input} -> 期望 {$expected}, 实际 {$encoded}");
    }
    
    public function specificEncodingsProvider()
    {
        return [
            ["Hello", "豆米啊拢嘎米多="],
            ["abc", "西阿南呀"],
            ["a", "西律=="],
            ["ab", "西阿迷="],
            ["Python", "抖咪酷丁息米都慢"],
            ["Hello, World!", "豆米啊拢嘎米多拢迷集伽漫咖苦播库迷律=="],
            ["Base64", "律苦集叮希斗西丁"],
            ["Hachi64", "豆米集呀息米库咚背哈=="]
        ];
    }
    
    /**
     * 测试二进制数据的编码解码
     */
    public function testBinaryData()
    {
        $testData = '';
        for ($i = 0; $i < 256; $i++) {
            $testData .= chr($i);
        }
        
        $encoded = Hachi64::encode($testData);
        $decoded = Hachi64::decode($encoded);
        
        $this->assertEquals($testData, $decoded, "二进制数据编码解码失败");
    }
    
    /**
     * 测试无填充编码解码
     */
    public function testNoPaddingEncodeDecode()
    {
        $testCases = ["a", "ab", "abc", "Hello"];
        
        foreach ($testCases as $testData) {
            $encodedNoPad = Hachi64::encode($testData, false);
            $decoded = Hachi64::decode($encodedNoPad, false);
            
            $this->assertEquals($testData, $decoded, 
                "无填充编码解码不一致: {$testData} -> {$encodedNoPad} -> {$decoded}");
        }
    }
    
    /**
     * 测试填充行为
     */
    public function testPaddingBehavior()
    {
        $testData = "a";
        
        $encodedWithPadding = Hachi64::encode($testData, true);
        $encodedWithoutPadding = Hachi64::encode($testData, false);
        
        // 有填充的应该有 == 结尾
        $this->assertTrue(substr($encodedWithPadding, -2) === "==", 
            "有填充编码应该以==结尾: {$encodedWithPadding}");
        
        // 无填充的不应该有 = 
        $this->assertFalse(strpos($encodedWithoutPadding, '=') !== false,
            "无填充编码不应该包含=: {$encodedWithoutPadding}");
        
        // 两种方式解码应该都能得到原始数据
        $decodedWithPadding = Hachi64::decode($encodedWithPadding, true);
        $decodedWithoutPadding = Hachi64::decode($encodedWithoutPadding, false);
        
        $this->assertEquals($testData, $decodedWithPadding);
        $this->assertEquals($testData, $decodedWithoutPadding);
    }
    
    /**
     * 测试解码无效输入
     */
    public function testDecodeInvalidInput()
    {
        // 测试包含不在字母表中的字符
        $this->expectException(\InvalidArgumentException::class);
        Hachi64::decode("包含无效字符X的字符串");
    }
    
    /**
     * 测试空字符串
     */
    public function testEmptyString()
    {
        $result = Hachi64::decode("");
        $this->assertEquals("", $result, "空字符串应该解码为空字符串");
    }
    
    /**
     * 测试字母表的覆盖率
     */
    public function testAlphabetCoverage()
    {
        // 验证字母表长度
        $alphabetLen = mb_strlen(Hachi64::HACHI_ALPHABET, 'UTF-8');
        $this->assertEquals(64, $alphabetLen, "字母表长度应该为64");
        
        // 验证字母表无重复字符
        $alphabet = Hachi64::HACHI_ALPHABET;
        $uniqueChars = [];
        for ($i = 0; $i < $alphabetLen; $i++) {
            $char = mb_substr($alphabet, $i, 1, 'UTF-8');
            $uniqueChars[$char] = true;
        }
        $this->assertEquals(64, count($uniqueChars), "字母表应该包含64个唯一字符");
        
        // 测试长数据以确保所有字符都可能被使用
        $longData = '';
        for ($i = 0; $i < 256 * 3; $i++) {
            $longData .= chr($i % 256);
        }
        
        $encoded = Hachi64::encode($longData);
        $decoded = Hachi64::decode($encoded);
        
        $this->assertEquals($longData, $decoded, "长数据编码解码应该一致");
    }
    
    /**
     * 测试空输入
     */
    public function testEmptyInput()
    {
        $emptyData = "";
        $encoded = Hachi64::encode($emptyData);
        $decoded = Hachi64::decode($encoded);
        
        $this->assertEquals("", $encoded);
        $this->assertEquals("", $decoded);
    }
    
    /**
     * 测试null输入 - 编码
     */
    public function testNullEncodeInput()
    {
        $this->expectException(\InvalidArgumentException::class);
        Hachi64::encode(null);
    }
    
    /**
     * 测试null输入 - 解码
     */
    public function testNullDecodeInput()
    {
        $this->expectException(\InvalidArgumentException::class);
        Hachi64::decode(null);
    }
    
    /**
     * 测试各种长度
     * @dataProvider variousLengthsProvider
     */
    public function testVariousLengths($length)
    {
        $testData = '';
        for ($i = 0; $i < $length; $i++) {
            $testData .= chr($i % 256);
        }
        
        $encoded = Hachi64::encode($testData);
        $decoded = Hachi64::decode($encoded);
        
        $this->assertEquals($testData, $decoded);
    }
    
    public function variousLengthsProvider()
    {
        return [
            [1],
            [2],
            [3],
            [10],
            [100],
            [1000]
        ];
    }
    
    /**
     * 测试长文本往返
     */
    public function testRoundtripWithLongText()
    {
        $testString = "The quick brown fox jumps over the lazy dog. 这是一段中文文本测试。1234567890!@#$%^&*()";
        $encoded = Hachi64::encode($testString);
        $decoded = Hachi64::decode($encoded);
        
        $this->assertEquals($testString, $decoded);
    }
    
    /**
     * 测试单字节填充
     */
    public function testSingleBytePadding()
    {
        // Test data that will result in different padding scenarios
        $data1 = chr(0x01);  // 1 byte -> needs ==
        $data2 = chr(0x01) . chr(0x02);  // 2 bytes -> needs =
        $data3 = chr(0x01) . chr(0x02) . chr(0x03);  // 3 bytes -> no padding
        
        $encoded1 = Hachi64::encode($data1, true);
        $encoded2 = Hachi64::encode($data2, true);
        $encoded3 = Hachi64::encode($data3, true);
        
        $this->assertTrue(substr($encoded1, -2) === "==");
        $this->assertTrue(substr($encoded2, -1) === "=");
        $this->assertFalse(substr($encoded3, -1) === "=");
        
        $this->assertEquals($data1, Hachi64::decode($encoded1, true));
        $this->assertEquals($data2, Hachi64::decode($encoded2, true));
        $this->assertEquals($data3, Hachi64::decode($encoded3, true));
    }
    
    /**
     * 测试所有字节值
     */
    public function testAllByteValues()
    {
        // Test encoding/decoding of all possible byte values
        for ($i = 0; $i < 256; $i++) {
            $testData = chr($i);
            $encoded = Hachi64::encode($testData);
            $decoded = Hachi64::decode($encoded);
            $this->assertEquals($testData, $decoded, "Failed for byte value: " . $i);
        }
    }
}
