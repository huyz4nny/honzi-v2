using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using HonZi.Web.Models;
using HonZi.Web.Models.ViewModels;
using HonZi.Web.Services;

namespace HonZi.Web.Controllers
{
    public class FlashcardController : Controller
    {
        private readonly IWordService _wordService;
        private readonly IProgressService _progressService;
        private readonly ISpacedRepetitionService _srsService;

        public FlashcardController(
            IWordService wordService, 
            IProgressService progressService, 
            ISpacedRepetitionService srsService)
        {
            _wordService = wordService;
            _progressService = progressService;
            _srsService = srsService;
        }

        public async Task<IActionResult> Index(int hskLevel = 1, int index = 0, bool reset = false, bool srsMode = false)
        {
            if (hskLevel < 1 || hskLevel > 6) hskLevel = 1;

            int? userId = null;
            int dueCount = 0;

            if (User.Identity?.IsAuthenticated == true)
            {
                var userIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
                if (int.TryParse(userIdStr, out int uid))
                {
                    userId = uid;
                    dueCount = await _srsService.GetDueWordsCountAsync(uid, hskLevel);

                    if (reset)
                    {
                        await _progressService.ResetProgressByHskAsync(uid, hskLevel);
                        index = 0;
                    }
                }
            }

            List<Word> words;
            if (srsMode && userId.HasValue)
            {
                var dueList = await _srsService.GetDueWordsAsync(userId.Value, hskLevel, 30);
                words = dueList.Select(up => up.Word).ToList();

                if (!words.Any())
                {
                    TempData["InfoMessage"] = $"Tuyệt vời! Không còn từ nào đến hạn ôn tập ở HSK {hskLevel} hôm nay. Hệ thống chuyển về chế độ học bình thường.";
                    srsMode = false;
                    words = await _wordService.GetWordsByHskAsync(hskLevel);
                }
            }
            else
            {
                words = await _wordService.GetWordsByHskAsync(hskLevel);
            }

            if (index < 0) index = 0;

            var model = new FlashcardViewModel
            {
                SelectedHsk = hskLevel,
                Words = words,
                CurrentIndex = index,
                IsSrsMode = srsMode,
                DueCount = dueCount
            };

            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Mark(int hskLevel, int currentIndex, int wordId, string status, bool srsMode = false)
        {
            if (User.Identity?.IsAuthenticated == true)
            {
                var userIdStr = User.FindFirstValue(ClaimTypes.NameIdentifier);
                if (int.TryParse(userIdStr, out int userId))
                {
                    bool isMastered = status == "mastered";
                    await _progressService.UpdateProgressAsync(userId, wordId, isMastered);
                }
            }

            return RedirectToAction(nameof(Index), new { hskLevel = hskLevel, index = currentIndex + 1, srsMode = srsMode });
        }
    }
}
