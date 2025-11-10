import Foundation

/// 哈基米64 编解码器 - 使用64个中文字符进行 Base64 风格的编码和解码
///
/// Hachi64 使用一个独特的64个中文字符集(哈基米字符集)来进行Base64风格的编码和解码。
/// 字符按发音相似性分组，使编码后的字符串看起来更加和谐统一。
public struct Hachi64 {
    
    /// 哈基米64字符集：64个中文字符，按同音字分组
    public static let hachiAlphabet = "哈蛤呵吉急集米咪迷南男难北背杯绿律虑豆斗抖啊阿额西希息嘎咖伽花华哗压鸭呀库酷苦奶乃耐龙隆拢曼慢漫波播玻叮丁订咚东冬囊路陆多都弥济"
    
    private static let alphabetArray: [Character] = Array(hachiAlphabet)
    private static let reverseMap: [Character: Int] = {
        var map = [Character: Int]()
        for (index, char) in alphabetArray.enumerated() {
            map[char] = index
        }
        return map
    }()
    
    /// 使用哈基米64字符集编码字节数组
    ///
    /// - Parameters:
    ///   - data: 要编码的数据
    ///   - padding: 是否使用 '=' 进行填充（默认为 true）
    /// - Returns: 编码后的字符串
    public static func encode(_ data: Data, padding: Bool = true) -> String {
        guard !data.isEmpty else { return "" }
        
        var result = ""
        var i = 0
        let dataArray = [UInt8](data)
        
        while i < dataArray.count {
            // 获取字节值，不足的用0填充
            let byte1 = dataArray[i]
            let byte2: UInt8 = (i + 1 < dataArray.count) ? dataArray[i + 1] : 0
            let byte3: UInt8 = (i + 2 < dataArray.count) ? dataArray[i + 2] : 0
            
            let chunkLength = min(3, dataArray.count - i)
            
            // 将24位分成4个6位索引
            let idx1 = Int(byte1 >> 2)
            let idx2 = Int(((byte1 & 0x03) << 4) | (byte2 >> 4))
            let idx3 = Int(((byte2 & 0x0F) << 2) | (byte3 >> 6))
            let idx4 = Int(byte3 & 0x3F)
            
            // 添加前两个字符（总是存在）
            result.append(alphabetArray[idx1])
            result.append(alphabetArray[idx2])
            
            // 处理第三个字符
            if chunkLength > 1 {
                result.append(alphabetArray[idx3])
            } else if padding {
                result.append("=")
            }
            
            // 处理第四个字符
            if chunkLength > 2 {
                result.append(alphabetArray[idx4])
            } else if padding {
                result.append("=")
            }
            
            i += 3
        }
        
        return result
    }
    
    /// 解码使用哈基米64字符集编码的字符串
    ///
    /// - Parameters:
    ///   - encodedString: 要解码的字符串
    ///   - padding: 输入字符串是否使用 '=' 进行填充（默认为 true）
    /// - Returns: 解码后的数据
    /// - Throws: 当输入字符串包含无效字符时抛出错误
    public static func decode(_ encodedString: String, padding: Bool = true) throws -> Data {
        guard !encodedString.isEmpty else { return Data() }
        
        var processedString = encodedString
        var padCount = 0
        
        // 处理填充
        if padding {
            padCount = encodedString.filter { $0 == "=" }.count
            if padCount > 0 {
                processedString = String(encodedString.dropLast(padCount))
            }
        }
        
        var result = [UInt8]()
        let chars = Array(processedString)
        var i = 0
        
        while i < chars.count {
            let chunkLength = min(4, chars.count - i)
            
            // 获取索引值
            guard let idx1 = reverseMap[chars[i]] else {
                throw Hachi64Error.invalidCharacter(chars[i])
            }
            
            var idx2 = 0, idx3 = 0, idx4 = 0
            
            if chunkLength > 1 {
                guard let value = reverseMap[chars[i + 1]] else {
                    throw Hachi64Error.invalidCharacter(chars[i + 1])
                }
                idx2 = value
            }
            
            if chunkLength > 2 {
                guard let value = reverseMap[chars[i + 2]] else {
                    throw Hachi64Error.invalidCharacter(chars[i + 2])
                }
                idx3 = value
            }
            
            if chunkLength > 3 {
                guard let value = reverseMap[chars[i + 3]] else {
                    throw Hachi64Error.invalidCharacter(chars[i + 3])
                }
                idx4 = value
            }
            
            // 将4个6位索引重组为3个字节
            let byte1 = UInt8((idx1 << 2) | (idx2 >> 4))
            result.append(byte1)
            
            if chunkLength > 2 {
                let byte2 = UInt8(((idx2 & 0x0F) << 4) | (idx3 >> 2))
                result.append(byte2)
            }
            
            if chunkLength > 3 {
                let byte3 = UInt8(((idx3 & 0x03) << 6) | idx4)
                result.append(byte3)
            }
            
            i += 4
        }
        
        return Data(result)
    }
}

/// 哈基米64编解码错误类型
public enum Hachi64Error: Error, CustomStringConvertible {
    case invalidCharacter(Character)
    
    public var description: String {
        switch self {
        case .invalidCharacter(let char):
            return "Invalid character in input: \(char)"
        }
    }
}
