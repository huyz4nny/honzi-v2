package controller;

import dao.QuizDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.QuizResult;
import model.User;
import model.Word;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@WebServlet(name = "QuizServlet", urlPatterns = {"/quiz", "/quiz/submit"})
public class QuizServlet extends HttpServlet {

    private QuizDAO quizDAO;

    @Override
    public void init() throws ServletException {
        quizDAO = new QuizDAO();
    }

    public static class QuizQuestion {
        private int wordId;
        private String hanzi;
        private String pinyin;
        private String correctMeaning;
        private List<String> options;

        public QuizQuestion(int wordId, String hanzi, String pinyin, String correctMeaning, List<String> options) {
            this.wordId = wordId;
            this.hanzi = hanzi;
            this.pinyin = pinyin;
            this.correctMeaning = correctMeaning;
            this.options = options;
        }

        public int getWordId() { return wordId; }
        public String getHanzi() { return hanzi; }
        public String getPinyin() { return pinyin; }
        public String getCorrectMeaning() { return correctMeaning; }
        public List<String> getOptions() { return options; }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int hskLevel = 1;
        String hskParam = request.getParameter("hskLevel");
        if (hskParam != null && !hskParam.trim().isEmpty()) {
            try {
                hskLevel = Integer.parseInt(hskParam);
                if (hskLevel < 1 || hskLevel > 6) hskLevel = 1;
            } catch (NumberFormatException e) {
                hskLevel = 1;
            }
        }

        List<Word> words = quizDAO.getRandomWordsForQuiz(hskLevel, 10);
        List<QuizQuestion> questions = new ArrayList<>();

        for (Word w : words) {
            List<String> options = new ArrayList<>();
            options.add(w.getMeaningVi());
            List<String> distractors = quizDAO.getRandomMeaningsExcept(w.getWordId(), 3);
            options.addAll(distractors);
            
            // Xáo trộn ngẫu nhiên thứ tự 4 đáp án A, B, C, D
            Collections.shuffle(options);
            
            questions.add(new QuizQuestion(w.getWordId(), w.getHanzi(), w.getPinyin(), w.getMeaningVi(), options));
        }

        HttpSession session = request.getSession();
        session.setAttribute("quizQuestions", questions);
        session.setAttribute("quizHskLevel", hskLevel);

        request.setAttribute("questions", questions);
        request.setAttribute("selectedHsk", hskLevel);
        request.getRequestDispatcher("/quiz.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        List<QuizQuestion> questions = (List<QuizQuestion>) session.getAttribute("quizQuestions");
        Integer hskLevel = (Integer) session.getAttribute("quizHskLevel");
        User user = (User) session.getAttribute("user");

        if (questions == null || hskLevel == null) {
            response.sendRedirect(request.getContextPath() + "/quiz");
            return;
        }

        int score = 0;
        int totalQuestions = questions.size();
        List<String> userAnswers = new ArrayList<>();

        for (int i = 0; i < totalQuestions; i++) {
            String selectedOption = request.getParameter("q_" + i);
            userAnswers.add(selectedOption);

            QuizQuestion q = questions.get(i);
            if (selectedOption != null && selectedOption.trim().equalsIgnoreCase(q.getCorrectMeaning().trim())) {
                score++;
            }
        }

        if (user != null) {
            QuizResult result = new QuizResult(user.getUserId(), hskLevel, score, totalQuestions);
            quizDAO.saveQuizResult(result);
        }

        request.setAttribute("score", score);
        request.setAttribute("totalQuestions", totalQuestions);
        request.setAttribute("percentage", (double) score / totalQuestions * 100);
        request.setAttribute("questions", questions);
        request.setAttribute("userAnswers", userAnswers);
        request.setAttribute("hskLevel", hskLevel);

        request.getRequestDispatcher("/quizResult.jsp").forward(request, response);
    }
}
