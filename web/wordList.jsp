<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/common/header.jsp" />
<jsp:include page="/common/navbar.jsp" />

<div class="main-content py-10">
    <div class="container">
        <!-- Title Header & Actions -->
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-4">
            <div>
                <h1 class="text-ink fw-extrabold tracking-tight" style="font-size: 1.875rem;">
                    Từ vựng HSK
                </h1>
                <p class="mt-1 text-muted" style="font-size: 0.9rem;">
                    Lọc theo cấp độ, tìm nhanh theo Hán tự, Pinyin hoặc nghĩa tiếng Việt (Tổng số: <strong>${totalWords}</strong> từ).
                </p>
            </div>
            <c:if test="${sessionScope.user.role eq 'ADMIN'}">
                <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/words/import" class="btn btn-outline" style="border-color: #2e7559; color: #2e7559;">
                        <i class="fa-solid fa-file-excel me-1"></i> Nhập từ Excel
                    </a>
                    <a href="${pageContext.request.contextPath}/words/add" class="btn btn-primary shadow-lift">
                        <i class="fa-solid fa-plus me-1"></i> Thêm từ mới
                    </a>
                </div>
            </c:if>
        </div>

        <!-- Success & Error Notifications -->
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert-box alert-success">
                <i class="fa-solid fa-circle-check"></i>
                <div>${sessionScope.successMessage}</div>
            </div>
            <c:remove var="successMessage" scope="session" />
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert-box alert-error">
                <i class="fa-solid fa-triangle-exclamation"></i>
                <div>${sessionScope.errorMessage}</div>
            </div>
            <c:remove var="errorMessage" scope="session" />
        </c:if>
        <c:if test="${not empty requestScope.errorMessage}">
            <div class="alert-box alert-error">
                <i class="fa-solid fa-triangle-exclamation"></i>
                <div>${requestScope.errorMessage}</div>
            </div>
        </c:if>

        <!-- HSK Level Filter Pills -->
        <div class="level-picker mb-4">
            <a href="${pageContext.request.contextPath}/words?hskLevel=0&search=${searchKeyword}" 
               class="level-picker-pill ${empty selectedHsk or selectedHsk eq 0 ? 'active' : ''}">
                Tất cả
            </a>
            <c:forEach var="lvl" begin="1" end="6">
                <a href="${pageContext.request.contextPath}/words?hskLevel=${lvl}&search=${searchKeyword}" 
                   class="level-picker-pill ${selectedHsk eq lvl ? 'active' : ''}">
                    HSK ${lvl}
                </a>
            </c:forEach>
        </div>

        <!-- Search Bar -->
        <div class="card-plain shadow-card mb-6" style="padding: 1rem 1.25rem;">
            <form action="${pageContext.request.contextPath}/words" method="get" class="d-flex flex-column sm-flex-row gap-3">
                <input type="hidden" name="hskLevel" value="${empty selectedHsk ? 0 : selectedHsk}">
                <div class="input-with-icon flex-1">
                    <i class="fa-solid fa-magnifying-glass icon-left"></i>
                    <input type="text" 
                           name="search" 
                           class="form-control" 
                           placeholder="Tìm theo chữ Hán, pinyin hoặc nghĩa tiếng Việt..." 
                           value="${searchKeyword}">
                </div>
                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                    <a href="${pageContext.request.contextPath}/words" class="btn btn-outline" title="Đặt lại">
                        <i class="fa-solid fa-rotate"></i>
                    </a>
                </div>
            </form>
        </div>

        <!-- Word List Group -->
        <c:choose>
            <c:when test="${not empty wordList}">
                <ul class="word-list-group">
                    <c:forEach var="w" items="${wordList}">
                        <li class="word-list-item">
                            <!-- Chữ Hán Lớn -->
                            <span class="font-hanzi text-ink" style="font-size: 2.25rem; min-width: 3.5rem; line-height: 1; font-weight: 700;">
                                ${w.hanzi}
                            </span>

                            <!-- Thông Tin Từ Vựng -->
                            <div class="flex-1" style="min-width: 0;">
                                <div class="d-flex align-items-center gap-2">
                                    <span class="text-primary fw-semibold" style="font-size: 0.95rem;">${w.pinyin}</span>
                                    <span class="badge badge-secondary" style="font-size: 0.7rem;">HSK ${w.hskLevel}</span>
                                    <c:if test="${not empty w.topic}">
                                        <span class="badge badge-accent d-none sm-block" style="font-size: 0.7rem;">${w.topic}</span>
                                    </c:if>
                                </div>
                                <p class="text-ink fw-semibold mt-1 mb-0" style="font-size: 0.95rem;">
                                    ${w.meaningVi}
                                </p>
                                <c:if test="${not empty w.exampleSentence}">
                                    <p class="text-muted mt-1 mb-0 truncate" style="font-size: 0.8rem;">
                                        <span class="font-hanzi text-ink">${w.exampleSentence}</span> — ${w.exampleMeaningVi}
                                    </p>
                                </c:if>
                            </div>

                            <!-- Nút Phát Âm & Thao Tác Admin -->
                            <div class="d-flex align-items-center gap-1">
                                <button type="button" class="btn-speaker" onclick="speak('${w.hanzi}')" title="Phát âm ${w.hanzi}">
                                    <i class="fa-solid fa-volume-high"></i>
                                </button>
                                
                                <c:if test="${sessionScope.user.role eq 'ADMIN'}">
                                    <a href="${pageContext.request.contextPath}/words/edit?id=${w.wordId}" class="btn-speaker" title="Sửa từ">
                                        <i class="fa-solid fa-pen-to-square"></i>
                                    </a>
                                    <button type="button" class="btn-speaker" title="Xóa từ" onclick="confirmDelete(${w.wordId}, '${w.hanzi}')" style="color: var(--destructive);">
                                        <i class="fa-solid fa-trash-can"></i>
                                    </button>
                                </c:if>
                            </div>
                        </li>
                    </c:forEach>
                </ul>

                <!-- Pagination Footer -->
                <c:if test="${totalPages > 1}">
                    <div class="d-flex align-items-center justify-content-between flex-wrap gap-3 mt-6">
                        <span class="text-muted" style="font-size: 0.875rem;">
                            Trang <strong>${currentPage}</strong> / <strong>${totalPages}</strong>
                        </span>
                        <ul class="pagination">
                            <li class="page-item ${currentPage eq 1 ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/words?page=${currentPage - 1}&hskLevel=${selectedHsk}&search=${searchKeyword}">
                                    &laquo; Trước
                                </a>
                            </li>
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <li class="page-item ${i eq currentPage ? 'active' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/words?page=${i}&hskLevel=${selectedHsk}&search=${searchKeyword}">
                                        ${i}
                                    </a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage eq totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/words?page=${currentPage + 1}&hskLevel=${selectedHsk}&search=${searchKeyword}">
                                    Sau &raquo;
                                </a>
                            </li>
                        </ul>
                    </div>
                </c:if>
            </c:when>

            <c:otherwise>
                <div class="card-plain text-center p-10 shadow-card">
                    <p class="text-muted" style="font-size: 0.95rem;">
                        Chưa có từ nào phù hợp với bộ lọc. Hãy thử tìm kiếm từ khóa khác.
                    </p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Modal Xác Nhận Xóa Từ Vựng -->
