using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using HonZi.Web.Data;
using HonZi.Web.Models;

namespace HonZi.Web.Services
{
    public class SpacedRepetitionService : ISpacedRepetitionService
    {
        private readonly HanziGoDbContext _context;

        public SpacedRepetitionService(HanziGoDbContext context)
        {
            _context = context;
        }

        public SrsReviewInfo CalculateNextReview(int correctCount, int wrongCount, bool isCorrectThisTime)
        {
            var now = DateTime.Now;

            if (!isCorrectThisTime)
            {
                return new SrsReviewInfo
                {
                    Status = "Learning",
                    IntervalDays = 0,
                    NextReviewAt = now.AddHours(12),
                    LeitnerBox = 1,
                    Message = "Chưa thuộc, hệ thống sẽ nhắc bạn ôn lại sau 12 giờ!"
                };
            }

            int streak = correctCount + 1;
            int intervalDays;
            int box;
            string status = "Learning";
            string msg;

            switch (streak)
            {
                case 1:
                    intervalDays = 1;
                    box = 1;
                    msg = "Đã ghi nhớ lần đầu! Ôn lại vào ngày mai (Hộp 1).";
                    break;
                case 2:
                    intervalDays = 3;
                    box = 2;
                    msg = "Tiến bộ tốt! Ôn lại sau 3 ngày (Hộp 2).";
                    break;
                case 3:
                    intervalDays = 7;
                    box = 3;
                    msg = "Ghi nhớ vững chắc! Ôn lại sau 7 ngày (Hộp 3).";
                    break;
                case 4:
                    intervalDays = 14;
                    box = 4;
                    msg = "Rất xuất sắc! Ôn lại sau 14 ngày (Hộp 4).";
                    break;
                default: // >= 5
                    intervalDays = 30;
                    box = 5;
                    status = "Mastered";
                    msg = "Đã làm chủ hoàn toàn! Hệ thống xếp vào Hộp 5 (Ôn lại sau 30 ngày).";
                    break;
            }

            return new SrsReviewInfo
            {
                Status = status,
                IntervalDays = intervalDays,
                NextReviewAt = now.AddDays(intervalDays),
                LeitnerBox = box,
                Message = msg
            };
        }

        public async Task<List<UserProgress>> GetDueWordsAsync(int userId, int? hskLevel = null, int limit = 30)
        {
            var now = DateTime.Now;
            var query = _context.UserProgresses
                .Include(up => up.Word)
                .Where(up => up.UserId == userId && (up.NextReviewAt == null || up.NextReviewAt <= now));

            if (hskLevel.HasValue && hskLevel.Value >= 1 && hskLevel.Value <= 6)
            {
                query = query.Where(up => up.Word.HskLevel == hskLevel.Value);
            }

            return await query
                .OrderBy(up => up.NextReviewAt)
                .ThenByDescending(up => up.WrongCount)
                .Take(limit)
                .ToListAsync();
        }

        public async Task<int> GetDueWordsCountAsync(int userId, int? hskLevel = null)
        {
            var now = DateTime.Now;
            var query = _context.UserProgresses
                .Where(up => up.UserId == userId && (up.NextReviewAt == null || up.NextReviewAt <= now));

            if (hskLevel.HasValue && hskLevel.Value >= 1 && hskLevel.Value <= 6)
            {
                query = query.Where(up => up.Word.HskLevel == hskLevel.Value);
            }

            return await query.CountAsync();
        }

        public async Task<List<Word>> GetAdaptiveQueueAsync(int userId, int hskLevel, int count = 10)
        {
            var now = DateTime.Now;

            // 1. Lấy tiến độ của user ở HSK level này
            var userProgresses = await _context.UserProgresses
                .Include(up => up.Word)
                .Where(up => up.UserId == userId && up.Word.HskLevel == hskLevel)
                .ToListAsync();

            var resultWords = new List<Word>();

            // Ưu tiên 1: Các từ đến hạn ôn tập theo SRS
            var dueWords = userProgresses
                .Where(up => up.NextReviewAt == null || up.NextReviewAt <= now)
                .OrderBy(up => up.NextReviewAt)
                .Select(up => up.Word)
                .ToList();

            resultWords.AddRange(dueWords.Take(count));

            // Ưu tiên 2: Nếu chưa đủ, bổ sung các từ hay sai (WrongCount > CorrectCount)
            if (resultWords.Count < count)
            {
                var hardWords = userProgresses
                    .Where(up => up.WrongCount > up.CorrectCount && !resultWords.Any(rw => rw.WordId == up.WordId))
                    .OrderByDescending(up => up.WrongCount)
                    .Select(up => up.Word)
                    .ToList();

                resultWords.AddRange(hardWords.Take(count - resultWords.Count));
            }

            // Ưu tiên 3: Nếu chưa đủ, lấy các từ mới chưa từng học trong cấp HSK này
            if (resultWords.Count < count)
            {
                var studiedIds = userProgresses.Select(up => up.WordId).ToHashSet();
                var newWords = await _context.Words
                    .Where(w => w.HskLevel == hskLevel && !studiedIds.Contains(w.WordId))
                    .OrderBy(w => w.WordId)
                    .Take(count - resultWords.Count)
                    .ToListAsync();

                resultWords.AddRange(newWords);
            }

            // Ưu tiên 4: Nếu vẫn chưa đủ, lấy ngẫu nhiên các từ còn lại trong cấp HSK
            if (resultWords.Count < count)
            {
                var currentIds = resultWords.Select(w => w.WordId).ToHashSet();
                var remaining = await _context.Words
                    .Where(w => w.HskLevel == hskLevel && !currentIds.Contains(w.WordId))
                    .OrderBy(w => Guid.NewGuid())
                    .Take(count - resultWords.Count)
                    .ToListAsync();

                resultWords.AddRange(remaining);
            }

            return resultWords;
        }
    }
}
