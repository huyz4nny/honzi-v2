using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using HonZi.Web.Data;
using HonZi.Web.Models;

namespace HonZi.Web.Services
{
    public class QuizService : IQuizService
    {
        private readonly HanziGoDbContext _context;

        public QuizService(HanziGoDbContext context)
        {
            _context = context;
        }

        public async Task<QuizSessionModel> GenerateQuizAsync(int hskLevel, int count = 10)
        {
            var words = await _context.Words
                .Where(w => w.HskLevel == hskLevel)
                .OrderBy(w => Guid.NewGuid())
                .Take(count)
                .ToListAsync();

            if (!words.Any())
            {
                // Fallback nếu cấp HSK đó chưa đủ từ
                words = await _context.Words
                    .OrderBy(w => Guid.NewGuid())
                    .Take(count)
                    .ToListAsync();
            }

            var allMeanings = await _context.Words
                .Select(w => w.MeaningVi)
                .Distinct()
                .ToListAsync();

            var session = new QuizSessionModel
            {
                HskLevel = hskLevel
            };

            var rng = new Random();

            foreach (var w in words)
            {
                var distractors = allMeanings
                    .Where(m => m != w.MeaningVi)
                    .OrderBy(_ => rng.Next())
                    .Take(3)
                    .ToList();

                var options = new List<string> { w.MeaningVi };
                options.AddRange(distractors);

                // Trộn thứ tự đáp án A, B, C, D
                options = options.OrderBy(_ => rng.Next()).ToList();

                session.Questions.Add(new QuizQuestionModel
                {
                    WordId = w.WordId,
                    Hanzi = w.Hanzi,
                    Pinyin = w.Pinyin,
                    CorrectMeaning = w.MeaningVi,
                    Options = options
                });
            }

            return session;
        }

        public async Task<QuizResult> SaveQuizResultAsync(int userId, int hskLevel, int score, int totalQuestions)
        {
            var result = new QuizResult
            {
                UserId = userId,
                HskLevel = hskLevel,
                Score = score,
                TotalQuestions = totalQuestions,
                TakenAt = DateTime.Now
            };

            _context.QuizResults.Add(result);
            await _context.SaveChangesAsync();
            return result;
        }

        public async Task<List<QuizResult>> GetUserQuizHistoryAsync(int userId, int limit = 10)
        {
            return await _context.QuizResults
                .Where(q => q.UserId == userId)
                .OrderByDescending(q => q.TakenAt)
                .Take(limit)
                .ToListAsync();
        }
    }
}
