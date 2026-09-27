<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/common/header.jsp" />
<jsp:include page="/common/navbar.jsp" />

<div class="main-content py-10">
    <div class="container container-md">
        <!-- Header -->
        <h1 class="text-ink fw-extrabold tracking-tight" style="font-size: 1.875rem;">
            Kiểm tra HSK ${selectedHsk}
        </h1>
        <p class="mt-1 text-muted" style="font-size: 0.9rem;">
            10 câu trắc nghiệm chọn nghĩa đúng, có phát âm và chấm điểm chi tiết.
        </p>

        <!-- Level Picker Pills -->
        <div class="level-picker mt-4">
            <c:forEach var="lvl" begin="1" end="6">
                <a href="${pageContext.request.contextPath}/quiz?hskLevel=${lvl}" 
                   class="level-picker-pill ${selectedHsk eq lvl ? 'active' : ''}">
                    HSK ${lvl}
                </a>
            </c:forEach>
        </div>

        <c:choose>
            <c:when test="${not empty questions}">
                <form action="${pageContext.request.contextPath}/quiz/submit" method="post" class="mt-6">
                    <c:forEach var="q" items="${questions}" varStatus="status">
                        <div class="card-plain mb-6 shadow-card" style="padding: 1.75rem;">
                            <!-- Header Câu Hỏi -->
                            <div class="d-flex align-items-center justify-content-between mb-4">
                                <span class="badge badge-primary px-3 py-1 font-semibold">
                                    Câu ${status.index + 1} / ${questions.size()}
                                </span>
                                <button type="button" class="btn-speaker" onclick="speak('${q.hanzi}')" title="Nghe phát âm">
                                    <i class="fa-solid fa-volume-high" style="font-size: 1.1rem;"></i>
                                </button>
                            </div>

                            <!-- Chữ Hán & Pinyin -->
                            <div class="text-center py-4 rounded-2xl bg-secondary mb-5" style="border: 1px solid var(--border);">
                                <div class="font-hanzi text-ink" style="font-size: 4rem; line-height: 1.1;">
                                    ${q.hanzi}
                                </div>
                                <div class="text-primary fw-bold mt-2" style="font-size: 1.35rem;">
                                    ${q.pinyin}
                                </div>
                            </div>

                            <p class="text-muted fw-semibold mb-3" style="font-size: 0.9rem;">
                                Chọn nghĩa tiếng Việt đúng:
                            </p>

                            <!-- Danh Sách 4 Đáp Án -->
                            <div class="d-grid gap-2">
                                <c:forEach var="opt" items="${q.options}" varStatus="optStatus">
                                    <label class="quiz-option-btn d-flex align-items-center gap-3">
                                        <input type="radio" 
                                               name="q_${status.index}" 
                                               value="${opt}" 
                                               required 
                                               style="accent-color: var(--primary); width: 1.1rem; height: 1.1rem;" />
                                        <span class="fw-semibold">${opt}</span>
                                    </label>
                                </c:forEach>
                            </div>
                        </div>
                    </c:forEach>

                    <!-- Nút Nộp Bài -->
                    <div class="text-center my-6">
                        <button type="submit" class="btn btn-primary btn-lg px-8 shadow-lift">
                            <i class="fa-solid fa-paper-plane me-2"></i> Nộp bài kiểm tra
                        </button>
                    </div>
                </form>
            </c:when>

            <c:otherwise>
                <div class="card-plain text-center mt-6 p-10 shadow-card">
                    <p class="text-muted" style="font-size: 0.95rem;">
                        Cấp HSK ${selectedHsk} cần ít nhất 4 từ để tạo bài kiểm tra. Hãy thêm từ vựng mới hoặc đổi cấp HSK khác.
                    </p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="/common/footer.jsp" />
