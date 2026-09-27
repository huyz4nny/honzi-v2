using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using HonZi.Web.Models;

namespace HonZi.Web.Services
{
    public class QuizQuestionModel
    {
        public int WordId { get; set; }
        public string Hanzi { get; set; } = string.Empty;
        public string Pinyin { get; set; } = string.Empty;
        public string CorrectMeaning { get; set; } = string.Empty;
        public List<string> Options { get; set; } = new();
        public string? UserAnswer { get; set; }
        public bool IsCorrect => string.Equals(UserAnswer?.Trim(), CorrectMeaning.Trim(), StringComparison.OrdinalIgnoreCase);
    }

    public class QuizSessionModel
    {
        public int HskLevel { get; set; }
        public List<QuizQuestionModel> Questions { get; set; } = new();
        public int TotalQuestions => Questions.Count;
        public int Score => Questions.Count(q => q.IsCorrect);
        public double Percentage => TotalQuestions > 0 ? (double)Score / TotalQuestions * 100 : 0;
    }

    public interface IQuizService
    {
        Task<QuizSessionModel> GenerateQuizAsync(int hskLevel, int count = 10);
        Task<QuizResult> SaveQuizResultAsync(int userId, int hskLevel, int score, int totalQuestions);
        Task<List<QuizResult>> GetUserQuizHistoryAsync(int userId, int limit = 10);
    }
}
