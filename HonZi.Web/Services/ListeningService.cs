using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using HonZi.Web.Data;
using HonZi.Web.Models;

namespace HonZi.Web.Services
{
    public class ListeningService : IListeningService
    {
        private readonly HanziGoDbContext _context;
        private readonly ISpacedRepetitionService _srsService;

        public ListeningService(HanziGoDbContext context, ISpacedRepetitionService srsService)
        {
            _context = context;
            _srsService = srsService;
        }

        public async Task<ListeningSession> CreateSessionAsync(int hskLevel, string exerciseType, string inputMode, int count = 10, int? userId = null)
        {
            exerciseType = exerciseType.Equals("Sentence", StringComparison.OrdinalIgnoreCase) ? "Sentence" : "Word";
            inputMode = inputMode.Equals("Pinyin", StringComparison.OrdinalIgnoreCase) ? "Pinyin" : "Hanzi";

            List<Word> words;
            if (userId.HasValue && userId.Value > 0)
            {
                // Sử dụng thuật toán thích ứng thông minh (SRS) ưu tiên từ đến hạn ôn tập và từ hay sai
                words = await _srsService.GetAdaptiveQueueAsync(userId.Value, hskLevel, count);
            }
            else
            {
                var query = _context.Words.AsNoTracking().Where(w => w.HskLevel == hskLevel);

                if (exerciseType == "Sentence")
                {
                    query = query.Where(w => !string.IsNullOrEmpty(w.ExampleSentence));
                }

                words = await query.OrderBy(w => Guid.NewGuid()).Take(count).ToListAsync();
            }

            if (words.Count < count && exerciseType == "Sentence")
            {
                var extraWords = await _context.Words
                    .AsNoTracking()
                    .Where(w => !string.IsNullOrEmpty(w.ExampleSentence) && w.HskLevel != hskLevel)
                    .OrderBy(w => Guid.NewGuid())
                    .Take(count - words.Count)
                    .ToListAsync();
                words.AddRange(extraWords);
            }

            if (!words.Any())
            {
                words = await _context.Words.AsNoTracking().OrderBy(w => Guid.NewGuid()).Take(count).ToListAsync();
            }

            var session = new ListeningSession
            {
                HskLevel = hskLevel,
                ExerciseType = exerciseType,
                InputMode = inputMode
            };

            foreach (var w in words)
            {
                string audioText;
                string targetHanzi;
                string targetPinyin;
                string meaning;

                if (exerciseType == "Sentence" && !string.IsNullOrWhiteSpace(w.ExampleSentence))
                {
                    audioText = w.ExampleSentence;
                    targetHanzi = w.ExampleSentence;
                    targetPinyin = w.Pinyin; // fallback
                    meaning = !string.IsNullOrWhiteSpace(w.ExampleMeaningVi) ? w.ExampleMeaningVi : w.MeaningVi;
                }
                else
                {
                    audioText = w.Hanzi;
                    targetHanzi = w.Hanzi;
                    targetPinyin = w.Pinyin;
                    meaning = w.MeaningVi;
                }

                session.Questions.Add(new ListeningQuestion
                {
                    WordId = w.WordId,
                    AudioText = audioText,
                    AudioUrl = w.AudioUrl,
                    TargetHanzi = targetHanzi,
                    TargetPinyin = targetPinyin,
                    Meaning = meaning,
                    ExerciseType = exerciseType,
                    InputMode = inputMode
                });
            }

            return session;
        }

        public ListeningQuestion EvaluateQuestion(ListeningQuestion question, string userInput)
        {
            question.UserAnswer = userInput?.Trim() ?? string.Empty;
            question.IsEvaluated = true;
            question.DiffTokens.Clear();

            if (question.InputMode == "Hanzi")
            {
                EvaluateHanziQuestion(question);
            }
            else
            {
                EvaluatePinyinQuestion(question);
            }

            return question;
        }

