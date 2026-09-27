using System.Diagnostics;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using HonZi.Web.Data;
using HonZi.Web.Models;

namespace HonZi.Web.Controllers
{
    public class HomeController : Controller
    {
        private readonly HanziGoDbContext _context;
        private readonly HonZi.Web.Services.ISpacedRepetitionService _srsService;

        public HomeController(HanziGoDbContext context, HonZi.Web.Services.ISpacedRepetitionService srsService)
        {
            _context = context;
            _srsService = srsService;
        }

        public async Task<IActionResult> Index()
        {
            // Thống kê nhanh cho trang chủ
            ViewBag.TotalWords = await _context.Words.CountAsync();
            ViewBag.TotalUsers = await _context.Users.CountAsync();
            ViewBag.TotalQuizzes = await _context.QuizResults.CountAsync();
            ViewBag.TotalListenings = await _context.ListeningResults.CountAsync();

            if (User.Identity?.IsAuthenticated == true)
            {
                var userIdStr = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
                if (int.TryParse(userIdStr, out int userId))
                {
                    ViewBag.DueCount = await _srsService.GetDueWordsCountAsync(userId);
                }
            }

            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
