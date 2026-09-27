using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using HonZi.Web.Data;
using HonZi.Web.Models;

namespace HonZi.Web.Services
{
    public class ProgressService : IProgressService
    {
        private readonly HanziGoDbContext _context;

        private readonly ISpacedRepetitionService _srsService;

        public ProgressService(HanziGoDbContext context, ISpacedRepetitionService srsService)
        {
            _context = context;
            _srsService = srsService;
        }

        public async Task<bool> UpdateProgressAsync(int userId, int wordId, bool isCorrect)
        {
            var progress = await _context.UserProgresses
                .FirstOrDefaultAsync(up => up.UserId == userId && up.WordId == wordId);

            int currentCorrect = progress?.CorrectCount ?? 0;
            int currentWrong = progress?.WrongCount ?? 0;
            var srs = _srsService.CalculateNextReview(currentCorrect, currentWrong, isCorrect);

            if (progress != null)
            {
                if (isCorrect)
                {
                    progress.CorrectCount++;
                }
                else
                {
                    progress.WrongCount++;
                }
                progress.Status = srs.Status;
                progress.NextReviewAt = srs.NextReviewAt;
                progress.LastReviewedAt = DateTime.Now;
            }
            else
            {
                progress = new UserProgress
                {
                    UserId = userId,
                    WordId = wordId,
                    CorrectCount = isCorrect ? 1 : 0,
                    WrongCount = isCorrect ? 0 : 1,
                    Status = srs.Status,
                    NextReviewAt = srs.NextReviewAt,
                    LastReviewedAt = DateTime.Now
                };
                _context.UserProgresses.Add(progress);
            }

            return await _context.SaveChangesAsync() > 0;
        }

        public async Task<bool> ResetProgressByHskAsync(int userId, int hskLevel)
        {
            var records = await _context.UserProgresses
                .Where(up => up.UserId == userId && up.Word.HskLevel == hskLevel)
                .ToListAsync();

            if (records.Any())
            {
                _context.UserProgresses.RemoveRange(records);
                return await _context.SaveChangesAsync() > 0;
            }
            return true;
        }

        public async Task<UserProgressStats> GetUserStatsAsync(int userId)
        {
            var totalWords = await _context.Words.CountAsync();
            var progresses = await _context.UserProgresses
                .Include(up => up.Word)
                .Where(up => up.UserId == userId)
                .ToListAsync();

            int mastered = progresses.Count(p => p.Status == "Mastered");
            int learning = progresses.Count(p => p.Status == "Learning");
            int newCount = totalWords - (mastered + learning);
            if (newCount < 0) newCount = 0;

            var stats = new UserProgressStats
            {
                TotalWords = totalWords,
                MasteredCount = mastered,
                LearningCount = learning,
                NewCount = newCount
            };

            // Hsk progress breakdown
            for (int hsk = 1; hsk <= 6; hsk++)
            {
                int hskTotal = await _context.Words.CountAsync(w => w.HskLevel == hsk);
                int hskMastered = progresses.Count(p => p.Word.HskLevel == hsk && p.Status == "Mastered");
                stats.HskProgress[hsk] = (hskMastered, hskTotal);
            }

            // Quizzes
            var quizzes = await _context.QuizResults.Where(q => q.UserId == userId).ToListAsync();
            stats.TotalQuizzesTaken = quizzes.Count;
            stats.AverageQuizScore = quizzes.Any() ? quizzes.Average(q => (double)q.Score / q.TotalQuestions * 10) : 0;

            // Listening
            var listenings = await _context.ListeningResults.Where(l => l.UserId == userId).ToListAsync();
            stats.TotalListeningTaken = listenings.Count;
            stats.AverageListeningAccuracy = listenings.Any() ? listenings.Average(l => l.AccuracyPercentage) : 0;

            return stats;
        }

        public async Task<List<UserProgress>> GetWordsNeedingReviewAsync(int userId, int limit = 20)
        {
            return await _context.UserProgresses
                .Include(up => up.Word)
                .Where(up => up.UserId == userId && up.Status == "Learning")
                .OrderByDescending(up => up.WrongCount)
                .ThenBy(up => up.LastReviewedAt)
                .Take(limit)
                .ToListAsync();
        }

        public async Task<List<UserProgress>> GetUserProgressListAsync(int userId, int? hskLevel)
        {
            var query = _context.UserProgresses
                .Include(up => up.Word)
                .Where(up => up.UserId == userId);

            if (hskLevel.HasValue && hskLevel.Value >= 1 && hskLevel.Value <= 6)
            {
                query = query.Where(up => up.Word.HskLevel == hskLevel.Value);
            }

            return await query.OrderByDescending(up => up.LastReviewedAt).ToListAsync();
        }
    }
}
