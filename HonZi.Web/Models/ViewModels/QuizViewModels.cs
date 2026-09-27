using System.Collections.Generic;
using HonZi.Web.Services;

namespace HonZi.Web.Models.ViewModels
{
    public class QuizViewModel
    {
        public int HskLevel { get; set; } = 1;
        public List<QuizQuestionModel> Questions { get; set; } = new();
    }

    public class QuizSubmitViewModel
    {
        public int HskLevel { get; set; }
        public Dictionary<int, string> Answers { get; set; } = new();
    }

    public class QuizResultViewModel
    {
        public int HskLevel { get; set; }
        public int Score { get; set; }
        public int TotalQuestions { get; set; }
        public double Percentage => TotalQuestions > 0 ? (double)Score / TotalQuestions * 100 : 0;
        public List<QuizQuestionModel> Questions { get; set; } = new();
    }
}
