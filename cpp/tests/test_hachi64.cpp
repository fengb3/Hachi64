#include <gtest/gtest.h>
#include "hachi64/hachi64.hpp"
#include <string>
#include <vector>
#include <set>

using namespace hachi64;

// 辅助函数：将字符串转换为字节向量
std::vector<uint8_t> str_to_bytes(const std::string& str) {
    return std::vector<uint8_t>(str.begin(), str.end());
}

// 辅助函数：将字节向量转换为字符串
std::string bytes_to_str(const std::vector<uint8_t>& bytes) {
    return std::string(bytes.begin(), bytes.end());
}

// 测试 README 中的编码示例
TEST(Hachi64Test, EncodeExamples) {
    EXPECT_EQ(encode(str_to_bytes("Hello")), "豆米啊拢嘎米多=");
    EXPECT_EQ(encode(str_to_bytes("abc")), "西阿南呀");
    EXPECT_EQ(encode(str_to_bytes("Python")), "抖咪酷丁息米都慢");
    EXPECT_EQ(encode(str_to_bytes("Hello, World!")), "豆米啊拢嘎米多拢迷集伽漫咖苦播库迷律==");
    EXPECT_EQ(encode(str_to_bytes("Base64")), "律苦集叮希斗西丁");
    EXPECT_EQ(encode(str_to_bytes("Hachi64")), "豆米集呀息米库咚背哈==");
}

// 测试 README 中的解码示例
TEST(Hachi64Test, DecodeExamples) {
    EXPECT_EQ(bytes_to_str(decode("豆米啊拢嘎米多=")), "Hello");
    EXPECT_EQ(bytes_to_str(decode("西阿南呀")), "abc");
    EXPECT_EQ(bytes_to_str(decode("抖咪酷丁息米都慢")), "Python");
    EXPECT_EQ(bytes_to_str(decode("豆米啊拢嘎米多拢迷集伽漫咖苦播库迷律==")), "Hello, World!");
    EXPECT_EQ(bytes_to_str(decode("律苦集叮希斗西丁")), "Base64");
    EXPECT_EQ(bytes_to_str(decode("豆米集呀息米库咚背哈==")), "Hachi64");
}

// 测试编码边缘情况
TEST(Hachi64Test, EncodeEdgeCases) {
    // 空字符串
    EXPECT_EQ(encode(std::vector<uint8_t>()), "");
    
    // 单字节
    EXPECT_EQ(encode(str_to_bytes("a")), "西律==");
    
    // 双字节
    EXPECT_EQ(encode(str_to_bytes("ab")), "西阿迷=");
}

// 测试解码边缘情况
TEST(Hachi64Test, DecodeEdgeCases) {
    // 空字符串
    EXPECT_EQ(decode(""), std::vector<uint8_t>());
    
    // 单字节
    EXPECT_EQ(bytes_to_str(decode("西律==")), "a");
    
    // 双字节
    EXPECT_EQ(bytes_to_str(decode("西阿迷=")), "ab");
}

// 测试解码无效输入
TEST(Hachi64Test, DecodeInvalidInput) {
    // 包含不在字符集中的字符
    EXPECT_THROW(decode("ABC"), HachiError);
    EXPECT_THROW(decode("哈哈哈X"), HachiError);
}

// 测试往返编码
TEST(Hachi64Test, Roundtrip) {
    std::string test_data = "The quick brown fox jumps over the lazy dog";
    
    std::string encoded = encode(str_to_bytes(test_data));
    std::vector<uint8_t> decoded = decode(encoded);
    
    EXPECT_EQ(bytes_to_str(decoded), test_data);
}

// 测试二进制数据
TEST(Hachi64Test, BinaryData) {
    std::vector<uint8_t> binary_data;
    for (int i = 0; i <= 255; ++i) {
        binary_data.push_back(static_cast<uint8_t>(i));
    }
    
    std::string encoded = encode(binary_data);
    std::vector<uint8_t> decoded = decode(encoded);
    
    EXPECT_EQ(decoded, binary_data);
}

// 测试不带填充的编码
TEST(Hachi64Test, EncodeNoPadding) {
    EXPECT_EQ(encode(str_to_bytes("a"), false), "西律");
    EXPECT_EQ(encode(str_to_bytes("ab"), false), "西阿迷");
    EXPECT_EQ(encode(str_to_bytes("Hello"), false), "豆米啊拢嘎米多");
}

// 测试不带填充的解码
TEST(Hachi64Test, DecodeNoPadding) {
    EXPECT_EQ(bytes_to_str(decode("西律", false)), "a");
    EXPECT_EQ(bytes_to_str(decode("西阿迷", false)), "ab");
    EXPECT_EQ(bytes_to_str(decode("豆米啊拢嘎米多", false)), "Hello");
}

// 测试各种长度的数据
TEST(Hachi64Test, VariousLengths) {
    for (size_t len = 0; len <= 100; ++len) {
        std::vector<uint8_t> data(len);
        for (size_t i = 0; i < len; ++i) {
            data[i] = static_cast<uint8_t>(i % 256);
        }
        
        std::string encoded = encode(data);
        std::vector<uint8_t> decoded = decode(encoded);
        
        EXPECT_EQ(decoded, data) << "Failed for length " << len;
    }
}

// 测试空格和特殊字符
TEST(Hachi64Test, SpecialCharacters) {
    std::string test_data = "Hello\nWorld\t!\r\n";
    
    std::string encoded = encode(str_to_bytes(test_data));
    std::vector<uint8_t> decoded = decode(encoded);
    
    EXPECT_EQ(bytes_to_str(decoded), test_data);
}

// 测试中文字符编码
TEST(Hachi64Test, ChineseCharacters) {
    std::string test_data = "你好世界";
    
    std::string encoded = encode(str_to_bytes(test_data));
    std::vector<uint8_t> decoded = decode(encoded);
    
    EXPECT_EQ(bytes_to_str(decoded), test_data);
}

// 测试字符集完整性
TEST(Hachi64Test, AlphabetCompleteness) {
    // 验证字符集有64个字符
    auto chars = detail::split_utf8_chars(HACHI_ALPHABET);
    EXPECT_EQ(chars.size(), 64);
    
    // 验证所有字符都是唯一的
    std::set<std::string> unique_chars(chars.begin(), chars.end());
    EXPECT_EQ(unique_chars.size(), 64);
}

// 测试反向映射表完整性
TEST(Hachi64Test, ReverseMappingCompleteness) {
    const auto& reverse_map = detail::get_reverse_map();
    
    // 验证映射表有64个条目
    EXPECT_EQ(reverse_map.size(), 64);
    
    // 验证所有索引从0到63都存在
    std::vector<bool> indices_present(64, false);
    for (const auto& pair : reverse_map) {
        EXPECT_LT(pair.second, 64);
        indices_present[pair.second] = true;
    }
    
    for (size_t i = 0; i < 64; ++i) {
        EXPECT_TRUE(indices_present[i]) << "Index " << i << " is missing";
    }
}
