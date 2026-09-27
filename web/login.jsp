<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/common/header.jsp" />
<jsp:include page="/common/navbar.jsp" />

<div class="main-content py-14">
    <div class="container container-sm" style="max-width: 440px;">
        <div class="card-plain shadow-card" style="padding: 2rem;">
            <!-- Header -->
            <div class="text-center mb-6">
                <div class="logo-icon mx-auto mb-3" style="width: 3rem; height: 3rem; font-size: 1.5rem; border-radius: var(--radius-xl); background: var(--primary); color: #fff; display: flex; align-items: center; justify-content: center; box-shadow: var(--shadow-lift); font-family: var(--font-hanzi);">
                    汉
                </div>
                <h1 class="text-ink fw-extrabold tracking-tight" style="font-size: 1.65rem;">
                    Đăng nhập HanziGo
                </h1>
                <p class="text-muted mt-1" style="font-size: 0.875rem;">
                    Lưu tiến độ, streak và lịch ôn tập của bạn.
                </p>
            </div>

            <!-- Tab Switcher -->
            <div class="d-grid grid-cols-2 gap-1 p-1 rounded-xl bg-secondary mb-6">
                <a href="${pageContext.request.contextPath}/login" 
                   class="btn btn-sm btn-primary text-center" 
                   style="border-radius: var(--radius-md);">
                    Đăng nhập
                </a>
                <a href="${pageContext.request.contextPath}/register" 
                   class="btn btn-sm btn-ghost text-center" 
                   style="border-radius: var(--radius-md);">
                    Đăng ký
                </a>
            </div>

            <!-- Notifications -->
            <c:if test="${not empty requestScope.errorMessage}">
                <div class="alert-box alert-error">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                    <div>${requestScope.errorMessage}</div>
                </div>
            </c:if>
            <c:if test="${not empty requestScope.successMessage}">
                <div class="alert-box alert-success">
                    <i class="fa-solid fa-circle-check"></i>
                    <div>${requestScope.successMessage}</div>
                </div>
            </c:if>

            <!-- Login Form -->
            <form action="${pageContext.request.contextPath}/login" method="post" class="d-grid gap-4">
                <div class="form-group">
                    <label class="form-label">Tên đăng nhập</label>
                    <div class="input-with-icon">
                        <i class="fa-solid fa-user icon-left"></i>
                        <input type="text" 
                               name="username" 
                               class="form-control" 
                               placeholder="Nhập tên đăng nhập" 
                               value="${username}" 
                               required 
                               autocomplete="username" />
                    </div>
                </div>

                <div class="form-group">
                    <div class="d-flex justify-content-between align-items-center mb-1">
                        <label class="form-label" style="margin-bottom: 0;">Mật khẩu</label>
                        <a href="${pageContext.request.contextPath}/forgot-password" 
                           class="text-muted hover-underline" 
                           style="font-size: 0.8rem;">
                            Quên mật khẩu?
                        </a>
                    </div>
                    <div class="input-with-icon">
                        <i class="fa-solid fa-lock icon-left"></i>
                        <input type="password" 
                               name="password" 
                               class="form-control" 
                               placeholder="••••••••" 
                               required 
                               autocomplete="current-password" />
                    </div>
                </div>

                <button type="submit" class="btn btn-primary btn-lg w-full shadow-lift mt-2">
                    Đăng nhập
                </button>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/common/footer.jsp" />
