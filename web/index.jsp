<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/common/header.jsp" />
<jsp:include page="/common/navbar.jsp" />

<div class="main-content">
    <!-- Hero Section -->
    <section class="bg-hero py-14" style="padding-top: 3.5rem; padding-bottom: 4.5rem;">
        <div class="container d-grid md-grid-cols-2 align-items-center gap-10">
            <div>
                <span class="badge badge-primary px-3 py-1 text-xs font-semibold uppercase tracking-wider" style="display: inline-flex; align-items: center; gap: 6px;">
                    <i class="fa-solid fa-wand-magic-sparkles" style="font-size: 0.75rem;"></i> HSK 1 → HSK 6
                </span>
                
                <h1 class="mt-4 text-ink fw-extrabold tracking-tight" style="font-size: 2.75rem; line-height: 1.2;">
                    Học <span class="font-hanzi text-primary">汉字</span> theo cách<br class="d-none sm-block" /> dễ nhớ nhất
                </h1>
                
                <p class="mt-4 text-muted" style="font-size: 1.05rem; max-width: 28rem; line-height: 1.65;">
                    Flashcard lật 3D, phát âm chuẩn, quiz đa dạng và thuật toán ôn tập ngắt quãng —
                    tất cả trong một ứng dụng gọn nhẹ, dùng mượt trên mọi thiết bị.
                </p>
                
                <div class="mt-6 d-flex flex-wrap gap-3">
                    <a href="${pageContext.request.contextPath}/flashcard" class="btn btn-primary btn-lg shadow-lift">
                        Bắt đầu học <i class="fa-solid fa-arrow-right ms-2" style="font-size: 0.85rem;"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/words" class="btn btn-outline btn-lg">
                        Xem từ vựng
                    </a>
                </div>
                
                <div class="mt-7 d-flex flex-wrap gap-6 text-muted" style="font-size: 0.875rem;">
                    <span class="d-inline-flex align-items-center gap-2">
                        <i class="fa-solid fa-book-open text-primary"></i> Kho từ vựng HSK 1-6
                    </span>
                    <span class="d-inline-flex align-items-center gap-2">
                        <i class="fa-solid fa-brain text-primary"></i> Học thông minh & nhớ lâu
                    </span>
                </div>
            </div>
            
            <div class="text-center">
                <img src="${pageContext.request.contextPath}/assets/hero-ink.jpg" 
                     alt="Nét bút thư pháp Trung Hoa màu đỏ" 
                     class="rounded-3xl shadow-lift mx-auto" 
                     style="max-width: 360px; width: 100%; border: 1px solid rgba(232, 226, 216, 0.8);" />
            </div>
        </div>
    </section>

    <!-- HSK Level Selection Section -->
    <section class="py-14">
        <div class="container">
            <div class="d-flex flex-wrap align-items-end justify-content-between gap-3 mb-6">
                <div>
                    <h2 class="text-ink fw-extrabold tracking-tight" style="font-size: 1.75rem;">Chọn cấp độ HSK</h2>
                    <p class="mt-1 text-muted" style="font-size: 0.9rem;">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                Tiến độ được lưu tự động vào tài khoản của bạn.
                            </c:when>
                            <c:otherwise>
                                Đăng nhập để lưu tiến độ học trên mọi thiết bị.
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <c:if test="${empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-outline btn-sm">
                        Đăng nhập / Đăng ký
                    </a>
                </c:if>
            </div>

            <!-- Level Cards Grid -->
            <div class="d-grid sm-grid-cols-2 lg-grid-cols-3 gap-4">
                <!-- HSK 1 -->
                <div class="card">
                    <div class="d-flex align-items-center justify-content-between">
                        <h3 class="text-ink fw-bold" style="font-size: 1.15rem;">HSK 1</h3>
                        <span class="badge badge-secondary">150 từ</span>
                    </div>
                    <p class="mt-2 text-muted" style="font-size: 0.875rem; min-height: 2.5rem;">
                        150 từ nền tảng — chào hỏi, gia đình, số đếm
                    </p>
                    <div class="progress-container mt-4">
                        <div class="progress-bar-fill" style="width: 100%;"></div>
                    </div>
                    <p class="mt-2 text-muted" style="font-size: 0.75rem;">
                        Cấp độ khởi đầu
                    </p>
                    <div class="mt-4 d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/flashcard?hskLevel=1" class="btn btn-primary btn-sm flex-1">
                            Flashcard
                        </a>
                        <a href="${pageContext.request.contextPath}/quiz?hskLevel=1" class="btn btn-outline btn-sm flex-1">
                            Kiểm tra
                        </a>
                    </div>
                </div>

                <!-- HSK 2 -->
                <div class="card">
                    <div class="d-flex align-items-center justify-content-between">
                        <h3 class="text-ink fw-bold" style="font-size: 1.15rem;">HSK 2</h3>
                        <span class="badge badge-secondary">300 từ</span>
                    </div>
                    <p class="mt-2 text-muted" style="font-size: 0.875rem; min-height: 2.5rem;">
                        Giao tiếp hằng ngày, mua sắm, thời gian
                    </p>
                    <div class="progress-container mt-4">
                        <div class="progress-bar-fill" style="width: 60%;"></div>
                    </div>
                    <p class="mt-2 text-muted" style="font-size: 0.75rem;">
                        Giao tiếp cơ bản
                    </p>
                    <div class="mt-4 d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/flashcard?hskLevel=2" class="btn btn-primary btn-sm flex-1">
                            Flashcard
                        </a>
                        <a href="${pageContext.request.contextPath}/quiz?hskLevel=2" class="btn btn-outline btn-sm flex-1">
                            Kiểm tra
                        </a>
                    </div>
                </div>

                <!-- HSK 3 -->
                <div class="card">
                    <div class="d-flex align-items-center justify-content-between">
                        <h3 class="text-ink fw-bold" style="font-size: 1.15rem;">HSK 3</h3>
                        <span class="badge badge-secondary">600 từ</span>
                    </div>
                    <p class="mt-2 text-muted" style="font-size: 0.875rem; min-height: 2.5rem;">
                        Trò chuyện tự nhiên về học tập và công việc
                    </p>
                    <div class="progress-container mt-4">
                        <div class="progress-bar-fill" style="width: 40%;"></div>
                    </div>
                    <p class="mt-2 text-muted" style="font-size: 0.75rem;">
                        Trung cấp giao tiếp
                    </p>
                    <div class="mt-4 d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/flashcard?hskLevel=3" class="btn btn-primary btn-sm flex-1">
                            Flashcard
                        </a>
                        <a href="${pageContext.request.contextPath}/quiz?hskLevel=3" class="btn btn-outline btn-sm flex-1">
                            Kiểm tra
                        </a>
                    </div>
                </div>

                <!-- HSK 4 -->
                <div class="card">
                    <div class="d-flex align-items-center justify-content-between">
                        <h3 class="text-ink fw-bold" style="font-size: 1.15rem;">HSK 4</h3>
                        <span class="badge badge-secondary">1200 từ</span>
                    </div>
                    <p class="mt-2 text-muted" style="font-size: 0.875rem; min-height: 2.5rem;">
                        Diễn đạt ý kiến, tin tức, văn hoá
                    </p>
                    <div class="progress-container mt-4">
                        <div class="progress-bar-fill" style="width: 25%;"></div>
                    </div>
                    <p class="mt-2 text-muted" style="font-size: 0.75rem;">
                        Trung cao cấp
                    </p>
                    <div class="mt-4 d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/flashcard?hskLevel=4" class="btn btn-primary btn-sm flex-1">
                            Flashcard
                        </a>
                        <a href="${pageContext.request.contextPath}/quiz?hskLevel=4" class="btn btn-outline btn-sm flex-1">
                            Kiểm tra
                        </a>
                    </div>
                </div>

                <!-- HSK 5 -->
                <div class="card">
                    <div class="d-flex align-items-center justify-content-between">
                        <h3 class="text-ink fw-bold" style="font-size: 1.15rem;">HSK 5</h3>
                        <span class="badge badge-secondary">2500 từ</span>
                    </div>
                    <p class="mt-2 text-muted" style="font-size: 0.875rem; min-height: 2.5rem;">
                        Đọc báo, xem phim, thảo luận chuyên sâu
                    </p>
                    <div class="progress-container mt-4">
                        <div class="progress-bar-fill" style="width: 15%;"></div>
                    </div>
                    <p class="mt-2 text-muted" style="font-size: 0.75rem;">
                        Cao cấp thành thạo
                    </p>
                    <div class="mt-4 d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/flashcard?hskLevel=5" class="btn btn-primary btn-sm flex-1">
                            Flashcard
                        </a>
                        <a href="${pageContext.request.contextPath}/quiz?hskLevel=5" class="btn btn-outline btn-sm flex-1">
                            Kiểm tra
                        </a>
                    </div>
                </div>

                <!-- HSK 6 -->
                <div class="card">
                    <div class="d-flex align-items-center justify-content-between">
                        <h3 class="text-ink fw-bold" style="font-size: 1.15rem;">HSK 6</h3>
                        <span class="badge badge-secondary">5000+ từ</span>
                    </div>
                    <p class="mt-2 text-muted" style="font-size: 0.875rem; min-height: 2.5rem;">
                        Trình độ gần bản ngữ, văn viết học thuật
                    </p>
                    <div class="progress-container mt-4">
                        <div class="progress-bar-fill" style="width: 10%;"></div>
                    </div>
                    <p class="mt-2 text-muted" style="font-size: 0.75rem;">
                        Chuyên sâu bản ngữ
                    </p>
                    <div class="mt-4 d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/flashcard?hskLevel=6" class="btn btn-primary btn-sm flex-1">
                            Flashcard
                        </a>
                        <a href="${pageContext.request.contextPath}/quiz?hskLevel=6" class="btn btn-outline btn-sm flex-1">
                            Kiểm tra
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>

<jsp:include page="/common/footer.jsp" />
