package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import util.EmailUtil;

import java.io.IOException;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/forgot-password", "/verify-otp", "/reset-password"})
public class ForgotPasswordServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String path = request.getServletPath();
        HttpSession session = request.getSession();

        switch (path) {
            case "/verify-otp":
                String resetEmail = (String) session.getAttribute("resetEmail");
                if (resetEmail == null) {
                    response.sendRedirect(request.getContextPath() + "/forgot-password");
                    return;
                }
                request.getRequestDispatcher("/verifyOtp.jsp").forward(request, response);
                break;

            case "/reset-password":
                Boolean otpVerified = (Boolean) session.getAttribute("otpVerified");
                if (otpVerified == null || !otpVerified) {
                    response.sendRedirect(request.getContextPath() + "/forgot-password");
                    return;
                }
                request.getRequestDispatcher("/resetPassword.jsp").forward(request, response);
                break;

            case "/forgot-password":
            default:
                request.getRequestDispatcher("/forgotPassword.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String path = request.getServletPath();
        HttpSession session = request.getSession();

        switch (path) {
            case "/forgot-password":
                handleSendOtp(request, response, session);
                break;

            case "/verify-otp":
                handleVerifyOtp(request, response, session);
                break;

            case "/reset-password":
                handleResetPassword(request, response, session);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/login");
                break;
        }
    }

    private void handleSendOtp(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập địa chỉ email của bạn.");
            request.getRequestDispatcher("/forgotPassword.jsp").forward(request, response);
            return;
        }

        email = email.trim();
        User user = userDAO.getUserByEmail(email);

        if (user == null) {
            request.setAttribute("errorMessage", "Địa chỉ email '" + email + "' chưa được đăng ký trong hệ thống.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/forgotPassword.jsp").forward(request, response);
            return;
        }

        // Sinh mã OTP 6 số ngẫu nhiên
        String otp = EmailUtil.generateOtp();
        long expiryTime = System.currentTimeMillis() + (5 * 60 * 1000); // 5 phút

        // Lưu thông tin vào session
        session.setAttribute("resetEmail", email);
        session.setAttribute("resetUsername", user.getUsername());
        session.setAttribute("resetOtp", otp);
        session.setAttribute("otpExpiry", expiryTime);
        session.setAttribute("otpVerified", false);

        // Gửi email OTP
        EmailUtil.sendOtpEmail(email, user.getUsername(), otp);

        session.setAttribute("infoMessage", "Mã OTP 6 chữ số đã được gửi tới " + email + ". Vui lòng kiểm tra hộp thư (hoặc thư mục Spam)!");
        response.sendRedirect(request.getContextPath() + "/verify-otp");
    }

    private void handleVerifyOtp(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        String resetEmail = (String) session.getAttribute("resetEmail");
        String sessionOtp = (String) session.getAttribute("resetOtp");
        Long otpExpiry = (Long) session.getAttribute("otpExpiry");

        if (resetEmail == null || sessionOtp == null || otpExpiry == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        // Xử lý nếu người dùng bấm "Gửi lại mã OTP"
        String resend = request.getParameter("resend");
        if ("true".equalsIgnoreCase(resend)) {
            String newOtp = EmailUtil.generateOtp();
            long newExpiry = System.currentTimeMillis() + (5 * 60 * 1000);
            session.setAttribute("resetOtp", newOtp);
            session.setAttribute("otpExpiry", newExpiry);
            session.setAttribute("otpVerified", false);

            String username = (String) session.getAttribute("resetUsername");
            EmailUtil.sendOtpEmail(resetEmail, username, newOtp);

            request.setAttribute("infoMessage", "Đã gửi lại mã OTP mới tới email của bạn!");
            request.getRequestDispatcher("/verifyOtp.jsp").forward(request, response);
            return;
        }

        String inputOtp = request.getParameter("otp");
        if (inputOtp == null || inputOtp.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ mã xác thực OTP.");
            request.getRequestDispatcher("/verifyOtp.jsp").forward(request, response);
            return;
        }

        inputOtp = inputOtp.trim();

        // Kiểm tra thời gian hết hạn
        if (System.currentTimeMillis() > otpExpiry) {
            request.setAttribute("errorMessage", "Mã OTP đã hết hiệu lực (quá 5 phút). Vui lòng bấm 'Gửi lại mã OTP'.");
            request.getRequestDispatcher("/verifyOtp.jsp").forward(request, response);
            return;
        }

        // Kiểm tra so khớp mã OTP
        if (!sessionOtp.equals(inputOtp)) {
            request.setAttribute("errorMessage", "Mã OTP không chính xác. Vui lòng kiểm tra lại!");
            request.getRequestDispatcher("/verifyOtp.jsp").forward(request, response);
            return;
        }

        // OTP hợp lệ -> Cho phép sang bước đặt lại mật khẩu
        session.setAttribute("otpVerified", true);
        response.sendRedirect(request.getContextPath() + "/reset-password");
    }

    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        Boolean otpVerified = (Boolean) session.getAttribute("otpVerified");
        String resetEmail = (String) session.getAttribute("resetEmail");

        if (otpVerified == null || !otpVerified || resetEmail == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (newPassword == null || newPassword.trim().isEmpty() || confirmPassword == null || confirmPassword.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ mật khẩu mới và xác nhận mật khẩu.");
            request.getRequestDispatcher("/resetPassword.jsp").forward(request, response);
            return;
        }

        if (newPassword.length() < 6) {
            request.setAttribute("errorMessage", "Mật khẩu mới phải có độ dài tối thiểu 6 ký tự.");
            request.getRequestDispatcher("/resetPassword.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Xác nhận mật khẩu mới không trùng khớp.");
            request.getRequestDispatcher("/resetPassword.jsp").forward(request, response);
            return;
        }

        // Cập nhật vào CSDL
        boolean updated = userDAO.updatePasswordByEmail(resetEmail, newPassword.trim());

        if (updated) {
            // Xóa session reset
            session.removeAttribute("resetEmail");
            session.removeAttribute("resetUsername");
            session.removeAttribute("resetOtp");
            session.removeAttribute("otpExpiry");
            session.removeAttribute("otpVerified");

            session.setAttribute("successMessage", "Đặt lại mật khẩu thành công! Bạn có thể đăng nhập ngay bằng mật khẩu mới.");
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            request.setAttribute("errorMessage", "Không thể cập nhật mật khẩu lúc này. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/resetPassword.jsp").forward(request, response);
        }
    }
}
