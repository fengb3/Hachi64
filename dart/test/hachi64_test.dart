import 'dart:typed_data';
import 'dart:convert';
import 'package:test/test.dart';
import 'package:hachi64/hachi64.dart';

void main() {
  group('Hachi64 编码解码一致性测试', () {
    test('测试编码解码的一致性 - 各种字符串', () {
      final testCases = [
        'Hello, World!',
        'rust',
        'a',
        'ab',
        'abc',
        'Python',
        'Hachi64',
        '', // 空字符串
        'The quick brown fox jumps over the lazy dog',
      ];

      for (final testData in testCases) {
        final bytes = Uint8List.fromList(utf8.encode(testData));
        final encoded = Hachi64.encode(bytes);
        final decoded = Hachi64.decode(encoded);
        final decodedStr = utf8.decode(decoded);

        expect(decodedStr, equals(testData),
            reason: '编码解码不一致: $testData -> $encoded -> $decodedStr');
      }
    });

    test('测试二进制数据的编码解码', () {
      // 0-255的所有字节值
      final testData = Uint8List.fromList(List.generate(256, (i) => i));
      final encoded = Hachi64.encode(testData);
      final decoded = Hachi64.decode(encoded);

      expect(decoded, equals(testData), reason: '二进制数据编码解码失败');
    });
  });

  group('Hachi64 特定编码结果测试', () {
    test('测试特定的编码结果，确保使用中文字母表', () {
      final testCases = [
        {'input': 'Hello', 'expected': '豆米啊拢嘎米多='},
        {'input': 'abc', 'expected': '西阿南呀'},
        {'input': 'a', 'expected': '西律=='},
        {'input': 'ab', 'expected': '西阿迷='},
      ];

      for (final testCase in testCases) {
        final input = testCase['input']!;
        final expected = testCase['expected']!;
        final bytes = Uint8List.fromList(utf8.encode(input));
        final encoded = Hachi64.encode(bytes);

        expect(encoded, equals(expected),
            reason: '编码结果不匹配: $input -> 期望 $expected, 实际 $encoded');
      }
    });

    test('测试更多编码示例', () {
      final testCases = [
        {'input': 'Python', 'expected': '抖咪酷丁息米都慢'},
        {'input': 'Hello, World!', 'expected': '豆米啊拢嘎米多拢迷集伽漫咖苦播库迷律=='},
        {'input': 'Base64', 'expected': '律苦集叮希斗西丁'},
        {'input': 'Hachi64', 'expected': '豆米集呀息米库咚背哈=='},
      ];

      for (final testCase in testCases) {
        final input = testCase['input']!;
        final expected = testCase['expected']!;
        final bytes = Uint8List.fromList(utf8.encode(input));
        final encoded = Hachi64.encode(bytes);

        expect(encoded, equals(expected),
            reason: '编码结果不匹配: $input -> 期望 $expected, 实际 $encoded');
      }
    });
  });

  group('Hachi64 填充测试', () {
    test('测试无填充编码解码', () {
      final testCases = ['a', 'ab', 'abc', 'Hello'];

      for (final testData in testCases) {
        final bytes = Uint8List.fromList(utf8.encode(testData));
        final encodedNoPad = Hachi64.encode(bytes, padding: false);
        final decoded = Hachi64.decode(encodedNoPad, padding: false);
        final decodedStr = utf8.decode(decoded);

        expect(decodedStr, equals(testData),
            reason: '无填充编码解码不一致: $testData -> $encodedNoPad -> $decodedStr');
      }
    });

    test('测试填充行为', () {
      final testData = 'a';
      final bytes = Uint8List.fromList(utf8.encode(testData));

      // 有填充的编码
      final encodedWithPadding = Hachi64.encode(bytes, padding: true);
      // 无填充的编码
      final encodedWithoutPadding = Hachi64.encode(bytes, padding: false);

      // 有填充的应该有 == 结尾
      expect(encodedWithPadding.endsWith('=='), isTrue,
          reason: '有填充编码应该以==结尾: $encodedWithPadding');

      // 无填充的不应该有 =
      expect(encodedWithoutPadding.contains('='), isFalse,
          reason: '无填充编码不应该包含=: $encodedWithoutPadding');

      // 两种方式解码应该都能得到原始数据
      final decodedWithPadding =
          Hachi64.decode(encodedWithPadding, padding: true);
      final decodedWithoutPadding =
          Hachi64.decode(encodedWithoutPadding, padding: false);

      expect(utf8.decode(decodedWithPadding), equals(testData));
      expect(utf8.decode(decodedWithoutPadding), equals(testData));
    });
  });

  group('Hachi64 错误处理测试', () {
    test('测试解码无效输入', () {
      // 测试包含不在字母表中的字符
      expect(() => Hachi64.decode('包含无效字符X的字符串'), throwsFormatException,
          reason: '应该对无效字符抛出异常');
    });

    test('测试空字符串解码', () {
      final result = Hachi64.decode('');
      expect(result, equals(Uint8List(0)), reason: '空字符串应该解码为空字节数组');
    });
  });

  group('Hachi64 字母表测试', () {
    test('测试字母表长度', () {
      expect(hachiAlphabet.runes.length, equals(64), reason: '字母表长度应该为64');
    });

    test('测试字母表无重复字符', () {
      final runes = hachiAlphabet.runes.toList();
      final uniqueRunes = runes.toSet();
      expect(uniqueRunes.length, equals(64), reason: '字母表应该包含64个唯一字符');
    });

    test('测试长数据确保所有字符都可能被使用', () {
      // 较长的测试数据
      final baseList = List.generate(256, (i) => i);
      final longData =
          Uint8List.fromList([...baseList, ...baseList, ...baseList]);
      final encoded = Hachi64.encode(longData);
      final decoded = Hachi64.decode(encoded);

      expect(decoded, equals(longData), reason: '长数据编码解码应该一致');
    });
  });

  group('Hachi64 边界情况测试', () {
    test('测试单字节', () {
      final bytes = Uint8List.fromList([0]);
      final encoded = Hachi64.encode(bytes);
      final decoded = Hachi64.decode(encoded);
      expect(decoded, equals(bytes));
    });

    test('测试两字节', () {
      final bytes = Uint8List.fromList([0, 255]);
      final encoded = Hachi64.encode(bytes);
      final decoded = Hachi64.decode(encoded);
      expect(decoded, equals(bytes));
    });

    test('测试三字节对齐', () {
      final bytes = Uint8List.fromList([1, 2, 3]);
      final encoded = Hachi64.encode(bytes);
      final decoded = Hachi64.decode(encoded);
      expect(decoded, equals(bytes));
    });

    test('测试大量数据', () {
      final bytes = Uint8List.fromList(List.generate(10000, (i) => i % 256));
      final encoded = Hachi64.encode(bytes);
      final decoded = Hachi64.decode(encoded);
      expect(decoded, equals(bytes));
    });
  });
}
