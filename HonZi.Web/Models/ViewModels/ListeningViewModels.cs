using System.Collections.Generic;
using HonZi.Web.Services;

namespace HonZi.Web.Models.ViewModels
{
    public class ListeningIndexViewModel
    {
        public int DefaultHskLevel { get; set; } = 1;
        public string DefaultExerciseType { get; set; } = "Word"; // "Word" | "Sentence"
        public string DefaultInputMode { get; set; } = "Hanzi"; // "Hanzi" | "Pinyin"
        public List<ListeningResult> RecentHistory { get; set; } = new();
    }

    public class ListeningPracticeViewModel
    {
        public string SessionId { get; set; } = string.Empty;
        public int HskLevel { get; set; }
        public string ExerciseType { get; set; } = "Word";
        public string InputMode { get; set; } = "Hanzi";
        public int CurrentIndex { get; set; }
        public int TotalQuestions { get; set; }
        public ListeningQuestion CurrentQuestion { get; set; } = new();
        public int CurrentScore { get; set; }
    }

    public class ListeningAnswerSubmitModel
    {
        public string SessionId { get; set; } = string.Empty;
        public int QuestionIndex { get; set; }
        public string UserAnswer { get; set; } = string.Empty;
    }

    public class ListeningResultViewModel
    {
        public int HskLevel { get; set; }
        public string ExerciseType { get; set; } = "Word";
        public string InputMode { get; set; } = "Hanzi";
        public int Score { get; set; }
        public int TotalQuestions { get; set; }
        public double AccuracyPercentage { get; set; }
        public List<ListeningQuestion> Questions { get; set; } = new();
    }
}
