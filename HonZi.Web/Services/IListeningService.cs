using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using HonZi.Web.Models;

namespace HonZi.Web.Services
{
    public class DiffToken
    {
        public string Text { get; set; } = string.Empty;
        public string Status { get; set; } = "match"; // "match", "mismatch", "missing"
    }

    public class ListeningQuestion
    {
        public int WordId { get; set; }
        public string AudioText { get; set; } = string.Empty;
        public string? AudioUrl { get; set; }
        public string TargetHanzi { get; set; } = string.Empty;
        public string TargetPinyin { get; set; } = string.Empty;
        public string Meaning { get; set; } = string.Empty;
        public string ExerciseType { get; set; } = "Word"; // "Word" hoặc "Sentence"
        public string InputMode { get; set; } = "Hanzi"; // "Hanzi" hoặc "Pinyin"
        public string? UserAnswer { get; set; }
        public bool IsEvaluated { get; set; } = false;
        public bool IsCorrect { get; set; } = false;
        public bool IsPartialToneOnly { get; set; } = false;
        public string FeedbackMessage { get; set; } = string.Empty;
        public List<DiffToken> DiffTokens { get; set; } = new();
    }

    public class ListeningSession
    {
        public string SessionId { get; set; } = Guid.NewGuid().ToString();
        public int HskLevel { get; set; } = 1;
        public string ExerciseType { get; set; } = "Word"; // "Word" | "Sentence"
        public string InputMode { get; set; } = "Hanzi"; // "Hanzi" | "Pinyin"
        public List<ListeningQuestion> Questions { get; set; } = new();
        public int CurrentIndex { get; set; } = 0;
        public int TotalQuestions => Questions.Count;
        public int Score => Questions.Count(q => q.IsCorrect);
        public double AccuracyPercentage => TotalQuestions > 0 ? Math.Round((double)Score / TotalQuestions * 100, 1) : 0;
        public bool IsFinished => Questions.Count > 0 && Questions.All(q => q.IsEvaluated);
    }

    public interface IListeningService
    {
        Task<ListeningSession> CreateSessionAsync(int hskLevel, string exerciseType, string inputMode, int count = 10, int? userId = null);
        ListeningQuestion EvaluateQuestion(ListeningQuestion question, string userInput);
        Task<ListeningResult> SaveResultAsync(int userId, int hskLevel, string exerciseType, string inputMode, int score, int totalQuestions);
        Task<List<ListeningResult>> GetUserListeningHistoryAsync(int userId, int limit = 10);
    }
}
