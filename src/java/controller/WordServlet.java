package controller;

import dao.WordDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.ImportResultDTO;
import model.User;
import model.Word;
import util.ExcelUtil;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "WordServlet", urlPatterns = {"/words", "/words/add", "/words/edit", "/words/delete", "/words/import"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 20    // 20MB
)
public class WordServlet extends HttpServlet {

    private WordDAO wordDAO;

    @Override
    public void init() throws ServletException {
        wordDAO = new WordDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getServletPath();

        try {
            switch (action) {
                case "/words/add":
                    showAddForm(request, response);
                    break;
                case "/words/edit":
                    showEditForm(request, response);
                    break;
                case "/words/delete":
                    deleteWord(request, response);
                    break;
                case "/words/import":
                    showImportForm(request, response);
                    break;
                case "/words":
                default:
                    listWords(request, response);
                    break;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi hệ thống: " + ex.getMessage());
            request.getRequestDispatcher("/wordList.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getServletPath();

        try {
            switch (action) {
                case "/words/add":
                    insertWord(request, response);
                    break;
                case "/words/edit":
                    updateWord(request, response);
                    break;
                case "/words/delete":
                    deleteWord(request, response);
                    break;
                case "/words/import":
                    handleImportWords(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/words");
                    break;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi xử lý dữ liệu: " + ex.getMessage());
            listWords(request, response);
        }
    }

    private void showImportForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        request.getRequestDispatcher("/wordImport.jsp").forward(request, response);
    }

    private void handleImportWords(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String duplicateMode = request.getParameter("duplicateMode");
        boolean updateIfExists = "update".equalsIgnoreCase(duplicateMode);

        List<Word> wordsToImport = new ArrayList<>();
        String importSource = "";

        try {
            Part filePart = request.getPart("file");
            if (filePart != null && filePart.getSize() > 0) {
                String submittedFileName = filePart.getSubmittedFileName();
                try (InputStream is = filePart.getInputStream()) {
                    wordsToImport = ExcelUtil.parseFile(is, submittedFileName);
                    importSource = "Tệp Excel: " + submittedFileName;
                }
            } else {
                String pastedText = request.getParameter("pastedText");
                if (pastedText != null && !pastedText.trim().isEmpty()) {
                    wordsToImport = ExcelUtil.parsePastedText(pastedText);
                    importSource = "Dữ liệu dán trực tiếp từ bảng tính";
                }
            }

            if (wordsToImport.isEmpty()) {
                request.setAttribute("errorMessage", "Không tìm thấy dữ liệu từ vựng hợp lệ. Vui lòng kiểm tra lại file hoặc định dạng nhập!");
                request.getRequestDispatcher("/wordImport.jsp").forward(request, response);
                return;
            }

            ImportResultDTO result = wordDAO.insertOrUpdateBatchWords(wordsToImport, updateIfExists);
            request.setAttribute("importResult", result);
            request.setAttribute("importSource", importSource);
            request.setAttribute("successMessage", "Xử lý thành công tổng cộng " + result.getTotalRows() + " từ vựng!");
            request.getRequestDispatcher("/wordImport.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi đọc tệp Excel: " + e.getMessage());
            request.getRequestDispatcher("/wordImport.jsp").forward(request, response);
        }
    }

    private void listWords(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int page = 1;
        int pageSize = 8;

        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        Integer hskLevel = null;
        String hskParam = request.getParameter("hskLevel");
        if (hskParam != null && !hskParam.trim().isEmpty()) {
            try {
                hskLevel = Integer.parseInt(hskParam);
                if (hskLevel <= 0) hskLevel = null;
            } catch (NumberFormatException e) {
                hskLevel = null;
            }
        }

        String searchKeyword = request.getParameter("search");
        if (searchKeyword != null) {
            searchKeyword = searchKeyword.trim();
        }

        List<Word> wordList = wordDAO.getAllWords(page, pageSize, hskLevel, searchKeyword);
        int totalWords = wordDAO.getTotalWordsCount(hskLevel, searchKeyword);
        int totalPages = (int) Math.ceil((double) totalWords / pageSize);
        if (totalPages == 0) totalPages = 1;

        request.setAttribute("wordList", wordList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalWords", totalWords);
        request.setAttribute("selectedHsk", hskLevel);
        request.setAttribute("searchKeyword", searchKeyword);

        request.getRequestDispatcher("/wordList.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("action", "add");
        request.getRequestDispatcher("/wordForm.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/words");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            Word word = wordDAO.getWordById(id);
            if (word == null) {
                request.setAttribute("errorMessage", "Không tìm thấy từ vựng ID: " + id);
                listWords(request, response);
                return;
            }
            request.setAttribute("word", word);
            request.setAttribute("action", "edit");
            request.getRequestDispatcher("/wordForm.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/words");
        }
    }

    private void insertWord(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String hanzi = request.getParameter("hanzi");
        String pinyin = request.getParameter("pinyin");
        String meaningVi = request.getParameter("meaningVi");
        String hskParam = request.getParameter("hskLevel");
        String topic = request.getParameter("topic");
        String exampleSentence = request.getParameter("exampleSentence");
        String exampleMeaningVi = request.getParameter("exampleMeaningVi");
        String audioUrl = request.getParameter("audioUrl");

        // Validate server side
        if (isNullOrEmpty(hanzi) || isNullOrEmpty(pinyin) || isNullOrEmpty(meaningVi) || isNullOrEmpty(hskParam)) {
            request.setAttribute("errorMessage", "Vui lòng điền đầy đủ các trường bắt buộc (Hán tự, Pinyin, Nghĩa, HSK Level).");
            request.setAttribute("word", new Word(0, hanzi, pinyin, meaningVi, parseHsk(hskParam), topic, exampleSentence, exampleMeaningVi, audioUrl));
            request.setAttribute("action", "add");
            request.getRequestDispatcher("/wordForm.jsp").forward(request, response);
            return;
        }

        int hskLevel = parseHsk(hskParam);
        Word word = new Word(hanzi.trim(), pinyin.trim(), meaningVi.trim(), hskLevel,
                isNullOrEmpty(topic) ? "Từ vựng chung" : topic.trim(),
                exampleSentence != null ? exampleSentence.trim() : "",
                exampleMeaningVi != null ? exampleMeaningVi.trim() : "",
                audioUrl != null ? audioUrl.trim() : "");

        boolean success = wordDAO.insertWord(word);
        if (success) {
            request.getSession().setAttribute("successMessage", "Thêm từ vựng mới '" + word.getHanzi() + "' thành công!");
            response.sendRedirect(request.getContextPath() + "/words");
        } else {
            request.setAttribute("errorMessage", "Không thể thêm từ vựng vào CSDL. Vui lòng thử lại!");
            request.setAttribute("word", word);
            request.setAttribute("action", "add");
            request.getRequestDispatcher("/wordForm.jsp").forward(request, response);
        }
    }

    private void updateWord(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        String hanzi = request.getParameter("hanzi");
        String pinyin = request.getParameter("pinyin");
        String meaningVi = request.getParameter("meaningVi");
        String hskParam = request.getParameter("hskLevel");
        String topic = request.getParameter("topic");
        String exampleSentence = request.getParameter("exampleSentence");
        String exampleMeaningVi = request.getParameter("exampleMeaningVi");
        String audioUrl = request.getParameter("audioUrl");

        if (isNullOrEmpty(idParam) || isNullOrEmpty(hanzi) || isNullOrEmpty(pinyin) || isNullOrEmpty(meaningVi) || isNullOrEmpty(hskParam)) {
            request.setAttribute("errorMessage", "Vui lòng điền đầy đủ các trường dữ liệu bắt buộc.");
            Word w = new Word(parseId(idParam), hanzi, pinyin, meaningVi, parseHsk(hskParam), topic, exampleSentence, exampleMeaningVi, audioUrl);
            request.setAttribute("word", w);
            request.setAttribute("action", "edit");
            request.getRequestDispatcher("/wordForm.jsp").forward(request, response);
            return;
        }

        int id = parseId(idParam);
        int hskLevel = parseHsk(hskParam);

        Word word = new Word(id, hanzi.trim(), pinyin.trim(), meaningVi.trim(), hskLevel,
                isNullOrEmpty(topic) ? "Từ vựng chung" : topic.trim(),
                exampleSentence != null ? exampleSentence.trim() : "",
                exampleMeaningVi != null ? exampleMeaningVi.trim() : "",
                audioUrl != null ? audioUrl.trim() : "");

        boolean success = wordDAO.updateWord(word);
        if (success) {
            request.getSession().setAttribute("successMessage", "Cập nhật từ vựng '" + word.getHanzi() + "' thành công!");
            response.sendRedirect(request.getContextPath() + "/words");
        } else {
            request.setAttribute("errorMessage", "Cập nhật thất bại. Vui lòng kiểm tra lại CSDL.");
            request.setAttribute("word", word);
            request.setAttribute("action", "edit");
            request.getRequestDispatcher("/wordForm.jsp").forward(request, response);
        }
    }

    private void deleteWord(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idParam);
                Word word = wordDAO.getWordById(id);
                boolean success = wordDAO.deleteWord(id);
                if (success) {
                    request.getSession().setAttribute("successMessage", "Đã xóa từ vựng thành công!");
                } else {
                    request.getSession().setAttribute("errorMessage", "Xóa từ vựng không thành công.");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage", "ID từ vựng không hợp lệ.");
            }
        }
        response.sendRedirect(request.getContextPath() + "/words");
    }

    private boolean isNullOrEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

    private int parseHsk(String hskParam) {
        try {
            int hsk = Integer.parseInt(hskParam);
            return (hsk >= 1 && hsk <= 6) ? hsk : 1;
        } catch (NumberFormatException e) {
            return 1;
        }
    }

    private int parseId(String idParam) {
        try {
            return Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            return 0;
        }
    }
}
