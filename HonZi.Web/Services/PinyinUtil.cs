using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;

namespace HonZi.Web.Services
{
    public static class PinyinUtil
    {
        private static readonly Dictionary<char, (char baseChar, int tone)> ToneMap = new()
        {
            {'ā', ('a', 1)}, {'á', ('a', 2)}, {'ǎ', ('a', 3)}, {'à', ('a', 4)},
            {'ē', ('e', 1)}, {'é', ('e', 2)}, {'ě', ('e', 3)}, {'è', ('e', 4)},
            {'ī', ('i', 1)}, {'í', ('i', 2)}, {'ǐ', ('i', 3)}, {'ì', ('i', 4)},
            {'ō', ('o', 1)}, {'ó', ('o', 2)}, {'ǒ', ('o', 3)}, {'ò', ('o', 4)},
            {'ū', ('u', 1)}, {'ú', ('u', 2)}, {'ǔ', ('u', 3)}, {'ù', ('u', 4)},
            {'ǖ', ('v', 1)}, {'ǘ', ('v', 2)}, {'ǚ', ('v', 3)}, {'ǜ', ('v', 4)}, {'ü', ('v', 0)}
        };

        /// <summary>
        /// Chuyển đổi Pinyin có dấu thành Pinyin không dấu (ví dụ: "nǐ hǎo" -> "ni hao")
        /// </summary>
        public static string RemoveTones(string pinyin)
        {
            if (string.IsNullOrWhiteSpace(pinyin)) return string.Empty;

            var sb = new StringBuilder();
            foreach (var ch in pinyin)
            {
                if (ToneMap.TryGetValue(ch, out var val))
                {
                    sb.Append(val.baseChar);
                }
                else
                {
                    sb.Append(ch);
                }
            }
            return sb.ToString();
        }

        /// <summary>
        /// Chuẩn hóa chuỗi để so sánh (loại bỏ dấu câu, khoảng trắng thừa, viết thường)
        /// </summary>
        public static string NormalizeText(string text)
        {
            if (string.IsNullOrWhiteSpace(text)) return string.Empty;

            // Loại bỏ dấu câu tiếng Trung và tiếng Anh: ，。！？,.!?、；;：“”"''
            var cleaned = Regex.Replace(text, @"[，。！？,.!?、；;：“”""''\s]+", " ").Trim().ToLowerInvariant();
            return cleaned;
        }

        /// <summary>
        /// Chuẩn hóa chữ Hán (loại bỏ khoảng trắng, dấu câu)
        /// </summary>
        public static string NormalizeHanzi(string hanzi)
        {
            if (string.IsNullOrWhiteSpace(hanzi)) return string.Empty;
            return Regex.Replace(hanzi, @"[，。！？,.!?、；;：“”""''\s]+", "").Trim();
        }

        /// <summary>
        /// So sánh kết quả nghe Pinyin:
        /// 1 = Chính xác tuyệt đối (đúng cả thanh điệu hoặc số thanh điệu)
        /// 2 = Đúng âm nhưng sai/thiếu thanh điệu
        /// 0 = Sai hoàn toàn
        /// </summary>
        public static int EvaluatePinyinMatch(string userInput, string correctPinyin)
        {
            if (string.IsNullOrWhiteSpace(userInput) || string.IsNullOrWhiteSpace(correctPinyin))
                return 0;

            string normUser = NormalizeText(userInput);
            string normCorrect = NormalizeText(correctPinyin);

            // Bỏ dấu cách để đối chiếu linh hoạt (người dùng có thể gõ liền hoặc cách nhau)
            string compactedUser = normUser.Replace(" ", "");
            string compactedCorrect = normCorrect.Replace(" ", "");

            if (compactedUser == compactedCorrect)
            {
                return 1; // Chính xác tuyệt đối
            }

            // Kiểm tra trường hợp nhập không dấu
            string toneFreeUser = RemoveTones(normUser).Replace(" ", "");
            string toneFreeCorrect = RemoveTones(normCorrect).Replace(" ", "");

            if (toneFreeUser == toneFreeCorrect)
            {
                return 2; // Đúng âm nhưng thanh điệu chưa chuẩn
            }

            return 0; // Sai
        }

        /// <summary>
        /// So sánh kết quả chữ Hán
        /// </summary>
        public static bool EvaluateHanziMatch(string userInput, string correctHanzi)
        {
            string cleanUser = NormalizeHanzi(userInput);
            string cleanCorrect = NormalizeHanzi(correctHanzi);

            return string.Equals(cleanUser, cleanCorrect, StringComparison.Ordinal);
        }
    }
}
