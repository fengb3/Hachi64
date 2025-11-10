//! # Hachi64
//!
//! 哈基米64 编解码器 - 使用64个中文字符进行 Base64 风格的编码和解码。
//!
//! 本库提供了使用自定义哈基米64字符集来创建哈基米64风格编码的工具。
//! 哈基米64使用64个中文字符，这些字符按发音相似性分组，使编码后的字符串看起来更加和谐统一。

use std::collections::HashMap;
use std::sync::OnceLock;

/// 哈基米64字符集：64个中文字符，按同音字分组
pub const HACHI_ALPHABET: &str = "哈蛤呵吉急集米咪迷南男难北背杯绿律虑豆斗抖啊阿额西希息嘎咖伽花华哗压鸭呀库酷苦奶乃耐龙隆拢曼慢漫波播玻叮丁订咚东冬囊路陆多都弥济";

/// 用于解码的反向映射表（懒加载单例）
static REVERSE_MAP: OnceLock<HashMap<char, u8>> = OnceLock::new();
/// 用于编码的字符集向量（懒加载单例）
static ALPHABET_VEC: OnceLock<Vec<char>> = OnceLock::new();

/// 获取字符集向量的单例
fn get_alphabet() -> &'static Vec<char> {
    ALPHABET_VEC.get_or_init(|| HACHI_ALPHABET.chars().collect())
}

/// 获取反向映射表的单例
fn get_reverse_map() -> &'static HashMap<char, u8> {
    REVERSE_MAP.get_or_init(|| {
        let mut map = HashMap::with_capacity(64);
        for (i, ch) in HACHI_ALPHABET.chars().enumerate() {
            map.insert(ch, i as u8);
        }
        map
    })
}

/// 哈基米64编解码过程中可能发生的错误
#[derive(Debug, PartialEq, Eq)]
pub enum HachiError {
    /// 解码输入字符串无效（例如，包含不在字符集中的字符）
    InvalidInput,
}

/// 使用默认设置编码数据
///
/// # Examples
///
/// ```
/// use hachi64::encode;
///
/// let encoded = encode(b"Hello");
/// assert_eq!(encoded, "豆米啊拢嘎米多=");
/// ```
pub fn encode(data: &[u8]) -> String {
    let alphabet = get_alphabet();
    let padding = true; // 默认使用填充
    let mut result = String::with_capacity((data.len() / 3 + 1) * 4);

    for chunk in data.chunks(3) {
        // 获取字节值，不足的用0填充
        let byte1 = chunk[0];
        let byte2 = chunk.get(1).copied().unwrap_or(0);
        let byte3 = chunk.get(2).copied().unwrap_or(0);

        // 将24位分成4个6位索引
        let idx1 = byte1 >> 2;
        let idx2 = ((byte1 & 0x03) << 4) | (byte2 >> 4);
        let idx3 = ((byte2 & 0x0F) << 2) | (byte3 >> 6);
        let idx4 = byte3 & 0x3F;

        // 添加前两个字符（总是存在）
        result.push(alphabet[idx1 as usize]);
        result.push(alphabet[idx2 as usize]);

        // 处理第三个字符
        if chunk.len() > 1 {
            result.push(alphabet[idx3 as usize]);
        } else if padding {
            result.push('=');
        }

        // 处理第四个字符
        if chunk.len() > 2 {
            result.push(alphabet[idx4 as usize]);
        } else if padding {
            result.push('=');
        }
    }
    result
}