<div class="modal-backdrop" id="deleteModal">
    <div class="modal-dialog">
        <h3 class="text-ink fw-extrabold" style="font-size: 1.25rem;">Xác nhận xóa từ vựng</h3>
        <p class="text-muted mt-2" style="font-size: 0.95rem;">
            Bạn có chắc muốn xóa từ vựng <strong id="deleteWordHanzi" class="text-primary font-hanzi" style="font-size: 1.25rem;"></strong> khỏi kho dữ liệu? Thao tác này không thể hoàn tác.
        </p>
        <div class="d-flex justify-content-end gap-2 mt-6">
            <button type="button" class="btn btn-outline" onclick="hanziModal.hide('deleteModal')">Hủy bỏ</button>
            <form id="deleteForm" method="post" action="">
                <button type="submit" class="btn btn-primary" style="background-color: var(--destructive); border-color: var(--destructive);">Xác nhận xóa</button>
            </form>
        </div>
    </div>
</div>

<script>
function confirmDelete(id, hanzi) {
    document.getElementById('deleteWordHanzi').innerText = hanzi;
    document.getElementById('deleteForm').action = '${pageContext.request.contextPath}/words/delete?id=' + id;
    hanziModal.show('deleteModal');
}
</script>

<jsp:include page="/common/footer.jsp" />
