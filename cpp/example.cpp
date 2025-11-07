/**
 * @file example.cpp
 * @brief Hachi64 使用示例
 */

#include "hachi64/hachi64.hpp"
#include <iostream>
#include <string>
#include <vector>

int main() {
    std::cout << "=== Hachi64 编解码示例 ===" << std::endl << std::endl;

    // 示例1：编码和解码简单文本
    {
        std::string text = "Hello";
        std::vector<uint8_t> data(text.begin(), text.end());
        
        std::string encoded = hachi64::encode(data);
        std::cout << "原始文本: " << text << std::endl;
        std::cout << "编码结果: " << encoded << std::endl;
        
        std::vector<uint8_t> decoded = hachi64::decode(encoded);
        std::string result(decoded.begin(), decoded.end());
        std::cout << "解码结果: " << result << std::endl;
        std::cout << std::endl;
    }

    // 示例2：编码多个例子
    {
        std::vector<std::string> examples = {
            "Hello, World!",
            "Python",
            "Base64",
            "Hachi64",
            "abc"
        };

        std::cout << "更多编码示例：" << std::endl;
        for (const auto& text : examples) {
            std::vector<uint8_t> data(text.begin(), text.end());
            std::string encoded = hachi64::encode(data);
            std::cout << "  \"" << text << "\" => \"" << encoded << "\"" << std::endl;
        }
        std::cout << std::endl;
    }

    // 示例3：不使用填充
    {
        std::string text = "Hello";
        std::vector<uint8_t> data(text.begin(), text.end());
        
        std::string encoded_with_padding = hachi64::encode(data, true);
        std::string encoded_no_padding = hachi64::encode(data, false);
        
        std::cout << "带填充: " << encoded_with_padding << std::endl;
        std::cout << "不带填充: " << encoded_no_padding << std::endl;
        std::cout << std::endl;
    }

    // 示例4：处理二进制数据
    {
        std::vector<uint8_t> binary_data = {0x00, 0xFF, 0x42, 0xAB, 0xCD};
        
        std::string encoded = hachi64::encode(binary_data);
        std::cout << "二进制数据编码: " << encoded << std::endl;
        
        std::vector<uint8_t> decoded = hachi64::decode(encoded);
        std::cout << "解码匹配: " << (decoded == binary_data ? "是" : "否") << std::endl;
        std::cout << std::endl;
    }

    // 示例5：错误处理
    {
        try {
            std::vector<uint8_t> result = hachi64::decode("Invalid123");
            std::cout << "不应该到达这里" << std::endl;
        } catch (const hachi64::HachiError& e) {
            std::cout << "捕获异常（预期）: " << e.what() << std::endl;
        }
    }

    return 0;
}
