using System.Collections.Generic;
using HonZi.Web.Models;
using HonZi.Web.Services;

namespace HonZi.Web.Models.ViewModels
{
    public class ProgressDashboardViewModel
    {
        public UserProgressStats Stats { get; set; } = new();
        public int DueWordsCount { get; set; } = 0;
        public List<UserProgress> DueWords { get; set; } = new();
        public List<UserProgress> NeedsReviewWords { get; set; } = new();
        public List<QuizResult> RecentQuizzes { get; set; } = new();
        public List<ListeningResult> RecentListenings { get; set; } = new();
    }

    public class AdminUsersViewModel
    {
        public List<User> Users { get; set; } = new();
        public int TotalUsers => Users.Count;
        public int AdminCount { get; set; }
        public int TotalWords { get; set; }
        public int TotalQuizCount { get; set; }
        public int TotalListeningCount { get; set; }
    }

    public class AdminUserDetailViewModel
    {
        public User User { get; set; } = null!;
        public UserProgressStats Stats { get; set; } = new();
        public List<QuizResult> Quizzes { get; set; } = new();
        public List<ListeningResult> Listenings { get; set; } = new();
    }
}
