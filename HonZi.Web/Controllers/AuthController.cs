using System;
using System.Collections.Generic;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using HonZi.Web.Data;
using HonZi.Web.Models;
using HonZi.Web.Models.ViewModels;
using HonZi.Web.Services;

namespace HonZi.Web.Controllers
{
    public class AuthController : Controller
    {
        private readonly HanziGoDbContext _context;
        private readonly IPasswordHasher _passwordHasher;

        public AuthController(HanziGoDbContext context, IPasswordHasher passwordHasher)
        {
            _context = context;
            _passwordHasher = passwordHasher;
        }

        [HttpGet]
        public IActionResult Login(string? returnUrl = null)
        {
            if (User.Identity?.IsAuthenticated == true)
            {
                return RedirectToAction("Index", "Home");
            }

            return View(new LoginViewModel { ReturnUrl = returnUrl });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Login(LoginViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            var identifier = model.UsernameOrEmail.Trim();
            var user = await _context.Users
                .FirstOrDefaultAsync(u => u.Username == identifier || u.Email == identifier);

            if (user == null || !_passwordHasher.VerifyPassword(model.Password, user.PasswordHash))
            {
                ModelState.AddModelError(string.Empty, "Tên đăng nhập hoặc mật khẩu không chính xác.");
                return View(model);
            }

            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.NameIdentifier, user.UserId.ToString()),
                new Claim(ClaimTypes.Name, user.Username),
                new Claim(ClaimTypes.Email, user.Email),
                new Claim(ClaimTypes.Role, user.Role)
            };

            var claimsIdentity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
            var authProperties = new AuthenticationProperties
            {
                IsPersistent = model.RememberMe,
                ExpiresUtc = model.RememberMe ? DateTimeOffset.UtcNow.AddDays(14) : DateTimeOffset.UtcNow.AddHours(2)
            };

            await HttpContext.SignInAsync(
                CookieAuthenticationDefaults.AuthenticationScheme,
                new ClaimsPrincipal(claimsIdentity),
                authProperties);

            if (!string.IsNullOrEmpty(model.ReturnUrl) && Url.IsLocalUrl(model.ReturnUrl))
            {
                return Redirect(model.ReturnUrl);
            }

            return RedirectToAction("Index", "Home");
        }

        [HttpGet]
        public IActionResult Register()
        {
            if (User.Identity?.IsAuthenticated == true)
            {
                return RedirectToAction("Index", "Home");
            }

            return View(new RegisterViewModel());
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Register(RegisterViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            var usernameExists = await _context.Users.AnyAsync(u => u.Username == model.Username.Trim());
            if (usernameExists)
            {
                ModelState.AddModelError(nameof(model.Username), "Tên đăng nhập này đã được sử dụng.");
                return View(model);
            }

            var emailExists = await _context.Users.AnyAsync(u => u.Email == model.Email.Trim().ToLowerInvariant());
            if (emailExists)
            {
                ModelState.AddModelError(nameof(model.Email), "Địa chỉ email này đã được sử dụng.");
                return View(model);
            }

            var newUser = new User
            {
                Username = model.Username.Trim(),
                Email = model.Email.Trim().ToLowerInvariant(),
                PasswordHash = _passwordHasher.HashPassword(model.Password),
                Role = "USER",
                CreatedAt = DateTime.Now
            };

            _context.Users.Add(newUser);
            await _context.SaveChangesAsync();

            TempData["SuccessMessage"] = "Đăng ký tài khoản thành công! Mời bạn đăng nhập.";
            return RedirectToAction(nameof(Login));
        }

        [HttpPost]
        [HttpGet]
        public async Task<IActionResult> Logout()
        {
            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            HttpContext.Session.Clear();
            return RedirectToAction("Index", "Home");
        }

        [HttpGet]
        public IActionResult ForgotPassword()
        {
            return View(new ForgotPasswordViewModel());
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ForgotPassword(ForgotPasswordViewModel model)
        {
            if (!ModelState.IsValid) return View(model);

            var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == model.Email.Trim().ToLowerInvariant());
            if (user == null)
            {
                ModelState.AddModelError(string.Empty, "Không tìm thấy tài khoản nào gắn với email này.");
                return View(model);
            }

            // Sinh mã OTP 6 số ngẫu nhiên
            var otp = new Random().Next(100000, 999999).ToString();
            HttpContext.Session.SetString("ResetOtp", otp);
            HttpContext.Session.SetInt32("ResetUserId", user.UserId);

            // In OTP trực tiếp ra console như phiên bản gốc
            Console.WriteLine($"[HanziGo] >>> Mã OTP khôi phục mật khẩu của {user.Username} ({user.Email}) là: {otp} <<<");

            TempData["InfoMessage"] = $"Mã OTP đã được gửi đến email (và in trên console máy chủ): {otp}";
            return RedirectToAction(nameof(VerifyOtp));
        }

        [HttpGet]
        public IActionResult VerifyOtp()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult VerifyOtp(string otp)
        {
            var sessionOtp = HttpContext.Session.GetString("ResetOtp");
            if (string.IsNullOrEmpty(sessionOtp) || sessionOtp != otp?.Trim())
            {
                ViewBag.Error = "Mã OTP không đúng hoặc đã hết hạn.";
                return View();
            }

            return RedirectToAction(nameof(ResetPassword));
        }

        [HttpGet]
        public IActionResult ResetPassword()
        {
            var userId = HttpContext.Session.GetInt32("ResetUserId");
            if (!userId.HasValue) return RedirectToAction(nameof(Login));

            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ResetPassword(string newPassword, string confirmPassword)
        {
            var userId = HttpContext.Session.GetInt32("ResetUserId");
            if (!userId.HasValue) return RedirectToAction(nameof(Login));

            if (string.IsNullOrWhiteSpace(newPassword) || newPassword.Length < 6)
            {
                ViewBag.Error = "Mật khẩu mới phải có tối thiểu 6 ký tự.";
                return View();
            }

            if (newPassword != confirmPassword)
            {
                ViewBag.Error = "Mật khẩu xác nhận không khớp.";
                return View();
            }

            var user = await _context.Users.FindAsync(userId.Value);
            if (user != null)
            {
                user.PasswordHash = _passwordHasher.HashPassword(newPassword);
                await _context.SaveChangesAsync();
            }

            HttpContext.Session.Remove("ResetOtp");
            HttpContext.Session.Remove("ResetUserId");

            TempData["SuccessMessage"] = "Đổi mật khẩu thành công! Mời bạn đăng nhập lại.";
            return RedirectToAction(nameof(Login));
        }
    }
}
