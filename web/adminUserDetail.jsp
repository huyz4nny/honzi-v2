<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/common/header.jsp" />
<jsp:include page="/common/navbar.jsp" />

<div class="main-content py-10">
    <div class="container">
        <!-- Navigation Back & Title -->
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-6">
            <div>
                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-ghost btn-sm mb-2" style="padding-left: 0;">
                    <i class="fa-solid fa-arrow-left me-1"></i> Quay lại danh sách học viên
                </a>
                <h1 class="text-ink fw-extrabold tracking-tight" style="font-size: 1.875rem;">
                    Thống kê học tập: <span class="text-primary">${targetUser.username}</span>
                </h1>
                <p class="mt-1 text-muted" style="font-size: 0.9rem;">
                    Chi tiết tiến độ học từ vựng, cấp độ HSK và lịch sử kiểm tra trắc nghiệm.
                </p>
            </div>
            <div>
                <c:choose>
                    <c:when test="${targetUser.role eq 'ADMIN'}">
                        <span class="badge" style="background: rgba(235, 78, 43, 0.15); color: var(--primary); font-size: 0.85rem; padding: 0.5rem 0.85rem;">
                            <i class="fa-solid fa-shield-halved me-1"></i> Quản trị viên (ADMIN)
                        </span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge" style="background: rgba(100, 116, 139, 0.15); color: #475569; font-size: 0.85rem; padding: 0.5rem 0.85rem;">
                            <i class="fa-solid fa-user-graduate me-1"></i> Học viên (USER)
                        </span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Thẻ thông tin cá nhân & KPI tổng quan -->
        <div class="d-grid sm-grid-cols-2 lg-grid-cols-4 gap-4 mb-8">
            <div class="card-plain shadow-card">
                <p class="text-muted fw-medium" style="font-size: 0.85rem;">Thông tin tài khoản</p>
                <div class="mt-2">
                    <p class="text-ink fw-bold" style="font-size: 1.1rem; line-height: 1.2;">
                        ${targetUser.username}
                    </p>
                    <p class="text-muted mt-1 text-truncate" style="font-size: 0.8rem;" title="${targetUser.email}">
                        <i class="fa-regular fa-envelope me-1"></i> ${empty targetUser.email ? 'Chưa cập nhật' : targetUser.email}
                    </p>
                    <p class="text-muted mt-1" style="font-size: 0.75rem;">
                        Tham gia: <fmt:formatDate value="${targetUser.createdAt}" pattern="dd/MM/yyyy"/>
                    </p>
                </div>
            </div>

            <div class="card-plain shadow-card">
                <i class="fa-solid fa-graduation-cap text-primary" style="font-size: 1.25rem;"></i>
                <p class="mt-2 text-ink fw-extrabold" style="font-size: 1.75rem; line-height: 1;">
                    ${totalMastered} <span style="font-size: 0.9rem; font-weight: 500; color: var(--text-muted);">/ ${totalWordsLearned} từ</span>
                </p>
                <p class="text-muted mt-1" style="font-size: 0.85rem;">Từ đã thuộc (Mastered)</p>
            </div>

            <div class="card-plain shadow-card">
                <i class="fa-solid fa-book-open" style="font-size: 1.25rem; color: #d97706;"></i>
                <p class="mt-2 text-ink fw-extrabold" style="font-size: 1.75rem; line-height: 1;">
                    ${totalLearning} <span style="font-size: 0.9rem; font-weight: 500; color: var(--text-muted);">từ</span>
                </p>
                <p class="text-muted mt-1" style="font-size: 0.85rem;">Từ đang học (Learning)</p>
            </div>

            <div class="card-plain shadow-card">
                <i class="fa-solid fa-bullseye text-primary" style="font-size: 1.25rem;"></i>
                <p class="mt-2 text-ink fw-extrabold" style="font-size: 1.75rem; line-height: 1;">
                    <c:choose>
                        <c:when test="${not empty quizHistory}">
                            <fmt:formatNumber value="${avgQuizScore}" maxFractionDigits="1"/>%
                        </c:when>
                        <c:otherwise>0%</c:otherwise>
                    </c:choose>
                </p>
                <p class="text-muted mt-1" style="font-size: 0.85rem;">
                    Điểm TB (${quizHistory.size()} bài quiz)
                </p>
            </div>
        </div>

        <!-- 6 Thẻ Tiến độ phân bổ theo HSK 1 - 6 -->
        <div class="card-plain shadow-card mb-8">
            <h2 class="text-ink fw-bold mb-4" style="font-size: 1.15rem;">
                <i class="fa-solid fa-layer-group text-primary me-2"></i>Tiến độ theo cấp độ HSK
            </h2>
            <div class="d-grid sm-grid-cols-2 lg-grid-cols-6 gap-3">
                <c:forEach var="lvl" begin="1" end="6">
                    <c:set var="lvlStats" value="${summary[lvl]}" />
                    <c:set var="mastered" value="${empty lvlStats.Mastered ? 0 : lvlStats.Mastered}" />
                    <c:set var="total" value="${empty lvlStats.TotalWords ? 0 : lvlStats.TotalWords}" />
                    <c:set var="pct" value="${total > 0 ? (mastered * 100.0 / total) : 0}" />
                    
                    <div style="background: var(--bg-surface-subtle); padding: 1rem; border-radius: 8px; border: 1px solid var(--border-color);">
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <span class="fw-bold text-ink" style="font-size: 0.95rem;">HSK ${lvl}</span>
                            <span class="fw-semibold text-muted" style="font-size: 0.8rem;">
                                <fmt:formatNumber value="${pct}" maxFractionDigits="0"/>%
                            </span>
                        </div>
                        <div class="progress-bar-container" style="height: 6px; background: rgba(0,0,0,0.06); border-radius: 9999px; overflow: hidden; margin-bottom: 0.5rem;">
                            <div class="progress-bar-fill" style="width: ${pct}%; height: 100%; background: var(--primary); border-radius: 9999px;"></div>
                        </div>
                        <div class="d-flex justify-content-between text-muted" style="font-size: 0.75rem;">
                            <span>Đã thuộc: <b class="text-ink">${mastered}</b></span>
                            <span>Tổng: ${total}</span>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Tabs Chuyển đổi: Danh sách từ vựng vs Lịch sử Quiz -->
        <div class="card-plain shadow-card p-0" style="overflow: hidden;">
            <div class="d-flex border-bottom" style="background: var(--bg-surface-subtle);">
                <button type="button" 
                        class="tab-btn px-6 py-4 border-none fw-bold" 
                        id="tabWordsBtn"
                        onclick="switchTab('tabWords', 'tabQuiz', this)"
                        style="background: transparent; color: var(--primary); border-bottom: 2px solid var(--primary); cursor: pointer; font-size: 0.95rem;">
                    <i class="fa-solid fa-list me-2"></i>Danh sách từ vựng đã học (${userProgressList.size()})
                </button>
                <button type="button" 
                        class="tab-btn px-6 py-4 border-none fw-bold" 
                        id="tabQuizBtn"
                        onclick="switchTab('tabQuiz', 'tabWords', this)"
                        style="background: transparent; color: var(--text-muted); cursor: pointer; font-size: 0.95rem;">
                    <i class="fa-solid fa-clock-rotate-left me-2"></i>Lịch sử kiểm tra Quiz (${quizHistory.size()})
                </button>
            </div>

            <!-- Tab Content 1: Danh sách từ vựng -->
            <div id="tabWords" class="tab-pane p-4">
                <c:choose>
                    <c:when test="${empty userProgressList}">
                        <div class="text-center py-8 text-muted">
                            <i class="fa-regular fa-clone mb-2" style="font-size: 2rem; display: block;"></i>
                            Học viên này chưa bắt đầu học từ vựng nào.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="overflow-x: auto;">
                            <table class="table w-full" style="margin-bottom: 0;">
                                <thead>
                                    <tr style="background: var(--bg-surface-subtle); border-bottom: 1px solid var(--border-color);">
                                        <th class="py-3 px-3 text-start font-medium text-muted" style="font-size: 0.8rem;">CHỮ HÁN & PHÁT ÂM</th>
                                        <th class="py-3 px-3 text-start font-medium text-muted" style="font-size: 0.8rem;">PINYIN</th>
                                        <th class="py-3 px-3 text-start font-medium text-muted" style="font-size: 0.8rem;">Ý NGHĨA</th>
                                        <th class="py-3 px-3 text-center font-medium text-muted" style="font-size: 0.8rem;">CẤP ĐỘ</th>
                                        <th class="py-3 px-3 text-center font-medium text-muted" style="font-size: 0.8rem;">TRẠNG THÁI</th>
                                        <th class="py-3 px-3 text-center font-medium text-muted" style="font-size: 0.8rem;">ĐÚNG / SAI</th>
                                        <th class="py-3 px-3 text-end font-medium text-muted" style="font-size: 0.8rem;">LẦN ÔN CUỐI</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="p" items="${userProgressList}">
                                        <tr style="border-bottom: 1px solid var(--border-color);">
                                            <td class="py-3 px-3">
                                                <div class="d-flex align-items-center gap-2">
                                                    <span class="fw-bold text-ink" style="font-size: 1.25rem;">${p.word.hanzi}</span>
                                                    <!-- Web Speech API speaker button -->
                                                    <button type="button" 
                                                            class="btn-speaker" 
                                                            onclick="speak('${p.word.hanzi}')" 
                                                            title="Nghe phát âm">
                                                        <i class="fa-solid fa-volume-high"></i>
                                                    </button>
                                                </div>
                                            </td>
                                            <td class="py-3 px-3 text-primary fw-medium" style="font-size: 0.95rem;">
                                                ${p.word.pinyin}
                                            </td>
                                            <td class="py-3 px-3 text-ink" style="font-size: 0.9rem;">
                                                ${p.word.meaningVi}
                                            </td>
                                            <td class="py-3 px-3 text-center">
                                                <span class="badge" style="background: rgba(235, 78, 43, 0.1); color: var(--primary); font-weight: 600;">
                                                    HSK ${p.word.hskLevel}
                                                </span>
                                            </td>
                                            <td class="py-3 px-3 text-center">
                                                <c:choose>
                                                    <c:when test="${p.status eq 'Mastered'}">
                                                        <span class="badge" style="background: rgba(46, 117, 89, 0.15); color: #2e7559; font-weight: 600;">
                                                            <i class="fa-solid fa-check me-1"></i> Đã thuộc
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge" style="background: rgba(245, 158, 11, 0.15); color: #d97706; font-weight: 600;">
                                                            <i class="fa-solid fa-spinner me-1"></i> Đang học
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="py-3 px-3 text-center font-medium" style="font-size: 0.85rem;">
                                                <span class="text-success fw-bold">${p.correctCount}</span> / 
                                                <span class="text-danger fw-bold">${p.wrongCount}</span>
                                            </td>
                                            <td class="py-3 px-3 text-end text-muted" style="font-size: 0.8rem;">
                                                <fmt:formatDate value="${p.lastReviewedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Tab Content 2: Lịch sử Quiz -->
            <div id="tabQuiz" class="tab-pane p-4" style="display: none;">
                <c:choose>
                    <c:when test="${empty quizHistory}">
                        <div class="text-center py-8 text-muted">
                            <i class="fa-regular fa-hourglass mb-2" style="font-size: 2rem; display: block;"></i>
                            Học viên này chưa thực hiện bài kiểm tra trắc nghiệm nào.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="overflow-x: auto;">
                            <table class="table w-full" style="margin-bottom: 0;">
                                <thead>
                                    <tr style="background: var(--bg-surface-subtle); border-bottom: 1px solid var(--border-color);">
                                        <th class="py-3 px-4 text-start font-medium text-muted" style="font-size: 0.8rem;">BÀI QUIZ</th>
                                        <th class="py-3 px-4 text-center font-medium text-muted" style="font-size: 0.8rem;">CẤP ĐỘ</th>
                                        <th class="py-3 px-4 text-center font-medium text-muted" style="font-size: 0.8rem;">ĐIỂM SỐ</th>
                                        <th class="py-3 px-4 text-center font-medium text-muted" style="font-size: 0.8rem;">TỶ LỆ CHÍNH XÁC</th>
                                        <th class="py-3 px-4 text-center font-medium text-muted" style="font-size: 0.8rem;">ĐÁNH GIÁ</th>
                                        <th class="py-3 px-4 text-end font-medium text-muted" style="font-size: 0.8rem;">THỜI GIAN LÀM</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="q" items="${quizHistory}">
                                        <c:set var="pct" value="${q.totalQuestions > 0 ? (q.score * 100.0 / q.totalQuestions) : 0}" />
                                        <tr style="border-bottom: 1px solid var(--border-color);">
                                            <td class="py-3 px-4 fw-semibold text-ink" style="font-size: 0.9rem;">
                                                #${q.quizId} - Trắc nghiệm HSK ${q.hskLevel}
                                            </td>
                                            <td class="py-3 px-4 text-center">
                                                <span class="badge" style="background: rgba(235, 78, 43, 0.1); color: var(--primary); font-weight: 600;">
                                                    HSK ${q.hskLevel}
                                                </span>
                                            </td>
                                            <td class="py-3 px-4 text-center fw-extrabold text-ink" style="font-size: 1rem;">
                                                ${q.score} / ${q.totalQuestions}
                                            </td>
                                            <td class="py-3 px-4 text-center">
                                                <span class="fw-bold ${pct >= 80 ? 'text-success' : (pct >= 50 ? 'text-primary' : 'text-danger')}" style="font-size: 0.95rem;">
                                                    <fmt:formatNumber value="${pct}" maxFractionDigits="0"/>%
                                                </span>
                                            </td>
                                            <td class="py-3 px-4 text-center">
                                                <c:choose>
                                                    <c:when test="${pct >= 80}">
                                                        <span class="badge" style="background: rgba(46, 117, 89, 0.15); color: #2e7559; font-weight: 600;">
                                                            Xuất sắc
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${pct >= 60}">
                                                        <span class="badge" style="background: rgba(59, 130, 246, 0.15); color: #2563eb; font-weight: 600;">
                                                            Đạt
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge" style="background: rgba(220, 38, 38, 0.15); color: #dc2626; font-weight: 600;">
                                                            Cần cố gắng
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="py-3 px-4 text-end text-muted" style="font-size: 0.85rem;">
                                                <fmt:formatDate value="${q.takenAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<script>
function switchTab(showId, hideId, activeBtn) {
    document.getElementById(showId).style.display = 'block';
    document.getElementById(hideId).style.display = 'none';

    document.getElementById('tabWordsBtn').style.color = 'var(--text-muted)';
    document.getElementById('tabWordsBtn').style.borderBottom = 'none';
    document.getElementById('tabQuizBtn').style.color = 'var(--text-muted)';
    document.getElementById('tabQuizBtn').style.borderBottom = 'none';

    activeBtn.style.color = 'var(--primary)';
    activeBtn.style.borderBottom = '2px solid var(--primary)';
}
</script>

<jsp:include page="/common/footer.jsp" />
