using System.Collections.Generic;
using System.Security.Claims;
using System.Text.Json;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using HonZi.Web.Models.ViewModels;
using HonZi.Web.Services;

namespace HonZi.Web.Controllers
{
    [Authorize]
    public class QuizController : Controller
    {
        private readonly IQuizService _quizService;

        public QuizController(IQuizService quizService)
        {
            _quizService = quizService;
        }

        [HttpGet]
        public async Task<IActionResult> Index(int hskLevel = 1)
        {
            if (hskLevel < 1 || hskLevel > 6) hskLevel = 1;

            var quizSession = await _quizService.GenerateQuizAsync(hskLevel, 10);

            // Lưu session câu hỏi
            HttpContext.Session.SetString("CurrentQuiz", JsonSerializer.Serialize(quizSession));

            var viewModel = new QuizViewModel
            {
                HskLevel = hskLevel,
                Questions = quizSession.Questions
            };

            return View(viewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Submit(int hskLevel, IFormCollection form)
        {
            var sessionJson = HttpContext.Session.GetString("CurrentQuiz");
            if (string.IsNullOrEmpty(sessionJson))
            {
                return RedirectToAction(nameof(Index), new { hskLevel = hskLevel });
            }

            var quizSession = JsonSerializer.Deserialize<QuizSessionModel>(sessionJson);
            if (quizSession == null)
            {
                return RedirectToAction(nameof(Index), new { hskLevel = hskLevel });
            }

            // Đọc câu trả lời từ form
            int score = 0;
            for (int i = 0; i < quizSession.Questions.Count; i++)
            {
                var q = quizSession.Questions[i];
                var answer = form[$"question_{q.WordId}"].ToString();
                q.UserAnswer = answer;
                if (q.IsCorrect)
                {
                    score++;
                }
            }

            // Lưu kết quả vào database nếu đã đăng nhập
            if (User.Identity?.IsAuthenticated == true)
            {
                var userIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
                if (int.TryParse(userIdStr, out int userId))
                {
                    await _quizService.SaveQuizResultAsync(userId, hskLevel, score, quizSession.TotalQuestions);
                }
            }

            var resultModel = new QuizResultViewModel
            {
                HskLevel = hskLevel,
                Score = score,
                TotalQuestions = quizSession.TotalQuestions,
                Questions = quizSession.Questions
            };

            return View("Result", resultModel);
        }
    }
}