/// 使用默认设置解码字符串
///
/// # Examples
///
/// ```
/// use hachi64::decode;
///
/// let decoded = decode("豆米啊拢嘎米多=").unwrap();
/// assert_eq!(decoded, b"Hello");
/// ```
///
/// # Errors
///
/// 当输入字符串包含不在哈基米64字符集中的字符时，返回 [`HachiError::InvalidInput`]。
pub fn decode(encoded_str: &str) -> Result<Vec<u8>, HachiError> {
    let reverse_map = get_reverse_map();
    let padding = true; // 默认处理填充

    // 处理空字符串
    if encoded_str.is_empty() {
        return Ok(Vec::new());
    }

    // 处理填充
    let pad_count = if padding {
        encoded_str.chars().rev().take_while(|&c| c == '=').count()
    } else {
        0
    };

    let s = if pad_count > 0 {
        &encoded_str[..encoded_str.len() - pad_count]
    } else {
        encoded_str
    };

    let chars: Vec<char> = s.chars().collect();
    let mut result = Vec::with_capacity((chars.len() * 3) / 4);

    // 按每4个字符为一组进行切分
    for chunk in chars.chunks(4) {
        // 获取索引值
        let idx1 = *reverse_map.get(&chunk[0]).ok_or(HachiError::InvalidInput)?;
        let idx2 = if chunk.len() > 1 {
            *reverse_map.get(&chunk[1]).ok_or(HachiError::InvalidInput)?
        } else {
            0
        };
        let idx3 = if chunk.len() > 2 {
            *reverse_map.get(&chunk[2]).ok_or(HachiError::InvalidInput)?
        } else {
            0
        };
        let idx4 = if chunk.len() > 3 {
            *reverse_map.get(&chunk[3]).ok_or(HachiError::InvalidInput)?
        } else {
            0
        };

        // 将4个6位索引重组为3个字节
        let byte1 = (idx1 << 2) | (idx2 >> 4);
        result.push(byte1);

        if chunk.len() > 2 {
            let byte2 = ((idx2 & 0x0F) << 4) | (idx3 >> 2);
            result.push(byte2);
        }

        if chunk.len() > 3 {
            let byte3 = ((idx3 & 0x03) << 6) | idx4;
            result.push(byte3);
        }
    }
    Ok(result)
}


#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_encode_hachi64_examples() {
        // 测试 README 中的编码示例
        assert_eq!(encode(b"Hello"), "豆米啊拢嘎米多=");
        assert_eq!(encode(b"abc"), "西阿南呀");
        assert_eq!(encode(b"Python"), "抖咪酷丁息米都慢");
        assert_eq!(encode(b"Hello, World!"), "豆米啊拢嘎米多拢迷集伽漫咖苦播库迷律==");
        assert_eq!(encode(b"Base64"), "律苦集叮希斗西丁");
        assert_eq!(encode(b"Hachi64"), "豆米集呀息米库咚背哈==");
    }

    #[test]
    fn test_decode_hachi64_examples() {
        // 测试 README 中的解码示例
        assert_eq!(decode("豆米啊拢嘎米多=").unwrap(), b"Hello");
        assert_eq!(decode("西阿南呀").unwrap(), b"abc");
        assert_eq!(decode("抖咪酷丁息米都慢").unwrap(), b"Python");
        assert_eq!(decode("豆米啊拢嘎米多拢迷集伽漫咖苦播库迷律==").unwrap(), b"Hello, World!");
        assert_eq!(decode("律苦集叮希斗西丁").unwrap(), b"Base64");
        assert_eq!(decode("豆米集呀息米库咚背哈==").unwrap(), b"Hachi64");
    }

    #[test]
    fn test_encode_edge_cases() {
        // 空字符串
        assert_eq!(encode(b""), "");
        
        // 单字节
        assert_eq!(encode(b"a"), "西律==");
        
        // 双字节
        assert_eq!(encode(b"ab"), "西阿迷=");
    }

    #[test]
    fn test_decode_edge_cases() {
        // 空字符串
        assert_eq!(decode("").unwrap(), b"");
        
        // 单字节
        assert_eq!(decode("西律==").unwrap(), b"a");
        
        // 双字节
        assert_eq!(decode("西阿南=").unwrap(), b"ab");
    }

    #[test]
    fn test_decode_invalid_input() {
        // 包含不在字符集中的字符
        assert_eq!(decode("ABC"), Err(HachiError::InvalidInput));
        assert_eq!(decode("哈哈哈X"), Err(HachiError::InvalidInput));
    }

    #[test]
    fn test_roundtrip() {
        let test_data = b"The quick brown fox jumps over the lazy dog";
        
        let encoded = encode(test_data);
        let decoded = decode(&encoded).unwrap();
        
        assert_eq!(decoded, test_data);
    }

    #[test]
    fn test_binary_data() {
        let binary_data: Vec<u8> = (0..=255).collect();
        
        let encoded = encode(&binary_data);
        let decoded = decode(&encoded).unwrap();
        
        assert_eq!(decoded, binary_data);
    }
}
