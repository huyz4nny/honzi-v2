package controller;

import dao.ProgressDAO;
import dao.QuizDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.QuizResult;
import model.SystemOverviewDTO;
import model.User;
import model.UserProgress;
import model.UserStatsDTO;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminUserServlet", urlPatterns = {"/admin/users", "/admin/users/detail"})
public class AdminUserServlet extends HttpServlet {

    private UserDAO userDAO;
    private ProgressDAO progressDAO;
    private QuizDAO quizDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        progressDAO = new ProgressDAO();
        quizDAO = new QuizDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // 1. Kiểm tra xác thực và phân quyền Admin
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String servletPath = request.getServletPath();

        try {
            if ("/admin/users/detail".equals(servletPath)) {
                showUserDetail(request, response);
            } else {
                showUsersList(request, response);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi: " + ex.getMessage());
            showUsersList(request, response);
        }
    }

    private void showUsersList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String searchKeyword = request.getParameter("search");
        String roleFilter = request.getParameter("role");

        if (searchKeyword != null) {
            searchKeyword = searchKeyword.trim();
        }
        if (roleFilter != null) {
            roleFilter = roleFilter.trim();
        }

        // Lấy thống kê tổng quan toàn hệ thống
        SystemOverviewDTO systemStats = userDAO.getSystemOverviewStats();

        // Lấy danh sách người dùng kèm thống kê cá nhân
        List<UserStatsDTO> userList = userDAO.getAllUsersWithStats(searchKeyword, roleFilter);

        request.setAttribute("systemStats", systemStats);
        request.setAttribute("userList", userList);
        request.setAttribute("searchKeyword", searchKeyword);
        request.setAttribute("roleFilter", roleFilter);

        request.getRequestDispatcher("/adminUsers.jsp").forward(request, response);
    }

    private void showUserDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        try {
            int userId = Integer.parseInt(idParam);
            User targetUser = userDAO.getUserById(userId);

            if (targetUser == null) {
                request.setAttribute("errorMessage", "Không tìm thấy người dùng với ID: " + userId);
                showUsersList(request, response);
                return;
            }

            // 1. Thống kê tiến độ theo 6 cấp độ HSK
            Map<Integer, Map<String, Integer>> summary = progressDAO.getProgressSummaryByLevel(userId);

            // 2. Danh sách tất cả các từ vựng học viên đã học
            List<UserProgress> userProgressList = progressDAO.getUserProgressList(userId, null);

            // 3. Lịch sử làm bài kiểm tra trắc nghiệm
            List<QuizResult> quizHistory = quizDAO.getQuizResultsByUser(userId);

            // 4. Tính toán các chỉ số tổng hợp nhanh
            int totalMastered = 0;
            int totalLearning = 0;
            for (UserProgress up : userProgressList) {
                if ("Mastered".equalsIgnoreCase(up.getStatus())) {
                    totalMastered++;
                } else {
                    totalLearning++;
                }
            }

            double avgQuizScore = 0.0;
            if (!quizHistory.isEmpty()) {
                double totalScorePercent = 0.0;
                for (QuizResult qr : quizHistory) {
                    double pct = (qr.getTotalQuestions() > 0)
                            ? ((double) qr.getScore() / qr.getTotalQuestions()) * 100.0
                            : 0.0;
                    totalScorePercent += pct;
                }
                avgQuizScore = totalScorePercent / quizHistory.size();
            }

            request.setAttribute("targetUser", targetUser);
            request.setAttribute("summary", summary);
            request.setAttribute("userProgressList", userProgressList);
            request.setAttribute("quizHistory", quizHistory);
            request.setAttribute("totalMastered", totalMastered);
            request.setAttribute("totalLearning", totalLearning);
            request.setAttribute("totalWordsLearned", userProgressList.size());
            request.setAttribute("avgQuizScore", avgQuizScore);

            request.getRequestDispatcher("/adminUserDetail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }
}
