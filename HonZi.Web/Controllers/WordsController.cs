using System;
using System.IO;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using HonZi.Web.Data;
using HonZi.Web.Models;
using HonZi.Web.Models.ViewModels;
using HonZi.Web.Services;

namespace HonZi.Web.Controllers
{
    public class WordsController : Controller
    {
        private readonly IWordService _wordService;
        private readonly IExcelService _excelService;
        private readonly HanziGoDbContext _context;

        public WordsController(IWordService wordService, IExcelService excelService, HanziGoDbContext context)
        {
            _wordService = wordService;
            _excelService = excelService;
            _context = context;
        }

        public async Task<IActionResult> Index(int? hskLevel, string? search, string? topic, int page = 1)
        {
            const int pageSize = 15;
            if (page < 1) page = 1;

            var (words, totalCount) = await _wordService.GetWordsAsync(hskLevel, search, topic, page, pageSize);
            var topics = await _wordService.GetAllTopicsAsync();

            var viewModel = new WordListViewModel
            {
                Words = words,
                TotalCount = totalCount,
                CurrentPage = page,
                PageSize = pageSize,
                SelectedHsk = hskLevel,
                SearchQuery = search,
                SelectedTopic = topic,
                Topics = topics
            };

            return View(viewModel);
        }

        [Authorize(Roles = "ADMIN")]
        [HttpGet]
        public IActionResult Create()
        {
            return View(new WordFormViewModel());
        }

        [Authorize(Roles = "ADMIN")]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(WordFormViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            var word = new Word
            {
                Hanzi = model.Hanzi.Trim(),
                Pinyin = model.Pinyin.Trim(),
                MeaningVi = model.MeaningVi.Trim(),
                HskLevel = model.HskLevel,
                Topic = string.IsNullOrWhiteSpace(model.Topic) ? "Từ vựng chung" : model.Topic.Trim(),
                ExampleSentence = model.ExampleSentence?.Trim(),
                ExampleMeaningVi = model.ExampleMeaningVi?.Trim(),
                AudioUrl = model.AudioUrl?.Trim()
            };

            await _wordService.CreateWordAsync(word);
            TempData["SuccessMessage"] = $"Đã thêm thành công từ vựng: {word.Hanzi} ({word.Pinyin})";
            return RedirectToAction(nameof(Index), new { hskLevel = word.HskLevel });
        }

        [Authorize(Roles = "ADMIN")]
        [HttpGet]
        public async Task<IActionResult> Edit(int id)
        {
            var word = await _wordService.GetWordByIdAsync(id);
            if (word == null) return NotFound();

            var model = new WordFormViewModel
            {
                WordId = word.WordId,
                Hanzi = word.Hanzi,
                Pinyin = word.Pinyin,
                MeaningVi = word.MeaningVi,
                HskLevel = word.HskLevel,
                Topic = word.Topic,
                ExampleSentence = word.ExampleSentence,
                ExampleMeaningVi = word.ExampleMeaningVi,
                AudioUrl = word.AudioUrl
            };

            return View(model);
        }

        [Authorize(Roles = "ADMIN")]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, WordFormViewModel model)
        {
            if (id != model.WordId) return BadRequest();

            if (!ModelState.IsValid)
            {
                return View(model);
            }

            var word = await _wordService.GetWordByIdAsync(id);
            if (word == null) return NotFound();

            word.Hanzi = model.Hanzi.Trim();
            word.Pinyin = model.Pinyin.Trim();
            word.MeaningVi = model.MeaningVi.Trim();
            word.HskLevel = model.HskLevel;
            word.Topic = string.IsNullOrWhiteSpace(model.Topic) ? "Từ vựng chung" : model.Topic.Trim();
            word.ExampleSentence = model.ExampleSentence?.Trim();
            word.ExampleMeaningVi = model.ExampleMeaningVi?.Trim();
            word.AudioUrl = model.AudioUrl?.Trim();

            await _wordService.UpdateWordAsync(word);
            TempData["SuccessMessage"] = $"Đã cập nhật từ vựng: {word.Hanzi}";
            return RedirectToAction(nameof(Index), new { hskLevel = word.HskLevel });
        }

        [Authorize(Roles = "ADMIN")]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int id)
        {
            var success = await _wordService.DeleteWordAsync(id);
            if (success)
            {
                TempData["SuccessMessage"] = "Đã xóa từ vựng thành công.";
            }
            else
            {
                TempData["ErrorMessage"] = "Không tìm thấy từ vựng để xóa.";
            }
            return RedirectToAction(nameof(Index));
        }

        [Authorize(Roles = "ADMIN")]
        [HttpGet]
        public IActionResult Import()
        {
            return View();
        }

        [Authorize(Roles = "ADMIN")]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Import(WordImportViewModel model)
        {
            if (model.File == null || model.File.Length == 0)
            {
                ModelState.AddModelError(string.Empty, "Vui lòng chọn một file Excel hoặc CSV hợp lệ.");
                return View(model);
            }

            try
            {
                using var stream = model.File.OpenReadStream();
                var result = await _excelService.ParseWordsFileAsync(stream, model.File.FileName);

                int savedCount = 0;
                foreach (var item in result.ProcessedItems)
                {
                    if (item.IsValid)
                    {
                        var word = new Word
                        {
                            Hanzi = item.Hanzi,
                            Pinyin = item.Pinyin,
                            MeaningVi = item.MeaningVi,
                            HskLevel = item.HskLevel,
                            Topic = item.Topic,
                            ExampleSentence = item.ExampleSentence,
                            ExampleMeaningVi = item.ExampleMeaningVi,
                            AudioUrl = item.AudioUrl
                        };
                        _context.Words.Add(word);
                        savedCount++;
                    }
                }

                if (savedCount > 0)
                {
                    await _context.SaveChangesAsync();
                }

                TempData["SuccessMessage"] = $"Import thành công {savedCount}/{result.TotalRows} từ vựng mới!";
                ViewBag.ImportResult = result;
                return View(model);
            }
            catch (Exception ex)
            {
                ModelState.AddModelError(string.Empty, "Lỗi đọc file: " + ex.Message);
                return View(model);
            }
        }

        [HttpGet]
        public IActionResult DownloadTemplate()
        {
            var bytes = _excelService.GenerateSampleExcelTemplate();
            return File(bytes, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "HanziGo_Word_Template.xlsx");
        }
    }
}
