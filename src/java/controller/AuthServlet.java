package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

import java.io.IOException;

@WebServlet(name = "AuthServlet", urlPatterns = {"/login", "/register", "/logout"})
public class AuthServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/register":
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                break;
            case "/logout":
                HttpSession session = request.getSession(false);
                if (session != null) {
                    session.invalidate();
                }
                response.sendRedirect(request.getContextPath() + "/login");
                break;
            case "/login":
            default:
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getServletPath();

        if ("/register".equals(action)) {
            processRegister(request, response);
        } else if ("/login".equals(action)) {
            processLogin(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }

    private void processLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (isNullOrEmpty(username) || isNullOrEmpty(password)) {
            request.setAttribute("errorMessage", "Vui lòng nhập tên đăng nhập và mật khẩu.");
            request.setAttribute("username", username);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            User user = userDAO.loginUser(username.trim(), password.trim());
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("successMessage", "Chào mừng " + user.getUsername() + " quay trở lại!");
                
                if (user.isAdmin()) {
                    response.sendRedirect(request.getContextPath() + "/words");
                } else {
                    response.sendRedirect(request.getContextPath() + "/flashcard");
                }
            } else {
                request.setAttribute("errorMessage", "Tên đăng nhập hoặc mật khẩu không chính xác.");
                request.setAttribute("username", username);
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi kết nối CSDL SQL Server: " + ex.getMessage());
            request.setAttribute("username", username);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    private void processRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (isNullOrEmpty(username) || isNullOrEmpty(email) || isNullOrEmpty(password) || isNullOrEmpty(confirmPassword)) {
            request.setAttribute("errorMessage", "Vui lòng điền đầy đủ các thông tin đăng ký.");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu xác nhận không khớp!");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.checkUsernameExists(username.trim())) {
            request.setAttribute("errorMessage", "Tên đăng nhập '" + username + "' đã được sử dụng. Vui lòng chọn tên khác.");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.checkEmailExists(email.trim())) {
            request.setAttribute("errorMessage", "Email '" + email + "' đã tồn tại trên hệ thống.");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        User newUser = new User(username.trim(), password.trim(), email.trim(), "USER");
        boolean success = userDAO.registerUser(newUser);

        if (success) {
            request.setAttribute("successMessage", "Đăng ký tài khoản thành công! Vui lòng đăng nhập.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Đăng ký không thành công do lỗi CSDL. Vui lòng thử lại.");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

    private boolean isNullOrEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }
}
