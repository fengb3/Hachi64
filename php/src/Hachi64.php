<?php

namespace Hachi64;

/**
 * 哈吉米64 编解码器 - 使用64个中文字符进行 Base64 风格的编码和解码
 * 
 * Hachi64 使用一个独特的64个中文字符集(哈吉米字符集)来进行Base64风格的编码和解码。
 * 字符按发音相似性分组，使编码后的字符串看起来更加和谐统一。
 */
class Hachi64
{
    /**
     * 哈吉米64字符集：64个中文字符，按同音字分组
     */
    const HACHI_ALPHABET = "哈蛤呵吉急集米咪迷南男难北背杯绿律虑豆斗抖啊阿额西希息嘎咖伽花华哗压鸭呀库酷苦奶乃耐龙隆拢曼慢漫波播玻叮丁订咚东冬囊路陆多都弥济";
    
    /**
     * 反向映射表缓存
     * @var array|null
     */
    private static $reverseMap = null;
    
    /**
     * 使用哈吉米64字符集编码字节数组
     *
     * @param string $data 要编码的字节数组
     * @param bool $padding 是否使用 '=' 进行填充
     * @return string 编码后的字符串
     * @throws \InvalidArgumentException 当数据为null时抛出
     */
    public static function encode($data, $padding = true)
    {
        if ($data === null) {
            throw new \InvalidArgumentException("Data cannot be null");
        }
        
        if ($data === "") {
            return "";
        }
        
        $alphabet = self::HACHI_ALPHABET;
        $result = [];
        $dataLen = strlen($data);
        
        for ($i = 0; $i < $dataLen; $i += 3) {
            // 获取字节值，不足的用0填充
            $byte1 = ord($data[$i]);
            $byte2 = ($i + 1 < $dataLen) ? ord($data[$i + 1]) : 0;
            $byte3 = ($i + 2 < $dataLen) ? ord($data[$i + 2]) : 0;
            
            $chunkLength = min(3, $dataLen - $i);
            
            // 将24位分成4个6位索引
            $idx1 = $byte1 >> 2;
            $idx2 = (($byte1 & 0x03) << 4) | ($byte2 >> 4);
            $idx3 = (($byte2 & 0x0F) << 2) | ($byte3 >> 6);
            $idx4 = $byte3 & 0x3F;
            
            // 添加前两个字符（总是存在）
            $result[] = mb_substr($alphabet, $idx1, 1, 'UTF-8');
            $result[] = mb_substr($alphabet, $idx2, 1, 'UTF-8');
            
            // 处理第三个字符
            if ($chunkLength > 1) {
                $result[] = mb_substr($alphabet, $idx3, 1, 'UTF-8');
            } elseif ($padding) {
                $result[] = '=';
            }
            
            // 处理第四个字符
            if ($chunkLength > 2) {
                $result[] = mb_substr($alphabet, $idx4, 1, 'UTF-8');
            } elseif ($padding) {
                $result[] = '=';
            }
        }
        
        return implode('', $result);
    }
    
    /**
     * 解码使用哈吉米64字符集编码的字符串
     *
     * @param string $encodedStr 要解码的字符串
     * @param bool $padding 输入字符串是否使用 '=' 进行填充
     * @return string 解码后的字节数组
     * @throws \InvalidArgumentException 输入字符串包含无效字符时抛出
     */
    public static function decode($encodedStr, $padding = true)
    {
        if ($encodedStr === null) {
            throw new \InvalidArgumentException("Encoded string cannot be null");
        }
        
        if ($encodedStr === "") {
            return "";
        }
        
        // 初始化反向映射表
        if (self::$reverseMap === null) {
            self::$reverseMap = [];
            $alphabet = self::HACHI_ALPHABET;
            $alphabetLen = mb_strlen($alphabet, 'UTF-8');
            for ($i = 0; $i < $alphabetLen; $i++) {
                $char = mb_substr($alphabet, $i, 1, 'UTF-8');
                self::$reverseMap[$char] = $i;
            }
        }
        
        // 处理填充
        $padCount = 0;
        if ($padding) {
            $padCount = substr_count($encodedStr, '=');
            if ($padCount > 0) {
                $encodedStr = substr($encodedStr, 0, -$padCount);
            }
        }
        
        $result = [];
        $encodedLen = mb_strlen($encodedStr, 'UTF-8');
        
        // 按每4个字符为一组进行处理
        for ($i = 0; $i < $encodedLen; $i += 4) {
            $chunkLength = min(4, $encodedLen - $i);
            
            // 获取索引值
            $char1 = mb_substr($encodedStr, $i, 1, 'UTF-8');
            if (!isset(self::$reverseMap[$char1])) {
                throw new \InvalidArgumentException("Invalid character in input: " . $char1);
            }
            $idx1 = self::$reverseMap[$char1];
            
            $idx2 = 0;
            $idx3 = 0;
            $idx4 = 0;
            
            if ($chunkLength > 1) {
                $char2 = mb_substr($encodedStr, $i + 1, 1, 'UTF-8');
                if (!isset(self::$reverseMap[$char2])) {
                    throw new \InvalidArgumentException("Invalid character in input: " . $char2);
                }
                $idx2 = self::$reverseMap[$char2];
            }
            
            if ($chunkLength > 2) {
                $char3 = mb_substr($encodedStr, $i + 2, 1, 'UTF-8');
                if (!isset(self::$reverseMap[$char3])) {
                    throw new \InvalidArgumentException("Invalid character in input: " . $char3);
                }
                $idx3 = self::$reverseMap[$char3];
            }
            
            if ($chunkLength > 3) {
                $char4 = mb_substr($encodedStr, $i + 3, 1, 'UTF-8');
                if (!isset(self::$reverseMap[$char4])) {
                    throw new \InvalidArgumentException("Invalid character in input: " . $char4);
                }
                $idx4 = self::$reverseMap[$char4];
            }
            
            // 将4个6位索引重组为3个字节
            $byte1 = ($idx1 << 2) | ($idx2 >> 4);
            $result[] = chr($byte1);
            
            if ($chunkLength > 2) {
                $byte2 = (($idx2 & 0x0F) << 4) | ($idx3 >> 2);
                $result[] = chr($byte2);
            }
            
            if ($chunkLength > 3) {
                $byte3 = (($idx3 & 0x03) << 6) | $idx4;
                $result[] = chr($byte3);
            }
        }
        
        return implode('', $result);
    }
}
