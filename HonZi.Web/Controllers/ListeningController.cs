using System;
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
    public class ListeningController : Controller
    {
        private readonly IListeningService _listeningService;
        private readonly IProgressService _progressService;

        private const string SessionKey = "ListeningSessionData";

        public ListeningController(IListeningService listeningService, IProgressService progressService)
        {
            _listeningService = listeningService;
            _progressService = progressService;
        }

        [HttpGet]
        public async Task<IActionResult> Index(int hskLevel = 1)
        {
            if (hskLevel < 1 || hskLevel > 6) hskLevel = 1;

            var model = new ListeningIndexViewModel
            {
                DefaultHskLevel = hskLevel,
                DefaultExerciseType = "Word",
                DefaultInputMode = "Hanzi"
            };

            if (User.Identity?.IsAuthenticated == true)
            {
                var userIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
                if (int.TryParse(userIdStr, out int userId))
                {
                    model.RecentHistory = await _listeningService.GetUserListeningHistoryAsync(userId, 5);
                }
            }

            return View(model);
        }

        [HttpGet]
        public IActionResult Start()
        {
            return RedirectToAction(nameof(Index));
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Start(int hskLevel, string exerciseType = "Word", string inputMode = "Hanzi")
        {
            if (hskLevel < 1 || hskLevel > 6) hskLevel = 1;

            int? userId = null;
            if (User.Identity?.IsAuthenticated == true)
            {
                var userIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
                if (int.TryParse(userIdStr, out int uid))
                {
                    userId = uid;
                }
            }

            var session = await _listeningService.CreateSessionAsync(hskLevel, exerciseType, inputMode, 10, userId);
            HttpContext.Session.SetString(SessionKey, JsonSerializer.Serialize(session));

            return RedirectToAction(nameof(Practice), new { index = 0 });
        }

        [HttpGet]
        public IActionResult Practice(int index = 0)
        {
            var sessionJson = HttpContext.Session.GetString(SessionKey);
            if (string.IsNullOrEmpty(sessionJson))
            {
                return RedirectToAction(nameof(Index));
            }

            var session = JsonSerializer.Deserialize<ListeningSession>(sessionJson);
            if (session == null || session.Questions.Count == 0)
            {
                return RedirectToAction(nameof(Index));
            }

            if (index < 0) index = 0;
            if (index >= session.Questions.Count)
            {
                return RedirectToAction(nameof(Result));
            }

            session.CurrentIndex = index;
            HttpContext.Session.SetString(SessionKey, JsonSerializer.Serialize(session));

            var currentQ = session.Questions[index];

            var model = new ListeningPracticeViewModel
            {
                SessionId = session.SessionId,
                HskLevel = session.HskLevel,
                ExerciseType = session.ExerciseType,
                InputMode = session.InputMode,
                CurrentIndex = index,
                TotalQuestions = session.TotalQuestions,
                CurrentQuestion = currentQ,
                CurrentScore = session.Score
            };

            return View(model);
        }

        [HttpPost]
        public async Task<IActionResult> CheckAnswer([FromBody] ListeningAnswerSubmitModel model)
        {
            var sessionJson = HttpContext.Session.GetString(SessionKey);
            if (string.IsNullOrEmpty(sessionJson))
            {
                return Json(new { success = false, message = "Phiên luyện nghe đã hết hạn." });
            }

            var session = JsonSerializer.Deserialize<ListeningSession>(sessionJson);
            if (session == null || model.QuestionIndex < 0 || model.QuestionIndex >= session.Questions.Count)
            {
                return Json(new { success = false, message = "Câu hỏi không hợp lệ." });
            }

            var question = session.Questions[model.QuestionIndex];
            _listeningService.EvaluateQuestion(question, model.UserAnswer);

            // Cập nhật session
            HttpContext.Session.SetString(SessionKey, JsonSerializer.Serialize(session));

            // Tự động cập nhật UserProgress nếu đăng nhập
            if (User.Identity?.IsAuthenticated == true && question.WordId > 0)
            {
                var userIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
                if (int.TryParse(userIdStr, out int userId))
                {
                    await _progressService.UpdateProgressAsync(userId, question.WordId, question.IsCorrect);
                }
            }

            return Json(new
            {
                success = true,
                isCorrect = question.IsCorrect,
                isPartial = question.IsPartialToneOnly,
                feedbackMessage = question.FeedbackMessage,
                diffTokens = question.DiffTokens,
                targetHanzi = question.TargetHanzi,
                targetPinyin = question.TargetPinyin,
                meaning = question.Meaning,
                currentScore = session.Score,
                totalQuestions = session.TotalQuestions,
                nextIndex = model.QuestionIndex + 1,
                isFinished = model.QuestionIndex + 1 >= session.TotalQuestions
            });
        }

        [HttpGet]
        public async Task<IActionResult> Result()
        {
            var sessionJson = HttpContext.Session.GetString(SessionKey);
            if (string.IsNullOrEmpty(sessionJson))
            {
                return RedirectToAction(nameof(Index));
            }

            var session = JsonSerializer.Deserialize<ListeningSession>(sessionJson);
            if (session == null)
            {
                return RedirectToAction(nameof(Index));
            }

            // Lưu kết quả vào DB nếu đã đăng nhập
            if (User.Identity?.IsAuthenticated == true)
            {
                var userIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
                if (int.TryParse(userIdStr, out int userId))
                {
                    await _listeningService.SaveResultAsync(
                        userId, 
                        session.HskLevel, 
                        session.ExerciseType, 
                        session.InputMode, 
                        session.Score, 
                        session.TotalQuestions
                    );
                }
            }

            var model = new ListeningResultViewModel
            {
                HskLevel = session.HskLevel,
                ExerciseType = session.ExerciseType,
                InputMode = session.InputMode,
                Score = session.Score,
                TotalQuestions = session.TotalQuestions,
                AccuracyPercentage = session.AccuracyPercentage,
                Questions = session.Questions
            };

            return View(model);
        }
    }
}
