<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/common/header.jsp" />
<jsp:include page="/common/navbar.jsp" />

<div class="main-content py-10">
    <div class="container">
        <!-- Header & Breadcrumb -->
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-6">
            <div>
                <h1 class="text-ink fw-extrabold tracking-tight" style="font-size: 1.875rem;">
                    <i class="fa-solid fa-chart-line text-primary me-2"></i>Thống kê học viên & Hệ thống
                </h1>
                <p class="mt-1 text-muted" style="font-size: 0.9rem;">
                    Quản lý tài khoản, theo dõi tiến độ học tập và phân tích kết quả bài kiểm tra của từng học viên.
                </p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/words" class="btn btn-outline">
                    <i class="fa-solid fa-book-bookmark me-1"></i> Quản lý từ vựng
                </a>
            </div>
        </div>

        <!-- 4 Thẻ KPI Tổng quan hệ thống -->
        <div class="d-grid sm-grid-cols-2 lg-grid-cols-4 gap-4 mb-8">
            <div class="card-plain shadow-card">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <p class="text-muted fw-medium" style="font-size: 0.85rem;">Tổng số tài khoản</p>
                        <h2 class="mt-1 text-ink fw-extrabold" style="font-size: 1.75rem;">
                            ${systemStats.totalUsers}
                        </h2>
                    </div>
                    <div style="width: 48px; height: 48px; border-radius: 12px; background: rgba(235, 78, 43, 0.1); display: flex; align-items: center; justify-content: center;">
                        <i class="fa-solid fa-users text-primary" style="font-size: 1.35rem;"></i>
                    </div>
                </div>
            </div>

            <div class="card-plain shadow-card">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <p class="text-muted fw-medium" style="font-size: 0.85rem;">Kho từ vựng HSK</p>
                        <h2 class="mt-1 text-ink fw-extrabold" style="font-size: 1.75rem;">
                            ${systemStats.totalWords}
                        </h2>
                    </div>
                    <div style="width: 48px; height: 48px; border-radius: 12px; background: rgba(46, 117, 89, 0.1); display: flex; align-items: center; justify-content: center;">
                        <i class="fa-solid fa-book text-success" style="font-size: 1.35rem; color: #2e7559;"></i>
                    </div>
                </div>
            </div>

            <div class="card-plain shadow-card">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <p class="text-muted fw-medium" style="font-size: 0.85rem;">Tổng lượt đã thuộc</p>
                        <h2 class="mt-1 text-ink fw-extrabold" style="font-size: 1.75rem;">
                            ${systemStats.totalMasteredWords}
                        </h2>
                    </div>
                    <div style="width: 48px; height: 48px; border-radius: 12px; background: rgba(245, 158, 11, 0.1); display: flex; align-items: center; justify-content: center;">
                        <i class="fa-solid fa-award" style="font-size: 1.35rem; color: #d97706;"></i>
                    </div>
                </div>
            </div>

            <div class="card-plain shadow-card">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <p class="text-muted fw-medium" style="font-size: 0.85rem;">Lượt làm Quiz</p>
                        <h2 class="mt-1 text-ink fw-extrabold" style="font-size: 1.75rem;">
                            ${systemStats.totalQuizzesTaken}
                        </h2>
                    </div>
                    <div style="width: 48px; height: 48px; border-radius: 12px; background: rgba(59, 130, 246, 0.1); display: flex; align-items: center; justify-content: center;">
                        <i class="fa-solid fa-feather-pointed" style="font-size: 1.35rem; color: #2563eb;"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bộ lọc & Tìm kiếm Người dùng -->
        <div class="card-plain shadow-card mb-6">
            <form action="${pageContext.request.contextPath}/admin/users" method="get" class="d-flex flex-wrap align-items-center gap-3">
                <div class="flex-1" style="min-width: 240px;">
                    <div style="position: relative;">
                        <i class="fa-solid fa-magnifying-glass text-muted" style="position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); font-size: 0.9rem;"></i>
                        <input type="text" 
                               name="search" 
                               class="form-control" 
                               style="padding-left: 2.5rem;" 
                               placeholder="Tìm theo tên đăng nhập hoặc email..." 
                               value="${searchKeyword}">
                    </div>
                </div>

                <div style="min-width: 160px;">
                    <select name="role" class="form-control">
                        <option value="ALL" ${empty roleFilter or roleFilter eq 'ALL' ? 'selected' : ''}>Tất cả vai trò</option>
                        <option value="USER" ${roleFilter eq 'USER' ? 'selected' : ''}>Học viên (USER)</option>
                        <option value="ADMIN" ${roleFilter eq 'ADMIN' ? 'selected' : ''}>Quản trị viên (ADMIN)</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary">
                    <i class="fa-solid fa-filter me-1"></i> Lọc dữ liệu
                </button>

                <c:if test="${not empty searchKeyword or (not empty roleFilter and roleFilter ne 'ALL')}">
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-ghost">
                        <i class="fa-solid fa-arrow-rotate-left me-1"></i> Đặt lại
                    </a>
                </c:if>
            </form>
        </div>

        <!-- Bảng danh sách người dùng -->
        <div class="card-plain shadow-card p-0" style="overflow: hidden;">
            <div class="p-4 d-flex align-items-center justify-content-between border-bottom">
                <h3 class="text-ink fw-bold" style="font-size: 1.1rem;">
                    Danh sách học viên (${userList.size()})
                </h3>
                <span class="text-muted" style="font-size: 0.85rem;">
                    Nhấn vào dòng hoặc nút <b>Chi tiết</b> để xem thống kê học tập
                </span>
            </div>

            <div style="overflow-x: auto;">
                <table class="table w-full" style="margin-bottom: 0;">
                    <thead>
                        <tr style="background: var(--bg-surface-subtle); border-bottom: 1px solid var(--border-color);">
                            <th class="py-3 px-4 text-start font-medium text-muted" style="font-size: 0.8rem;">ID</th>
                            <th class="py-3 px-4 text-start font-medium text-muted" style="font-size: 0.8rem;">HỌC VIÊN</th>
                            <th class="py-3 px-4 text-center font-medium text-muted" style="font-size: 0.8rem;">VAI TRÒ</th>
                            <th class="py-3 px-4 text-center font-medium text-muted" style="font-size: 0.8rem;">ĐÃ THUỘC</th>
                            <th class="py-3 px-4 text-center font-medium text-muted" style="font-size: 0.8rem;">ĐANG HỌC</th>
                            <th class="py-3 px-4 text-center font-medium text-muted" style="font-size: 0.8rem;">BÀI QUIZ</th>
                            <th class="py-3 px-4 text-center font-medium text-muted" style="font-size: 0.8rem;">ĐIỂM TB QUIZ</th>
                            <th class="py-3 px-4 text-center font-medium text-muted" style="font-size: 0.8rem;">HOẠT ĐỘNG GẦN NHẤT</th>
                            <th class="py-3 px-4 text-end font-medium text-muted" style="font-size: 0.8rem;">THAO TÁC</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty userList}">
                                <tr>
                                    <td colspan="9" class="text-center py-8 text-muted">
                                        <i class="fa-regular fa-folder-open mb-2" style="font-size: 2rem; display: block;"></i>
                                        Không tìm thấy học viên nào phù hợp với điều kiện tìm kiếm.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="u" items="${userList}">
                                    <tr style="border-bottom: 1px solid var(--border-color); transition: background 0.15s ease;">
                                        <td class="py-3 px-4 text-muted fw-semibold" style="font-size: 0.85rem;">
                                            #${u.userId}
                                        </td>
                                        <td class="py-3 px-4">
                                            <a href="${pageContext.request.contextPath}/admin/users/detail?id=${u.userId}" 
                                               class="fw-bold text-ink hover-underline d-block" 
                                               style="font-size: 0.95rem;">
                                                <i class="fa-regular fa-circle-user me-1 text-primary"></i> ${u.username}
                                            </a>
                                            <span class="text-muted d-block" style="font-size: 0.8rem;">
                                                ${empty u.email ? 'Chưa cập nhật email' : u.email}
                                            </span>
                                        </td>
                                        <td class="py-3 px-4 text-center">
                                            <c:choose>
                                                <c:when test="${u.role eq 'ADMIN'}">
                                                    <span class="badge" style="background: rgba(235, 78, 43, 0.15); color: var(--primary); font-weight: 600;">
                                                        <i class="fa-solid fa-shield-halved me-1"></i> Admin
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge" style="background: rgba(100, 116, 139, 0.12); color: #475569;">
                                                        Học viên
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="py-3 px-4 text-center">
                                            <span class="badge" style="background: rgba(46, 117, 89, 0.12); color: #2e7559; font-weight: 600; font-size: 0.85rem;">
                                                ${u.masteredCount} từ
                                            </span>
                                        </td>
                                        <td class="py-3 px-4 text-center">
                                            <span class="badge" style="background: rgba(245, 158, 11, 0.12); color: #d97706; font-weight: 600; font-size: 0.85rem;">
                                                ${u.learningCount} từ
                                            </span>
                                        </td>
                                        <td class="py-3 px-4 text-center fw-bold text-ink" style="font-size: 0.9rem;">
                                            ${u.totalQuizCount}
                                        </td>
                                        <td class="py-3 px-4 text-center">
                                            <c:choose>
                                                <c:when test="${u.totalQuizCount > 0}">
                                                    <span class="fw-extrabold ${u.avgQuizScore >= 80 ? 'text-success' : (u.avgQuizScore >= 50 ? 'text-primary' : 'text-danger')}" style="font-size: 0.9rem;">
                                                        <fmt:formatNumber value="${u.avgQuizScore}" maxFractionDigits="1"/>%
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted" style="font-size: 0.85rem;">Chưa làm</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="py-3 px-4 text-center text-muted" style="font-size: 0.85rem;">
                                            <c:choose>
                                                <c:when test="${not empty u.lastActive}">
                                                    <fmt:formatDate value="${u.lastActive}" pattern="dd/MM/yyyy HH:mm"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <span>Chưa có</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="py-3 px-4 text-end">
                                            <a href="${pageContext.request.contextPath}/admin/users/detail?id=${u.userId}" 
                                               class="btn btn-outline btn-sm" 
                                               title="Xem thống kê chi tiết của học viên này">
                                                <i class="fa-solid fa-chart-pie me-1 text-primary"></i> Chi tiết
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/common/footer.jsp" />
