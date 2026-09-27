<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/common/header.jsp" />
<jsp:include page="/common/navbar.jsp" />

<div class="main-content py-10">
    <div class="container">
        <!-- Title & Subtitle -->
        <h1 class="text-ink fw-extrabold tracking-tight" style="font-size: 1.875rem;">
            Thống kê của bạn
        </h1>
        <p class="mt-1 text-muted" style="font-size: 0.9rem;">
            Theo dõi từ đã thuộc theo từng cấp HSK, streak học tập và lịch sử thi trắc nghiệm.
        </p>

        <!-- Tính toán tổng số từ đã thuộc -->
        <c:set var="totalMastered" value="0" />
        <c:set var="totalAllWords" value="0" />
        <c:forEach var="lvl" begin="1" end="6">
            <c:set var="lvlStats" value="${summary[lvl]}" />
            <c:set var="m" value="${empty lvlStats.Mastered ? 0 : lvlStats.Mastered}" />
            <c:set var="t" value="${empty lvlStats.TotalWords ? 0 : lvlStats.TotalWords}" />
            <c:set var="totalMastered" value="${totalMastered + m}" />
            <c:set var="totalAllWords" value="${totalAllWords + t}" />
        </c:forEach>

        <!-- 3 Highlight Metric Cards -->
        <div class="d-grid sm-grid-cols-3 gap-4 mt-6">
            <div class="card-plain shadow-card">
                <i class="fa-solid fa-fire text-primary" style="font-size: 1.25rem;"></i>
                <p class="mt-3 text-ink fw-extrabold" style="font-size: 1.75rem; line-height: 1;">
                    ${empty userProgressList ? 0 : 1} ngày
                </p>
                <p class="text-muted mt-1" style="font-size: 0.875rem;">Streak hiện tại</p>
            </div>

            <div class="card-plain shadow-card">
                <i class="fa-solid fa-graduation-cap text-primary" style="font-size: 1.25rem;"></i>
                <p class="mt-3 text-ink fw-extrabold" style="font-size: 1.75rem; line-height: 1;">
                    ${totalMastered} từ
                </p>
                <p class="text-muted mt-1" style="font-size: 0.875rem;">Từ đã thuộc</p>
            </div>

            <div class="card-plain shadow-card">
                <i class="fa-solid fa-bullseye text-primary" style="font-size: 1.25rem;"></i>
                <p class="mt-3 text-ink fw-extrabold" style="font-size: 1.75rem; line-height: 1;">
                    <c:choose>
                        <c:when test="${not empty quizHistory}">
                            <fmt:formatNumber value="${quizHistory[0].percentage}" maxFractionDigits="0"/>%
                        </c:when>
                        <c:otherwise>100%</c:otherwise>
                    </c:choose>
                </p>
                <p class="text-muted mt-1" style="font-size: 0.875rem;">Độ chính xác gần nhất</p>
            </div>
        </div>

        <!-- 6 HSK Breakdown Cards -->
        <div class="card-plain shadow-card mt-6">
            <h2 class="text-ink fw-bold mb-4" style="font-size: 1.15rem;">Tiến độ theo cấp độ HSK</h2>
            
            <div class="d-grid sm-grid-cols-2 lg-grid-cols-6 gap-3">
                <c:forEach var="lvl" begin="1" end="6">
                    <c:set var="lvlStats" value="${summary[lvl]}" />
                    <c:set var="mastered" value="${empty lvlStats.Mastered ? 0 : lvlStats.Mastered}" />
                    <c:set var="total" value="${empty lvlStats.TotalWords ? 0 : lvlStats.TotalWords}" />
                    <c:set var="pct" value="${total > 0 ? (mastered * 100.0 / total) : 0}" />

                    <div class="p-4 rounded-xl bg-secondary text-center">
                        <span class="badge badge-primary mb-2">HSK ${lvl}</span>
                        <div class="text-ink fw-extrabold" style="font-size: 1.25rem;">
                            ${mastered} / ${total}
                        </div>
                        <p class="text-muted" style="font-size: 0.75rem; margin-bottom: 0.5rem;">từ đã thuộc</p>
                        
                        <div class="progress-container" style="height: 5px;">
                            <div class="progress-bar-fill success" style="width: ${pct}%;"></div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Tabs Container -->
        <div class="card-plain shadow-card mt-6">
            <div class="tab-header">
                <button type="button" class="tab-btn active" data-tab-target="tabWords">
                    <i class="fa-solid fa-list-check me-1"></i> Danh sách từ đã học (${userProgressList.size()})
                </button>
                <button type="button" class="tab-btn" data-tab-target="tabQuiz">
                    <i class="fa-solid fa-clock-rotate-left me-1"></i> Lịch sử kiểm tra Quiz (${quizHistory.size()})
                </button>
            </div>

            <!-- Tab 1: Danh Sách Từ -->
            <div class="tab-content-panel active" id="tabWords">
                <div class="table-wrapper" style="border: none; box-shadow: none;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Hán tự</th>
                                <th>Pinyin</th>
                                <th>Nghĩa Tiếng Việt</th>
                                <th class="text-center">Cấp độ</th>
                                <th class="text-center">Trạng thái</th>
                                <th class="text-center">Đúng / Sai</th>
                                <th class="text-end">Ôn gần nhất</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty userProgressList}">
                                    <c:forEach var="p" items="${userProgressList}">
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center gap-2">
                                                    <span class="font-hanzi text-ink" style="font-size: 1.35rem; font-weight: 700;">
                                                        ${p.word.hanzi}
                                                    </span>
                                                    <button type="button" class="btn-speaker" onclick="speak('${p.word.hanzi}')" title="Phát âm">
                                                        <i class="fa-solid fa-volume-high" style="font-size: 0.85rem;"></i>
                                                    </button>
                                                </div>
                                            </td>
                                            <td class="text-primary fw-semibold">${p.word.pinyin}</td>
                                            <td class="fw-semibold text-ink">${p.word.meaningVi}</td>
                                            <td class="text-center">
                                                <span class="badge badge-secondary">HSK ${p.word.hskLevel}</span>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${p.status eq 'Mastered'}">
                                                        <span class="badge badge-success">
                                                            <i class="fa-solid fa-circle-check me-1"></i> Đã thuộc
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-warning">
                                                            <i class="fa-solid fa-spinner me-1"></i> Đang học
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center fw-semibold">
                                                <span class="text-success">${p.correctCount}</span> / <span class="text-danger">${p.wrongCount}</span>
                                            </td>
                                            <td class="text-end text-muted" style="font-size: 0.8rem;">
                                                <fmt:formatDate value="${p.lastReviewedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" class="text-center py-8 text-muted">
                                            Bạn chưa học từ vựng nào. Hãy vào 
                                            <a href="${pageContext.request.contextPath}/flashcard" class="fw-bold text-primary">Flashcard</a> 
                                            để bắt đầu học!
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Tab 2: Lịch Sử Quiz -->
            <div class="tab-content-panel" id="tabQuiz">
                <div class="table-wrapper" style="border: none; box-shadow: none;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Mã Bài Thi</th>
                                <th class="text-center">Cấp Độ</th>
                                <th class="text-center">Kết Quả</th>
                                <th class="text-center">Tỷ Lệ</th>
                                <th class="text-end">Thời Gian Làm Bài</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty quizHistory}">
                                    <c:forEach var="q" items="${quizHistory}">
                                        <tr>
                                            <td class="fw-semibold text-muted">#QZ-${q.quizId}</td>
                                            <td class="text-center">
                                                <span class="badge badge-secondary">HSK ${q.hskLevel}</span>
                                            </td>
                                            <td class="text-center fw-bold" style="font-size: 1rem;">
                                                <span class="${q.score >= 8 ? 'text-success' : (q.score >= 5 ? 'text-warning' : 'text-danger')}">
                                                    ${q.score}
                                                </span> / ${q.totalQuestions}
                                            </td>
                                            <td class="text-center">
                                                <span class="badge ${q.percentage >= 80 ? 'badge-success' : (q.percentage >= 50 ? 'badge-warning' : 'badge-danger')}">
                                                    <fmt:formatNumber value="${q.percentage}" maxFractionDigits="0"/>%
                                                </span>
                                            </td>
                                            <td class="text-end text-muted" style="font-size: 0.8rem;">
                                                <fmt:formatDate value="${q.takenAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="5" class="text-center py-8 text-muted">
                                            Chưa có lịch sử làm bài thi. Hãy thử sức với bài 
                                            <a href="${pageContext.request.contextPath}/quiz" class="fw-bold text-primary">Kiểm Tra Quiz</a>!
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/common/footer.jsp" />
