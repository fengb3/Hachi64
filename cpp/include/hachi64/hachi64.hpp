/**
 * @file hachi64.hpp
 * @brief Hachi64 编解码器 - 使用64个中文字符进行 Base64 风格的编码和解码
 * 
 * 哈吉米64使用64个中文字符，这些字符按发音相似性分组，使编码后的字符串看起来更加和谐统一。
 */

#ifndef HACHI64_HPP
#define HACHI64_HPP

#include <string>
#include <vector>
#include <unordered_map>
#include <stdexcept>
#include <cstdint>

namespace hachi64 {

/// 哈吉米64字符集：64个中文字符，按同音字分组
constexpr const char* HACHI_ALPHABET = "哈蛤呵吉急集米咪迷南男难北背杯绿律虑豆斗抖啊阿额西希息嘎咖伽花华哗压鸭呀库酷苦奶乃耐龙隆拢曼慢漫波播玻叮丁订咚东冬囊路陆多都弥济";

/**
 * @brief 哈吉米64编解码过程中可能发生的异常
 */
class HachiError : public std::runtime_error {
public:
    explicit HachiError(const std::string& message) 
        : std::runtime_error(message) {}
};

namespace detail {
    /**
     * @brief 将UTF-8编码的字符串分解为字符向量
     * @param str UTF-8编码的字符串
     * @return 字符向量，每个元素是一个UTF-8字符
     */
    inline std::vector<std::string> split_utf8_chars(const std::string& str) {
        std::vector<std::string> chars;
        size_t i = 0;
        while (i < str.length()) {
            int char_len = 1;
            unsigned char c = str[i];
            
            // UTF-8 字符长度判断
            if ((c & 0x80) == 0) {
                char_len = 1;
            } else if ((c & 0xE0) == 0xC0) {
                char_len = 2;
            } else if ((c & 0xF0) == 0xE0) {
                char_len = 3;
            } else if ((c & 0xF8) == 0xF0) {
                char_len = 4;
            }
            
            chars.push_back(str.substr(i, char_len));
            i += char_len;
        }
        return chars;
    }

    /**
     * @brief 获取字母表的字符向量（单例模式）
     */
    inline const std::vector<std::string>& get_alphabet() {
        static const std::vector<std::string> alphabet = split_utf8_chars(HACHI_ALPHABET);
        return alphabet;
    }

    /**
     * @brief 获取反向映射表（单例模式）
     */
    inline const std::unordered_map<std::string, uint8_t>& get_reverse_map() {
        static std::unordered_map<std::string, uint8_t> reverse_map = []() {
            std::unordered_map<std::string, uint8_t> map;
            const auto& alphabet = get_alphabet();
            for (size_t i = 0; i < alphabet.size(); ++i) {
                map[alphabet[i]] = static_cast<uint8_t>(i);
            }
            return map;
        }();
        return reverse_map;
    }
}

/**
 * @brief 使用哈吉米64字符集编码数据
 * 
 * @param data 要编码的字节数据
 * @param padding 是否使用'='进行填充（默认为true）
 * @return 编码后的字符串
 * 
 * @example
 * ```cpp
 * std::vector<uint8_t> data = {'H', 'e', 'l', 'l', 'o'};
 * std::string encoded = hachi64::encode(data);
 * // encoded == "豆米啊拢嘎米多="
 * ```
 */
inline std::string encode(const std::vector<uint8_t>& data, bool padding = true) {
    const auto& alphabet = detail::get_alphabet();
    std::string result;
    result.reserve((data.size() / 3 + 1) * 4 * 3); // 预分配空间（考虑UTF-8字符）

    for (size_t i = 0; i < data.size(); i += 3) {
        // 获取字节值，不足的用0填充
        uint8_t byte1 = data[i];
        uint8_t byte2 = (i + 1 < data.size()) ? data[i + 1] : 0;
        uint8_t byte3 = (i + 2 < data.size()) ? data[i + 2] : 0;

        // 将24位分成4个6位索引
        uint8_t idx1 = byte1 >> 2;
        uint8_t idx2 = ((byte1 & 0x03) << 4) | (byte2 >> 4);
        uint8_t idx3 = ((byte2 & 0x0F) << 2) | (byte3 >> 6);
        uint8_t idx4 = byte3 & 0x3F;

        // 添加前两个字符（总是存在）
        result += alphabet[idx1];
        result += alphabet[idx2];

        // 处理第三个字符
        if (i + 1 < data.size()) {
            result += alphabet[idx3];
        } else if (padding) {
            result += '=';
        }

        // 处理第四个字符
        if (i + 2 < data.size()) {
            result += alphabet[idx4];
        } else if (padding) {
            result += '=';
        }
    }

    return result;
}

/**
 * @brief 使用哈吉米64字符集解码字符串
 * 
 * @param encoded_str 要解码的字符串
 * @param padding 输入字符串是否使用'='填充（默认为true）
 * @return 解码后的字节数据
 * @throws HachiError 当输入字符串包含不在哈吉米64字符集中的字符时抛出
 * 
 * @example
 * ```cpp
 * std::vector<uint8_t> decoded = hachi64::decode("豆米啊拢嘎米多=");
 * // decoded == {'H', 'e', 'l', 'l', 'o'}
 * ```
 */
inline std::vector<uint8_t> decode(const std::string& encoded_str, bool padding = true) {
    const auto& reverse_map = detail::get_reverse_map();

    // 处理空字符串
    if (encoded_str.empty()) {
        return std::vector<uint8_t>();
    }

    // 处理填充
    std::string s = encoded_str;
    if (padding) {
        while (!s.empty() && s.back() == '=') {
            s.pop_back();
        }
    }

    // 分解UTF-8字符
    auto chars = detail::split_utf8_chars(s);
    std::vector<uint8_t> result;
    result.reserve((chars.size() * 3) / 4);

    // 按每4个字符为一组进行切分
    for (size_t i = 0; i < chars.size(); i += 4) {
        // 获取索引值
        auto it1 = reverse_map.find(chars[i]);
        if (it1 == reverse_map.end()) {
            throw HachiError("Invalid character in input: " + chars[i]);
        }
        uint8_t idx1 = it1->second;

        uint8_t idx2 = 0;
        if (i + 1 < chars.size()) {
            auto it2 = reverse_map.find(chars[i + 1]);
            if (it2 == reverse_map.end()) {
                throw HachiError("Invalid character in input: " + chars[i + 1]);
            }
            idx2 = it2->second;
        }

        uint8_t idx3 = 0;
        if (i + 2 < chars.size()) {
            auto it3 = reverse_map.find(chars[i + 2]);
            if (it3 == reverse_map.end()) {
                throw HachiError("Invalid character in input: " + chars[i + 2]);
            }
            idx3 = it3->second;
        }

        uint8_t idx4 = 0;
        if (i + 3 < chars.size()) {
            auto it4 = reverse_map.find(chars[i + 3]);
            if (it4 == reverse_map.end()) {
                throw HachiError("Invalid character in input: " + chars[i + 3]);
            }
            idx4 = it4->second;
        }

        // 将4个6位索引重组为3个字节
        uint8_t byte1 = (idx1 << 2) | (idx2 >> 4);
        result.push_back(byte1);

        if (i + 2 < chars.size()) {
            uint8_t byte2 = ((idx2 & 0x0F) << 4) | (idx3 >> 2);
            result.push_back(byte2);
        }

        if (i + 3 < chars.size()) {
            uint8_t byte3 = ((idx3 & 0x03) << 6) | idx4;
            result.push_back(byte3);
        }
    }

    return result;
}

} // namespace hachi64

#endif // HACHI64_HPP
