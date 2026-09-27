using System.Collections.Generic;
using System.Threading.Tasks;
using HonZi.Web.Models;

namespace HonZi.Web.Services
{
    public class UserProgressStats
    {
        public int TotalWords { get; set; }
        public int MasteredCount { get; set; }
        public int LearningCount { get; set; }
        public int NewCount { get; set; }
        public double MasteredPercentage => TotalWords > 0 ? (double)MasteredCount / TotalWords * 100 : 0;
        public Dictionary<int, (int Mastered, int Total)> HskProgress { get; set; } = new();
        public int TotalQuizzesTaken { get; set; }
        public double AverageQuizScore { get; set; }
        public int TotalListeningTaken { get; set; }
        public double AverageListeningAccuracy { get; set; }
    }

    public interface IProgressService
    {
        Task<bool> UpdateProgressAsync(int userId, int wordId, bool isCorrect);
        Task<bool> ResetProgressByHskAsync(int userId, int hskLevel);
        Task<UserProgressStats> GetUserStatsAsync(int userId);
        Task<List<UserProgress>> GetWordsNeedingReviewAsync(int userId, int limit = 20);
        Task<List<UserProgress>> GetUserProgressListAsync(int userId, int? hskLevel);
    }
}