        private void EvaluateHanziQuestion(ListeningQuestion question)
        {
            string cleanTarget = PinyinUtil.NormalizeHanzi(question.TargetHanzi);
            string cleanUser = PinyinUtil.NormalizeHanzi(question.UserAnswer ?? "");

            bool isMatch = string.Equals(cleanTarget, cleanUser, StringComparison.Ordinal);
            question.IsCorrect = isMatch;

            // Xây dựng diff tokens từng ký tự
            int maxLen = Math.Max(cleanTarget.Length, cleanUser.Length);
            for (int i = 0; i < maxLen; i++)
            {
                if (i < cleanTarget.Length && i < cleanUser.Length)
                {
                    if (cleanTarget[i] == cleanUser[i])
                    {
                        question.DiffTokens.Add(new DiffToken { Text = cleanTarget[i].ToString(), Status = "match" });
                    }
                    else
                    {
                        question.DiffTokens.Add(new DiffToken { Text = cleanUser[i].ToString(), Status = "mismatch" });
                    }
                }
                else if (i < cleanTarget.Length)
                {
                    // Người học gõ thiếu ký tự này
                    question.DiffTokens.Add(new DiffToken { Text = cleanTarget[i].ToString(), Status = "missing" });
                }
                else
                {
                    // Người học gõ thừa ký tự
                    question.DiffTokens.Add(new DiffToken { Text = cleanUser[i].ToString(), Status = "mismatch" });
                }
            }

            if (isMatch)
            {
                question.FeedbackMessage = "Xuất sắc! Bạn nghe và gõ chính xác 100% chữ Hán! 🎉";
            }
            else
            {
                question.FeedbackMessage = $"Chưa chính xác. Đáp án đúng là: {question.TargetHanzi} ({question.TargetPinyin})";
            }
        }

        private void EvaluatePinyinQuestion(ListeningQuestion question)
        {
            int matchResult = PinyinUtil.EvaluatePinyinMatch(question.UserAnswer ?? "", question.TargetPinyin);

            if (matchResult == 1)
            {
                question.IsCorrect = true;
                question.IsPartialToneOnly = false;
                question.FeedbackMessage = "Chính xác tuyệt đối cả âm và thanh điệu! 🎉";
                question.DiffTokens.Add(new DiffToken { Text = question.UserAnswer ?? "", Status = "match" });
            }
            else if (matchResult == 2)
            {
                question.IsCorrect = true; // Chấp nhận đúng âm
                question.IsPartialToneOnly = true;
                question.FeedbackMessage = $"Đúng phiên âm nhưng chưa chuẩn thanh điệu! Thanh điệu chuẩn: {question.TargetPinyin}";
                question.DiffTokens.Add(new DiffToken { Text = question.UserAnswer ?? "", Status = "match" });
            }
            else
            {
                question.IsCorrect = false;
                question.FeedbackMessage = $"Chưa chính xác. Đáp án đúng là: {question.TargetPinyin} ({question.TargetHanzi})";
                question.DiffTokens.Add(new DiffToken { Text = question.UserAnswer ?? "", Status = "mismatch" });
            }
        }

        public async Task<ListeningResult> SaveResultAsync(int userId, int hskLevel, string exerciseType, string inputMode, int score, int totalQuestions)
        {
            double accuracy = totalQuestions > 0 ? Math.Round((double)score / totalQuestions * 100, 1) : 0;

            var result = new ListeningResult
            {
                UserId = userId,
                HskLevel = hskLevel,
                ExerciseType = exerciseType,
                InputMode = inputMode,
                Score = score,
                TotalQuestions = totalQuestions,
                AccuracyPercentage = accuracy,
                TakenAt = DateTime.Now
            };

            _context.ListeningResults.Add(result);
            await _context.SaveChangesAsync();
            return result;
        }

        public async Task<List<ListeningResult>> GetUserListeningHistoryAsync(int userId, int limit = 10)
        {
            return await _context.ListeningResults
                .Where(l => l.UserId == userId)
                .OrderByDescending(l => l.TakenAt)
                .Take(limit)
                .ToListAsync();
        }
    }
}
