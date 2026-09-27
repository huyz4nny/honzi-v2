package controller;

import dao.ProgressDAO;
import dao.QuizDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.QuizResult;
import model.User;
import model.UserProgress;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ProgressServlet", urlPatterns = {"/progress"})
public class ProgressServlet extends HttpServlet {

    private ProgressDAO progressDAO;
    private QuizDAO quizDAO;

    @Override
    public void init() throws ServletException {
        progressDAO = new ProgressDAO();
        quizDAO = new QuizDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Lấy thống kê số từ đã thuộc / đang học theo 6 cấp HSK
        Map<Integer, Map<String, Integer>> summary = progressDAO.getProgressSummaryByLevel(user.getUserId());
        
        // Lấy danh sách tiến độ chi tiết
        List<UserProgress> userProgressList = progressDAO.getUserProgressList(user.getUserId(), null);
        
        // Lấy lịch sử trắc nghiệm Quiz
        List<QuizResult> quizHistory = quizDAO.getQuizResultsByUser(user.getUserId());

        request.setAttribute("summary", summary);
        request.setAttribute("userProgressList", userProgressList);
        request.setAttribute("quizHistory", quizHistory);

        request.getRequestDispatcher("/progress.jsp").forward(request, response);
    }
}
