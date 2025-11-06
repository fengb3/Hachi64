using System;
using System.Collections.Generic;
using System.Text;

namespace Hachi64
{
    /// <summary>
    /// 哈吉米64 编解码器 - 使用64个中文字符进行 Base64 风格的编码和解码
    /// </summary>
    public class Hachi64
    {
        /// <summary>
        /// 哈吉米64字符集：64个中文字符，按同音字分组
        /// </summary>
        public const string HachiAlphabet = "哈蛤呵吉急集米咪迷南男难北背杯绿律虑豆斗抖啊阿额西希息嘎咖伽花华哗压鸭呀库酷苦奶乃耐龙隆拢曼慢漫波播玻叮丁订咚东冬囊路陆多都弥济";

        private static readonly Lazy<Dictionary<char, int>> _reverseMap = new Lazy<Dictionary<char, int>>(() =>
        {
            var map = new Dictionary<char, int>(64);
            int index = 0;
            foreach (char c in HachiAlphabet)
            {
                map[c] = index++;
            }
            return map;
        });

        private static Dictionary<char, int> ReverseMap => _reverseMap.Value;

        /// <summary>
        /// 使用哈吉米64字符集编码字节数组
        /// </summary>
        /// <param name="data">要编码的字节数组</param>
        /// <param name="padding">是否使用 '=' 进行填充（默认为 true）</param>
        /// <returns>编码后的字符串</returns>
        public static string Encode(byte[] data, bool padding = true)
        {
            if (data == null)
                throw new ArgumentNullException(nameof(data));

            if (data.Length == 0)
                return string.Empty;

            var result = new StringBuilder((data.Length / 3 + 1) * 4);

            for (int i = 0; i < data.Length; i += 3)
            {
                // 获取字节值，不足的用0填充
                byte byte1 = data[i];
                byte byte2 = (i + 1 < data.Length) ? data[i + 1] : (byte)0;
                byte byte3 = (i + 2 < data.Length) ? data[i + 2] : (byte)0;

                int chunkLength = Math.Min(3, data.Length - i);

                // 将24位分成4个6位索引
                int idx1 = byte1 >> 2;
                int idx2 = ((byte1 & 0x03) << 4) | (byte2 >> 4);
                int idx3 = ((byte2 & 0x0F) << 2) | (byte3 >> 6);
                int idx4 = byte3 & 0x3F;

                // 添加前两个字符（总是存在）
                result.Append(HachiAlphabet[idx1]);
                result.Append(HachiAlphabet[idx2]);

                // 处理第三个字符
                if (chunkLength > 1)
                {
                    result.Append(HachiAlphabet[idx3]);
                }
                else if (padding)
                {
                    result.Append('=');
                }

                // 处理第四个字符
                if (chunkLength > 2)
                {
                    result.Append(HachiAlphabet[idx4]);
                }
                else if (padding)
                {
                    result.Append('=');
                }
            }

            return result.ToString();
        }

        /// <summary>
        /// 解码使用哈吉米64字符集编码的字符串
        /// </summary>
        /// <param name="encodedStr">要解码的字符串</param>
        /// <param name="padding">输入字符串是否使用 '=' 进行填充（默认为 true）</param>
        /// <returns>解码后的字节数组</returns>
        /// <exception cref="ArgumentException">输入字符串包含无效字符时抛出</exception>
        public static byte[] Decode(string encodedStr, bool padding = true)
        {
            if (encodedStr == null)
                throw new ArgumentNullException(nameof(encodedStr));

            if (encodedStr.Length == 0)
                return Array.Empty<byte>();

            // 处理填充
            int padCount = 0;
            if (padding)
            {
                for (int i = encodedStr.Length - 1; i >= 0 && encodedStr[i] == '='; i--)
                {
                    padCount++;
                }

                if (padCount > 0)
                {
                    encodedStr = encodedStr.Substring(0, encodedStr.Length - padCount);
                }
            }

            var result = new List<byte>((encodedStr.Length * 3) / 4);
            var reverseMap = ReverseMap;

            // 按每4个字符为一组进行处理
            for (int i = 0; i < encodedStr.Length; i += 4)
            {
                int chunkLength = Math.Min(4, encodedStr.Length - i);

                // 获取索引值
                if (!reverseMap.TryGetValue(encodedStr[i], out int idx1))
                    throw new ArgumentException($"Invalid character in input: {encodedStr[i]}");

                int idx2 = 0, idx3 = 0, idx4 = 0;

                if (chunkLength > 1)
                {
                    if (!reverseMap.TryGetValue(encodedStr[i + 1], out idx2))
                        throw new ArgumentException($"Invalid character in input: {encodedStr[i + 1]}");
                }

                if (chunkLength > 2)
                {
                    if (!reverseMap.TryGetValue(encodedStr[i + 2], out idx3))
                        throw new ArgumentException($"Invalid character in input: {encodedStr[i + 2]}");
                }

                if (chunkLength > 3)
                {
                    if (!reverseMap.TryGetValue(encodedStr[i + 3], out idx4))
                        throw new ArgumentException($"Invalid character in input: {encodedStr[i + 3]}");
                }

                // 将4个6位索引重组为3个字节
                byte byte1 = (byte)((idx1 << 2) | (idx2 >> 4));
                result.Add(byte1);

                if (chunkLength > 2)
                {
                    byte byte2 = (byte)(((idx2 & 0x0F) << 4) | (idx3 >> 2));
                    result.Add(byte2);
                }

                if (chunkLength > 3)
                {
                    byte byte3 = (byte)(((idx3 & 0x03) << 6) | idx4);
                    result.Add(byte3);
                }
            }

            return result.ToArray();
        }
    }
}
