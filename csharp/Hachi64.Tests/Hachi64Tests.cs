using System;
using System.Linq;
using System.Text;
using Xunit;

namespace Hachi64.Tests
{
    public class Hachi64Tests
    {
        [Fact]
        public void TestEncodeDecodeConsistency()
        {
            var testCases = new[]
            {
                "Hello, World!",
                "rust",
                "a",
                "ab",
                "abc",
                "Python",
                "Hachi64",
                "",
                "The quick brown fox jumps over the lazy dog"
            };

            foreach (var testData in testCases)
            {
                var bytes = Encoding.UTF8.GetBytes(testData);
                var encoded = Hachi64.Encode(bytes);
                var decoded = Hachi64.Decode(encoded);
                
                Assert.Equal(bytes, decoded);
            }
        }

        [Theory]
        [InlineData("Hello", "豆米啊拢嘎米多=")]
        [InlineData("abc", "西阿南呀")]
        [InlineData("a", "西律==")]
        [InlineData("ab", "西阿迷=")]
        [InlineData("Python", "抖咪酷丁息米都慢")]
        [InlineData("Hello, World!", "豆米啊拢嘎米多拢迷集伽漫咖苦播库迷律==")]
        [InlineData("Base64", "律苦集叮希斗西丁")]
        [InlineData("Hachi64", "豆米集呀息米库咚背哈==")]
        public void TestSpecificEncodings(string input, string expected)
        {
            var bytes = Encoding.UTF8.GetBytes(input);
            var encoded = Hachi64.Encode(bytes);
            
            Assert.Equal(expected, encoded);
        }

        [Fact]
        public void TestBinaryData()
        {
            var testData = Enumerable.Range(0, 256).Select(i => (byte)i).ToArray();
            var encoded = Hachi64.Encode(testData);
            var decoded = Hachi64.Decode(encoded);
            
            Assert.Equal(testData, decoded);
        }

        [Fact]
        public void TestNoPaddingEncodeDecod()
        {
            var testCases = new[] { "a", "ab", "abc", "Hello" };

            foreach (var testData in testCases)
            {
                var bytes = Encoding.UTF8.GetBytes(testData);
                var encodedNoPad = Hachi64.Encode(bytes, padding: false);
                var decoded = Hachi64.Decode(encodedNoPad, padding: false);
                
                Assert.Equal(bytes, decoded);
            }
        }

        [Fact]
        public void TestPaddingBehavior()
        {
            var testData = Encoding.UTF8.GetBytes("a");

            var encodedWithPadding = Hachi64.Encode(testData, padding: true);
            var encodedWithoutPadding = Hachi64.Encode(testData, padding: false);

            // 有填充的应该有 == 结尾
            Assert.EndsWith("==", encodedWithPadding);

            // 无填充的不应该有 = 
            Assert.DoesNotContain("=", encodedWithoutPadding);

            // 两种方式解码应该都能得到原始数据
            var decodedWithPadding = Hachi64.Decode(encodedWithPadding, padding: true);
            var decodedWithoutPadding = Hachi64.Decode(encodedWithoutPadding, padding: false);

            Assert.Equal(testData, decodedWithPadding);
            Assert.Equal(testData, decodedWithoutPadding);
        }

        [Fact]
        public void TestDecodeInvalidInput()
        {
            // 测试包含不在字母表中的字符
            Assert.Throws<ArgumentException>(() => Hachi64.Decode("包含无效字符X的字符串"));

            // 测试空字符串
            var result = Hachi64.Decode("");
            Assert.Empty(result);
        }

        [Fact]
        public void TestAlphabetCoverage()
        {
            // 验证字母表长度
            Assert.Equal(64, Hachi64.HachiAlphabet.Length);

            // 验证字母表无重复字符
            var uniqueChars = Hachi64.HachiAlphabet.Distinct().Count();
            Assert.Equal(64, uniqueChars);

            // 测试长数据以确保所有字符都可能被使用
            var longData = Enumerable.Range(0, 256).SelectMany(_ => Enumerable.Range(0, 256).Select(i => (byte)i)).ToArray();
            var encoded = Hachi64.Encode(longData);
            var decoded = Hachi64.Decode(encoded);
            
            Assert.Equal(longData, decoded);
        }

        [Fact]
        public void TestEmptyInput()
        {
            var emptyBytes = Array.Empty<byte>();
            var encoded = Hachi64.Encode(emptyBytes);
            var decoded = Hachi64.Decode(encoded);
            
            Assert.Empty(encoded);
            Assert.Empty(decoded);
        }

        [Fact]
        public void TestNullInput()
        {
            Assert.Throws<ArgumentNullException>(() => Hachi64.Encode(null!));
            Assert.Throws<ArgumentNullException>(() => Hachi64.Decode(null!));
        }

        [Theory]
        [InlineData(1)]
        [InlineData(2)]
        [InlineData(3)]
        [InlineData(10)]
        [InlineData(100)]
        [InlineData(1000)]
        public void TestVariousLengths(int length)
        {
            var testData = Enumerable.Range(0, length).Select(i => (byte)(i % 256)).ToArray();
            var encoded = Hachi64.Encode(testData);
            var decoded = Hachi64.Decode(encoded);
            
            Assert.Equal(testData, decoded);
        }

        [Fact]
        public void TestRoundtripWithLongText()
        {
            var testData = Encoding.UTF8.GetBytes("The quick brown fox jumps over the lazy dog. 这是一段中文文本测试。1234567890!@#$%^&*()");
            var encoded = Hachi64.Encode(testData);
            var decoded = Hachi64.Decode(encoded);
            var decodedText = Encoding.UTF8.GetString(decoded);
            
            Assert.Equal(testData, decoded);
            Assert.Equal("The quick brown fox jumps over the lazy dog. 这是一段中文文本测试。1234567890!@#$%^&*()", decodedText);
        }
    }
}
