using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using HonZi.Web.Models;

namespace HonZi.Web.Services
{
    public class SrsReviewInfo
    {
        public int WordId { get; set; }
        public string Status { get; set; } = "Learning";
        public int IntervalDays { get; set; }
        public DateTime NextReviewAt { get; set; }
        public int LeitnerBox { get; set; } // 1: 1 ngày, 2: 3 ngày, 3: 7 ngày, 4: 14 ngày, 5: 30 ngày (Mastered)
        public string Message { get; set; } = string.Empty;
    }

    public interface ISpacedRepetitionService
    {
        /// <summary>
        /// Tính toán khoảng cách lặp lại ngắt quãng (SRS) theo thuật toán Leitner / SM-2 cải tiến
        /// </summary>
        SrsReviewInfo CalculateNextReview(int correctCount, int wrongCount, bool isCorrectThisTime);

        /// <summary>
        /// Lấy danh sách từ vựng đã đến hạn ôn tập hôm nay (NextReviewAt <= Now)
        /// </summary>
        Task<List<UserProgress>> GetDueWordsAsync(int userId, int? hskLevel = null, int limit = 30);

        /// <summary>
        /// Đếm số lượng từ cần ôn tập hôm nay của học viên
        /// </summary>
        Task<int> GetDueWordsCountAsync(int userId, int? hskLevel = null);

        /// <summary>
        /// Sinh danh sách từ học tập thích ứng (Adaptive Learning Queue):
        /// Ưu tiên 1: Từ đến hạn ôn tập (Due)
        /// Ưu tiên 2: Từ hay sai (High Error)
        /// Ưu tiên 3: Từ mới chưa học
        /// </summary>
        Task<List<Word>> GetAdaptiveQueueAsync(int userId, int hskLevel, int count = 10);
    }
}
