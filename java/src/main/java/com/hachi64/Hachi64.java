package com.hachi64;

import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

/**
 * 哈吉米64 编解码器 - 使用64个中文字符进行 Base64 风格的编码和解码
 * <p>
 * Hachi64 使用一个独特的64个中文字符集(哈吉米字符集)来进行Base64风格的编码和解码。
 * 字符按发音相似性分组，使编码后的字符串看起来更加和谐统一。
 * </p>
 */
public class Hachi64 {
    
    /**
     * 哈吉米64字符集：64个中文字符，按同音字分组
     */
    public static final String HACHI_ALPHABET = "哈蛤呵吉急集米咪迷南男难北背杯绿律虑豆斗抖啊阿额西希息嘎咖伽花华哗压鸭呀库酷苦奶乃耐龙隆拢曼慢漫波播玻叮丁订咚东冬囊路陆多都弥济";
    
    private static final Map<Character, Integer> REVERSE_MAP;
    
    static {
        REVERSE_MAP = new HashMap<>(64);
        for (int i = 0; i < HACHI_ALPHABET.length(); i++) {
            REVERSE_MAP.put(HACHI_ALPHABET.charAt(i), i);
        }
    }
    
    /**
     * 使用哈吉米64字符集编码字节数组
     *
     * @param data 要编码的字节数组
     * @return 编码后的字符串
     */
    public static String encode(byte[] data) {
        return encode(data, true);
    }
    
    /**
     * 使用哈吉米64字符集编码字节数组
     *
     * @param data    要编码的字节数组
     * @param padding 是否使用 '=' 进行填充
     * @return 编码后的字符串
     */
    public static String encode(byte[] data, boolean padding) {
        if (data == null) {
            throw new IllegalArgumentException("Data cannot be null");
        }
        
        if (data.length == 0) {
            return "";
        }
        
        StringBuilder result = new StringBuilder((data.length / 3 + 1) * 4);
        
        for (int i = 0; i < data.length; i += 3) {
            // 获取字节值，不足的用0填充
            int byte1 = data[i] & 0xFF;
            int byte2 = (i + 1 < data.length) ? (data[i + 1] & 0xFF) : 0;
            int byte3 = (i + 2 < data.length) ? (data[i + 2] & 0xFF) : 0;
            
            int chunkLength = Math.min(3, data.length - i);
            
            // 将24位分成4个6位索引
            int idx1 = byte1 >> 2;
            int idx2 = ((byte1 & 0x03) << 4) | (byte2 >> 4);
            int idx3 = ((byte2 & 0x0F) << 2) | (byte3 >> 6);
            int idx4 = byte3 & 0x3F;
            
            // 添加前两个字符（总是存在）
            result.append(HACHI_ALPHABET.charAt(idx1));
            result.append(HACHI_ALPHABET.charAt(idx2));
            
            // 处理第三个字符
            if (chunkLength > 1) {
                result.append(HACHI_ALPHABET.charAt(idx3));
            } else if (padding) {
                result.append('=');
            }
            
            // 处理第四个字符
            if (chunkLength > 2) {
                result.append(HACHI_ALPHABET.charAt(idx4));
            } else if (padding) {
                result.append('=');
            }
        }
        
        return result.toString();
    }
    
    /**
     * 解码使用哈吉米64字符集编码的字符串
     *
     * @param encodedStr 要解码的字符串
     * @return 解码后的字节数组
     * @throws IllegalArgumentException 输入字符串包含无效字符时抛出
     */
    public static byte[] decode(String encodedStr) {
        return decode(encodedStr, true);
    }
    
    /**
     * 解码使用哈吉米64字符集编码的字符串
     *
     * @param encodedStr 要解码的字符串
     * @param padding    输入字符串是否使用 '=' 进行填充
     * @return 解码后的字节数组
     * @throws IllegalArgumentException 输入字符串包含无效字符时抛出
     */
    public static byte[] decode(String encodedStr, boolean padding) {
        if (encodedStr == null) {
            throw new IllegalArgumentException("Encoded string cannot be null");
        }
        
        if (encodedStr.isEmpty()) {
            return new byte[0];
        }
        
        // 处理填充
        int padCount = 0;
        if (padding) {
            for (int i = encodedStr.length() - 1; i >= 0 && encodedStr.charAt(i) == '='; i--) {
                padCount++;
            }
            
            if (padCount > 0) {
                encodedStr = encodedStr.substring(0, encodedStr.length() - padCount);
            }
        }
        
        // 使用临时数组存储结果
        byte[] tempResult = new byte[(encodedStr.length() * 3) / 4 + 3];
        int resultIndex = 0;
        
        // 按每4个字符为一组进行处理
        for (int i = 0; i < encodedStr.length(); i += 4) {
            int chunkLength = Math.min(4, encodedStr.length() - i);
            
            // 获取索引值
            Integer idx1Obj = REVERSE_MAP.get(encodedStr.charAt(i));
            if (idx1Obj == null) {
                throw new IllegalArgumentException("Invalid character in input: " + encodedStr.charAt(i));
            }
            int idx1 = idx1Obj;
            
            int idx2 = 0, idx3 = 0, idx4 = 0;
            
            if (chunkLength > 1) {
                Integer idx2Obj = REVERSE_MAP.get(encodedStr.charAt(i + 1));
                if (idx2Obj == null) {
                    throw new IllegalArgumentException("Invalid character in input: " + encodedStr.charAt(i + 1));
                }
                idx2 = idx2Obj;
            }
            
            if (chunkLength > 2) {
                Integer idx3Obj = REVERSE_MAP.get(encodedStr.charAt(i + 2));
                if (idx3Obj == null) {
                    throw new IllegalArgumentException("Invalid character in input: " + encodedStr.charAt(i + 2));
                }
                idx3 = idx3Obj;
            }
            
            if (chunkLength > 3) {
                Integer idx4Obj = REVERSE_MAP.get(encodedStr.charAt(i + 3));
                if (idx4Obj == null) {
                    throw new IllegalArgumentException("Invalid character in input: " + encodedStr.charAt(i + 3));
                }
                idx4 = idx4Obj;
            }
            
            // 将4个6位索引重组为3个字节
            byte byte1 = (byte) ((idx1 << 2) | (idx2 >> 4));
            tempResult[resultIndex++] = byte1;
            
            if (chunkLength > 2) {
                byte byte2 = (byte) (((idx2 & 0x0F) << 4) | (idx3 >> 2));
                tempResult[resultIndex++] = byte2;
            }
            
            if (chunkLength > 3) {
                byte byte3 = (byte) (((idx3 & 0x03) << 6) | idx4);
                tempResult[resultIndex++] = byte3;
            }
        }
        
        // 创建正确大小的结果数组
        byte[] result = new byte[resultIndex];
        System.arraycopy(tempResult, 0, result, 0, resultIndex);
        
        return result;
    }
}
