import 'dart:typed_data';
import 'dart:convert';
import 'package:hachi64/hachi64.dart';

void main() {
  print('=== 哈吉米64 (Hachi64) 示例 ===\n');

  // 示例 1: 基本编码和解码
  print('示例 1: 基本编码和解码');
  final text1 = 'Hello, World!';
  final bytes1 = Uint8List.fromList(utf8.encode(text1));
  final encoded1 = Hachi64.encode(bytes1);
  final decoded1 = Hachi64.decode(encoded1);
  final result1 = utf8.decode(decoded1);

  print('原始文本: $text1');
  print('编码结果: $encoded1');
  print('解码结果: $result1');
  print('验证: ${text1 == result1 ? "✓ 成功" : "✗ 失败"}\n');

  // 示例 2: 不使用填充
  print('示例 2: 不使用填充');
  final text2 = 'Hello';
  final bytes2 = Uint8List.fromList(utf8.encode(text2));
  final encoded2 = Hachi64.encode(bytes2, padding: false);
  final decoded2 = Hachi64.decode(encoded2, padding: false);
  final result2 = utf8.decode(decoded2);

  print('原始文本: $text2');
  print('编码结果(无填充): $encoded2');
  print('解码结果: $result2');
  print('验证: ${text2 == result2 ? "✓ 成功" : "✗ 失败"}\n');

  // 示例 3: 多个测试用例
  print('示例 3: 多个测试用例');
  final testCases = [
    'Hello',
    'abc',
    'Python',
    'Base64',
    'Hachi64',
  ];

  for (final testCase in testCases) {
    final bytes = Uint8List.fromList(utf8.encode(testCase));
    final encoded = Hachi64.encode(bytes);
    print('  $testCase -> $encoded');
  }
  print('');

  // 示例 4: 二进制数据
  print('示例 4: 二进制数据');
  final binaryData = Uint8List.fromList([0, 1, 2, 255, 254, 253]);
  final encodedBinary = Hachi64.encode(binaryData);
  final decodedBinary = Hachi64.decode(encodedBinary);

  print('原始二进制: ${binaryData.toList()}');
  print('编码结果: $encodedBinary');
  print('解码二进制: ${decodedBinary.toList()}');
  print('验证: ${_areEqual(binaryData, decodedBinary) ? "✓ 成功" : "✗ 失败"}\n');

  // 示例 5: 字母表信息
  print('示例 5: 字母表信息');
  print('字母表长度: ${hachiAlphabet.runes.length}');
  print('字母表: $hachiAlphabet\n');

  print('=== 所有示例完成 ===');
}

bool _areEqual(Uint8List a, Uint8List b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
