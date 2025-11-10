/// 哈基米64 编解码器 - 使用64个中文字符进行 Base64 风格的编码和解码
///
/// Hachi64 使用一个独特的64个中文字符集(哈基米字符集)来进行Base64风格的编码和解码。
/// 字符按发音相似性分组，使编码后的字符串看起来更加和谐统一。
library hachi64;

import 'dart:typed_data';

/// 哈基米64字符集：64个中文字符，按同音字分组
const String hachiAlphabet =
    "哈蛤呵吉急集米咪迷南男难北背杯绿律虑豆斗抖啊阿额西希息嘎咖伽花华哗压鸭呀库酷苦奶乃耐龙隆拢曼慢漫波播玻叮丁订咚东冬囊路陆多都弥济";

/// Hachi64 编解码器类
class Hachi64 {
  /// 反向映射表，用于解码
  static final Map<int, int> _reverseMap = _buildReverseMap();

  /// 构建反向映射表
  static Map<int, int> _buildReverseMap() {
    final map = <int, int>{};
    final runes = hachiAlphabet.runes.toList();
    for (var i = 0; i < runes.length; i++) {
      map[runes[i]] = i;
    }
    return map;
  }

  /// 使用哈基米64字符集编码字节数组
  ///
  /// [data] 要编码的字节数组
  /// [padding] 是否使用 '=' 进行填充，默认为 true
  /// 返回编码后的字符串
  static String encode(Uint8List data, {bool padding = true}) {
    if (data.isEmpty) {
      return '';
    }

    final alphabet = hachiAlphabet.runes.toList();
    final result = StringBuffer();

    var i = 0;
    while (i < data.length) {
      // 获取字节值，不足的用0填充
      final byte1 = data[i];
      final byte2 = (i + 1 < data.length) ? data[i + 1] : 0;
      final byte3 = (i + 2 < data.length) ? data[i + 2] : 0;

      final chunkLength = (data.length - i).clamp(0, 3);

      // 将24位分成4个6位索引
      final idx1 = byte1 >> 2;
      final idx2 = ((byte1 & 0x03) << 4) | (byte2 >> 4);
      final idx3 = ((byte2 & 0x0F) << 2) | (byte3 >> 6);
      final idx4 = byte3 & 0x3F;

      // 添加前两个字符（总是存在）
      result.writeCharCode(alphabet[idx1]);
      result.writeCharCode(alphabet[idx2]);

      // 处理第三个字符
      if (chunkLength > 1) {
        result.writeCharCode(alphabet[idx3]);
      } else if (padding) {
        result.write('=');
      }

      // 处理第四个字符
      if (chunkLength > 2) {
        result.writeCharCode(alphabet[idx4]);
      } else if (padding) {
        result.write('=');
      }

      i += 3;
    }

    return result.toString();
  }

  /// 使用哈基米64字符集解码字符串
  ///
  /// [encodedStr] 要解码的字符串
  /// [padding] 输入字符串是否使用 '=' 进行填充，默认为 true
  /// 返回解码后的字节数组
  ///
  /// 如果输入包含无效字符，抛出 [FormatException]
  static Uint8List decode(String encodedStr, {bool padding = true}) {
    // 处理空字符串
    if (encodedStr.isEmpty) {
      return Uint8List(0);
    }

    var str = encodedStr;
    var padCount = 0;

    if (padding) {
      padCount = str.split('=').length - 1;
      if (padCount > 0) {
        str = str.substring(0, str.length - padCount);
      }
    }

    final result = <int>[];
    final runes = str.runes.toList();

    var i = 0;
    while (i < runes.length) {
      // 读取最多4个字符
      final chunk = <int>[];
      for (var j = 0; j < 4 && i + j < runes.length; j++) {
        chunk.add(runes[i + j]);
      }

      try {
        final idx1 = _reverseMap[chunk[0]]!;
        final idx2 = chunk.length > 1 ? _reverseMap[chunk[1]]! : 0;
        final idx3 = chunk.length > 2 ? _reverseMap[chunk[2]]! : 0;
        final idx4 = chunk.length > 3 ? _reverseMap[chunk[3]]! : 0;

        // 将4个6位索引重组为3个字节
        final byte1 = (idx1 << 2) | (idx2 >> 4);
        result.add(byte1);

        if (chunk.length > 2) {
          final byte2 = ((idx2 & 0x0F) << 4) | (idx3 >> 2);
          result.add(byte2);
        }

        if (chunk.length > 3) {
          final byte3 = ((idx3 & 0x03) << 6) | idx4;
          result.add(byte3);
        }
      } catch (e) {
        throw FormatException('Invalid character in input: $e');
      }

      i += 4;
    }

    return Uint8List.fromList(result);
  }
}
