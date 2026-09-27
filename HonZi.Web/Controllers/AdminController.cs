using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using HonZi.Web.Data;
using HonZi.Web.Models.ViewModels;
using HonZi.Web.Services;

namespace HonZi.Web.Controllers
{
    [Authorize(Roles = "ADMIN")]
    public class AdminController : Controller
    {
        private readonly HanziGoDbContext _context;
        private readonly IProgressService _progressService;
        private readonly IQuizService _quizService;
        private readonly IListeningService _listeningService;

        public AdminController(
            HanziGoDbContext context,
            IProgressService progressService,
            IQuizService quizService,
            IListeningService listeningService)
        {
            _context = context;
            _progressService = progressService;
            _quizService = quizService;
            _listeningService = listeningService;
        }

        public async Task<IActionResult> Users()
        {
            var users = await _context.Users
                .OrderByDescending(u => u.CreatedAt)
                .ToListAsync();

            var model = new AdminUsersViewModel
            {
                Users = users,
                AdminCount = users.Count(u => u.Role == "ADMIN"),
                TotalWords = await _context.Words.CountAsync(),
                TotalQuizCount = await _context.QuizResults.CountAsync(),
                TotalListeningCount = await _context.ListeningResults.CountAsync()
            };

            return View(model);
        }

        public async Task<IActionResult> UserDetail(int id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null) return NotFound();

            var stats = await _progressService.GetUserStatsAsync(id);
            var quizzes = await _quizService.GetUserQuizHistoryAsync(id, 10);
            var listenings = await _listeningService.GetUserListeningHistoryAsync(id, 10);

            var model = new AdminUserDetailViewModel
            {
                User = user,
                Stats = stats,
                Quizzes = quizzes,
                Listenings = listenings
            };

            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ToggleRole(int id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user != null && user.UserId != 1) // Tránh hạ quyền super admin
            {
                user.Role = user.Role == "ADMIN" ? "USER" : "ADMIN";
                await _context.SaveChangesAsync();
                TempData["SuccessMessage"] = $"Đã cập nhật vai trò của {user.Username} thành {user.Role}.";
            }
            return RedirectToAction(nameof(Users));
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteUser(int id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user != null && user.UserId != 1) // Tránh xóa super admin
            {
                _context.Users.Remove(user);
                await _context.SaveChangesAsync();
                TempData["SuccessMessage"] = $"Đã xóa người dùng {user.Username}.";
            }
            return RedirectToAction(nameof(Users));
        }
    }
}
