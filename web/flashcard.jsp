<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/common/header.jsp" />
<jsp:include page="/common/navbar.jsp" />

<div class="main-content py-10">
    <div class="container container-md">
        <!-- Title & Action Header -->
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">
            <div>
                <h1 class="text-ink fw-extrabold tracking-tight" style="font-size: 1.875rem;">
                    Flashcard HSK ${selectedHsk}
                </h1>
                <p class="text-muted mt-1" style="font-size: 0.875rem;">
                    Tiến độ học được lưu tự động theo từng cấp độ HSK.
                </p>
            </div>
            <div class="d-flex flex-wrap gap-2">
                <a href="${pageContext.request.contextPath}/flashcard?reset=true&hskLevel=${selectedHsk}" 
                   class="btn btn-outline btn-sm" 
                   title="Học lại từ thẻ đầu tiên của HSK ${selectedHsk}">
                    <i class="fa-solid fa-rotate-left me-1"></i> Học lại từ đầu
                </a>
                <a href="${pageContext.request.contextPath}/quiz?hskLevel=${selectedHsk}" class="btn btn-outline btn-sm">
                    Kiểm tra ngay
                </a>
            </div>
        </div>

        <!-- Level Picker Pills -->
        <div class="level-picker mt-4">
            <c:forEach var="lvl" begin="1" end="6">
                <a href="${pageContext.request.contextPath}/flashcard?hskLevel=${lvl}" 
                   class="level-picker-pill ${selectedHsk eq lvl ? 'active' : ''}">
                    HSK ${lvl}
                </a>
            </c:forEach>
        </div>

        <!-- Guest Notice -->
        <c:if test="${empty sessionScope.user}">
            <div class="alert-box alert-info mt-4">
                <i class="fa-solid fa-circle-info text-primary"></i>
                <div>
                    Bạn đang học ở chế độ khách. 
                    <a href="${pageContext.request.contextPath}/login" class="fw-bold text-primary">Đăng nhập</a> 
                    để lưu tiến độ và lịch ôn tập vào tài khoản.
                </div>
            </div>
        </c:if>

        <c:choose>
            <c:when test="${not empty isCompleted and isCompleted}">
                <!-- Màn Hình Hoàn Thành Vòng Học -->
                <div class="card-plain text-center mt-6 shadow-card" style="padding: 3rem 2rem;">
                    <div style="display: inline-flex; width: 4rem; height: 4rem; border-radius: 9999px; background-color: rgba(22, 163, 74, 0.12); color: var(--success); align-items: center; justify-content: center; font-size: 2rem; margin-bottom: 1rem;">
                        <i class="fa-solid fa-trophy"></i>
                    </div>
                    <h2 class="text-ink fw-extrabold" style="font-size: 1.5rem;">Chúc Mừng Bạn!</h2>
                    <p class="text-muted mt-2 mb-6" style="max-width: 400px; margin-left: auto; margin-right: auto;">
                        Bạn đã hoàn thành lượt học toàn bộ <strong>${totalWords}</strong> từ vựng cấp độ <strong>HSK ${selectedHsk}</strong>.
                    </p>
                    
                    <div class="d-flex justify-content-center flex-wrap gap-3">
                        <a href="${pageContext.request.contextPath}/flashcard?reset=true&hskLevel=${selectedHsk}" class="btn btn-outline btn-lg">
                            <i class="fa-solid fa-rotate-left me-2"></i> Học lại từ đầu
                        </a>
                        <a href="${pageContext.request.contextPath}/progress" class="btn btn-primary btn-lg shadow-lift">
                            <i class="fa-solid fa-chart-line me-2"></i> Xem thống kê
                        </a>
                    </div>
                </div>
            </c:when>

            <c:when test="${not empty currentWord}">
                <!-- Thanh Tiến Độ Lần Học -->
                <div class="d-flex align-items-center gap-3 mt-6">
                    <div class="progress-container flex-1">
                        <div class="progress-bar-fill" style="width: ${(currentIndex + 1) * 100.0 / totalWords}%;"></div>
                    </div>
                    <span class="text-muted fw-semibold" style="font-size: 0.875rem;">
                        ${currentIndex + 1}/${totalWords}
                    </span>
                </div>

                <!-- Thẻ Flashcard Lật 3D (3D Flip Card) -->
                <div class="card-3d mt-6">
                    <div class="card-flipper" id="flashcardFlipper" onclick="toggleCardFlip(this)" role="button" aria-label="Lật thẻ">
                        <!-- Mặt Trước (Front Face) -->
                        <div class="card-face">
                            <span class="card-hanzi-text font-hanzi">${currentWord.hanzi}</span>
                            <span class="mt-6 uppercase tracking-widest text-muted" style="font-size: 0.75rem; font-weight: 600;">
                                <i class="fa-solid fa-hand-pointer me-1"></i> Chạm để lật thẻ
                            </span>
                        </div>

                        <!-- Mặt Sau (Back Face) -->
                        <div class="card-face-back">
                            <p class="text-primary fw-bold" style="font-size: 1.75rem; margin-bottom: 0;">${currentWord.pinyin}</p>
                            <p class="text-ink fw-bold" style="font-size: 1.35rem; margin-bottom: 0;">${currentWord.meaningVi}</p>
                            
                            <c:if test="${not empty currentWord.exampleSentence}">
                                <div class="rounded-xl bg-secondary p-3 w-full text-center" style="max-width: 95%;">
                                    <p class="font-hanzi text-ink" style="font-size: 1.15rem; margin-bottom: 0.25rem;">
                                        ${currentWord.exampleSentence}
                                    </p>
                                    <p class="text-muted" style="font-size: 0.875rem; margin-bottom: 0;">
                                        ${currentWord.exampleMeaningVi}
                                    </p>
                                </div>
                            </c:if>
                            
                            <c:if test="${not empty currentWord.topic}">
                                <span class="badge badge-accent mt-1">
                                    ${currentWord.topic}
                                </span>
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- Thanh Điều Khiển Tiện Ích -->
                <div class="mt-5 d-flex align-items-center justify-content-center gap-2">
                    <c:if test="${currentIndex > 0}">
                        <form action="${pageContext.request.contextPath}/flashcard" method="post" style="display: inline;">
                            <input type="hidden" name="action" value="prev">
                            <button type="submit" class="btn btn-outline btn-icon" title="Thẻ trước đó">
                                <i class="fa-solid fa-chevron-left"></i>
                            </button>
                        </form>
                    </c:if>

                    <button type="button" class="btn btn-outline" onclick="event.stopPropagation(); speak('${currentWord.hanzi}')">
                        <i class="fa-solid fa-volume-high me-1 text-primary"></i> Phát âm
                    </button>

                    <button type="button" class="btn btn-outline" onclick="toggleCardFlip(document.getElementById('flashcardFlipper'))">
                        <i class="fa-solid fa-rotate-left me-1"></i> Lật thẻ
                    </button>

                    <button type="button" class="btn btn-outline btn-icon" title="Thẻ tiếp theo" onclick="document.getElementById('formNextCard').submit();">
                        <i class="fa-solid fa-chevron-right"></i>
                    </button>
                </div>

                <!-- 2 Nút Đánh Giá Trạng Thái Học -->
                <div class="mt-4 d-grid grid-cols-2 gap-3">
                    <form action="${pageContext.request.contextPath}/flashcard" method="post" id="formNextCard">
                        <input type="hidden" name="action" value="mark">
                        <input type="hidden" name="wordId" value="${currentWord.wordId}">
                        <input type="hidden" name="status" value="learning">
                        <button type="submit" class="btn btn-outline w-full" style="height: 3rem; font-size: 1rem;">
                            <i class="fa-solid fa-xmark me-2 text-danger"></i> Chưa thuộc
                        </button>
                    </form>

                    <form action="${pageContext.request.contextPath}/flashcard" method="post">
                        <input type="hidden" name="action" value="mark">
                        <input type="hidden" name="wordId" value="${currentWord.wordId}">
                        <input type="hidden" name="status" value="mastered">
                        <button type="submit" class="btn btn-primary w-full shadow-lift" style="height: 3rem; font-size: 1rem;">
                            <i class="fa-solid fa-check me-2"></i> Đã thuộc
                        </button>
                    </form>
                </div>
            </c:when>

            <c:otherwise>
                <!-- Trống dữ liệu -->
                <div class="card-plain text-center mt-6 p-10 shadow-card">
                    <p class="text-muted" style="font-size: 0.95rem;">
                        Cấp HSK ${selectedHsk} chưa có từ nào. Hãy thử HSK 1 hoặc thêm từ mới.
                    </p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="/common/footer.jsp" />
