using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using HonZi.Web.Models.ViewModels;
using HonZi.Web.Services;

namespace HonZi.Web.Controllers
{
    [Authorize]
    public class ProgressController : Controller
    {
        private readonly IProgressService _progressService;
        private readonly IQuizService _quizService;
        private readonly IListeningService _listeningService;
        private readonly ISpacedRepetitionService _srsService;

        public ProgressController(
            IProgressService progressService, 
            IQuizService quizService, 
            IListeningService listeningService,
            ISpacedRepetitionService srsService)
        {
            _progressService = progressService;
            _quizService = quizService;
            _listeningService = listeningService;
            _srsService = srsService;
        }

        public async Task<IActionResult> Index()
        {
            var userIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (!int.TryParse(userIdStr, out int userId))
            {
                return RedirectToAction("Login", "Auth");
            }

            var stats = await _progressService.GetUserStatsAsync(userId);
            var needsReview = await _progressService.GetWordsNeedingReviewAsync(userId, 15);
            var dueWords = await _srsService.GetDueWordsAsync(userId, null, 20);
            var dueCount = await _srsService.GetDueWordsCountAsync(userId);
            var recentQuizzes = await _quizService.GetUserQuizHistoryAsync(userId, 5);
            var recentListenings = await _listeningService.GetUserListeningHistoryAsync(userId, 5);

            var viewModel = new ProgressDashboardViewModel
            {
                Stats = stats,
                DueWordsCount = dueCount,
                DueWords = dueWords,
                NeedsReviewWords = needsReview,
                RecentQuizzes = recentQuizzes,
                RecentListenings = recentListenings
            };

            return View(viewModel);
        }

        [HttpPost]
        [Authorize]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ResetHsk(int hskLevel)
        {
            var userIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (int.TryParse(userIdStr, out int userId))
            {
                await _progressService.ResetProgressByHskAsync(userId, hskLevel);
                TempData["SuccessMessage"] = $"Đã đặt lại tiến độ học tập cho cấp độ HSK {hskLevel}.";
            }
            return RedirectToAction(nameof(Index));
        }
    }
}
