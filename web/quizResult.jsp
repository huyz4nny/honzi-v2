<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/common/header.jsp" />
<jsp:include page="/common/navbar.jsp" />

<div class="main-content py-10">
    <div class="container container-md">
        <!-- Score Summary Card -->
        <div class="card-plain mb-6 shadow-card" style="padding: 2rem;">
            <h2 class="text-ink fw-extrabold" style="font-size: 1.5rem;">Kết quả kiểm tra HSK ${hskLevel}</h2>
            
            <p class="mt-2 text-primary fw-extrabold" style="font-size: 3rem; line-height: 1;">
                ${score}/${totalQuestions}
            </p>
            
            <p class="mt-1 text-muted" style="font-size: 0.95rem;">
                <c:choose>
                    <c:when test="${score eq totalQuestions}">
                        Tuyệt đối xuất sắc! Bạn đã trả lời đúng toàn bộ câu hỏi.
                    </c:when>
                    <c:otherwise>
                        Đúng ${score} câu, sai ${totalQuestions - score} câu. Hãy tiếp tục ôn luyện để nâng cao phản xạ nhé.
                    </c:otherwise>
                </c:choose>
            </p>

            <div class="progress-container mt-4 mb-5" style="height: 0.65rem;">
                <div class="progress-bar-fill ${score >= 8 ? 'success' : ''}" style="width: ${percentage}%;"></div>
            </div>

            <!-- Action Buttons -->
            <div class="d-flex flex-wrap gap-3">
                <a href="${pageContext.request.contextPath}/quiz?hskLevel=${hskLevel}" class="btn btn-primary shadow-lift">
                    <i class="fa-solid fa-rotate-right me-1"></i> Làm lại
                </a>
                <a href="${pageContext.request.contextPath}/flashcard?hskLevel=${hskLevel}" class="btn btn-outline">
                    Ôn flashcard
                </a>
                <a href="${pageContext.request.contextPath}/progress" class="btn btn-outline">
                    Xem thống kê
                </a>
            </div>
        </div>

        <!-- Question Answer Review List -->
        <h3 class="text-ink fw-bold mb-4" style="font-size: 1.25rem;">
            Chi tiết các câu hỏi:
        </h3>

        <ul class="word-list-group">
            <c:forEach var="q" items="${questions}" varStatus="status">
                <c:set var="userAns" value="${userAnswers[status.index]}" />
                <c:set var="isCorrect" value="${userAns eq q.correctMeaning}" />

                <li class="word-list-item d-flex align-items-start gap-4">
                    <!-- Icon Trạng Thái -->
                    <div style="margin-top: 0.25rem;">
                        <c:choose>
                            <c:when test="${isCorrect}">
                                <span style="display: inline-flex; width: 2rem; height: 2rem; border-radius: 9999px; background-color: rgba(22, 163, 74, 0.12); color: var(--success); align-items: center; justify-content: center;">
                                    <i class="fa-solid fa-check"></i>
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span style="display: inline-flex; width: 2rem; height: 2rem; border-radius: 9999px; background-color: rgba(220, 38, 38, 0.12); color: var(--destructive); align-items: center; justify-content: center;">
                                    <i class="fa-solid fa-xmark"></i>
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Chữ Hán & Chi tiết -->
                    <div class="flex-1">
                        <div class="d-flex align-items-center gap-3">
                            <span class="font-hanzi text-ink" style="font-size: 1.75rem; font-weight: 700;">
                                ${q.hanzi}
                            </span>
                            <span class="text-primary fw-semibold" style="font-size: 1rem;">
                                ${q.pinyin}
                            </span>
                            <button type="button" class="btn-speaker ms-auto" onclick="speak('${q.hanzi}')" title="Phát âm">
                                <i class="fa-solid fa-volume-high"></i>
                            </button>
                        </div>

                        <div class="mt-2" style="font-size: 0.875rem;">
                            <div>
                                <span class="text-muted">Bạn chọn:</span> 
                                <span class="${isCorrect ? 'text-success fw-bold' : 'text-danger fw-semibold'}">
                                    ${empty userAns ? '(Chưa chọn)' : userAns}
                                </span>
                            </div>
                            <c:if test="${not isCorrect}">
                                <div class="mt-1">
                                    <span class="text-muted">Đáp án đúng:</span> 
                                    <span class="text-success fw-bold">${q.correctMeaning}</span>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </li>
            </c:forEach>
        </ul>
    </div>
</div>

<jsp:include page="/common/footer.jsp" />
