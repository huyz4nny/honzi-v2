package controller;

import dao.ProgressDAO;
import dao.WordDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import model.Word;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "FlashcardServlet", urlPatterns = {"/flashcard"})
public class FlashcardServlet extends HttpServlet {

    private WordDAO wordDAO;
    private ProgressDAO progressDAO;

    @Override
    public void init() throws ServletException {
        wordDAO = new WordDAO();
        progressDAO = new ProgressDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // 1. Quản lý cấp độ HSK được chọn trong Session
        Integer currentHsk = (Integer) session.getAttribute("flashcardHskLevel");
        String hskParam = request.getParameter("hskLevel");

        if (hskParam != null && !hskParam.trim().isEmpty()) {
            try {
                int newHsk = Integer.parseInt(hskParam);
                if (newHsk >= 1 && newHsk <= 6) {
                    currentHsk = newHsk;
                    session.setAttribute("flashcardHskLevel", currentHsk);
                }
            } catch (NumberFormatException e) {
                // Giữ nguyên HSK hiện tại
            }
        }

        if (currentHsk == null) {
            currentHsk = 1;
            session.setAttribute("flashcardHskLevel", currentHsk);
        }

        // 2. Lưu vị trí từ đang học RIÊNG BIỆT theo từng cấp HSK trong Session
        String sessionKey = "flashcardIndex_" + currentHsk;
        Integer currentIndex = (Integer) session.getAttribute(sessionKey);
        if (currentIndex == null || currentIndex < 0) {
            currentIndex = 0;
            session.setAttribute(sessionKey, 0);
        }

        // 3. Xử lý yêu cầu Reset học lại từ đầu của cấp độ này:
        // Đặt lại vị trí về 0 VÀ xóa các từ đã thuộc/tiến độ của cấp HSK đó trong CSDL
        String resetParam = request.getParameter("reset");
        if ("true".equalsIgnoreCase(resetParam)) {
            currentIndex = 0;
            session.setAttribute(sessionKey, 0);

            User user = (User) session.getAttribute("user");
            if (user != null) {
                progressDAO.resetProgressByHskLevel(user.getUserId(), currentHsk);
            }
        }

        // 4. Lấy danh sách từ vựng theo HSK
        List<Word> wordList = wordDAO.getWordsByHskLevel(currentHsk);
        int totalWords = wordList.size();

        if (totalWords > 0) {
            if (currentIndex >= totalWords) {
                // Đã học hết danh sách từ
                request.setAttribute("isCompleted", true);
            } else {
                Word currentWord = wordList.get(currentIndex);
                request.setAttribute("currentWord", currentWord);
            }
        }

        request.setAttribute("wordList", wordList);
        request.setAttribute("currentIndex", currentIndex);
        request.setAttribute("totalWords", totalWords);
        request.setAttribute("selectedHsk", currentHsk);

        request.getRequestDispatcher("/flashcard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        Integer currentHsk = (Integer) session.getAttribute("flashcardHskLevel");
        if (currentHsk == null) currentHsk = 1;

        String sessionKey = "flashcardIndex_" + currentHsk;
        Integer currentIndex = (Integer) session.getAttribute(sessionKey);
        if (currentIndex == null) currentIndex = 0;

        String action = request.getParameter("action");

        if ("mark".equals(action)) {
            String wordIdParam = request.getParameter("wordId");
            String statusParam = request.getParameter("status"); // "mastered" hoặc "learning"

            if (user != null && wordIdParam != null && statusParam != null) {
                try {
                    int wordId = Integer.parseInt(wordIdParam);
                    boolean isCorrect = "mastered".equalsIgnoreCase(statusParam);
                    
                    // Cập nhật CSDL UserProgress
                    progressDAO.updateProgress(user.getUserId(), wordId, isCorrect);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }

            // Tăng vị trí từ tiếp theo trong Session của cấp HSK này
            session.setAttribute(sessionKey, currentIndex + 1);

        } else if ("reset".equals(action)) {
            // Đặt lại vị trí học về 0 và xóa tiến độ/từ đã thuộc của cấp HSK này trong CSDL
            session.setAttribute(sessionKey, 0);
            if (user != null) {
                progressDAO.resetProgressByHskLevel(user.getUserId(), currentHsk);
            }

        } else if ("prev".equals(action)) {
            // Quay lại từ phía trước
            if (currentIndex > 0) {
                session.setAttribute(sessionKey, currentIndex - 1);
            }
        }

        response.sendRedirect(request.getContextPath() + "/flashcard?hskLevel=" + currentHsk);
    }
}
