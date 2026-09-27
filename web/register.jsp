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
                    Tạo tài khoản
                </h1>
                <p class="text-muted mt-1" style="font-size: 0.875rem;">
                    Lưu tiến độ, streak và lịch ôn tập của bạn.
                </p>
            </div>

            <!-- Tab Switcher -->
            <div class="d-grid grid-cols-2 gap-1 p-1 rounded-xl bg-secondary mb-6">
                <a href="${pageContext.request.contextPath}/login" 
                   class="btn btn-sm btn-ghost text-center" 
                   style="border-radius: var(--radius-md);">
                    Đăng nhập
                </a>
                <a href="${pageContext.request.contextPath}/register" 
                   class="btn btn-sm btn-primary text-center" 
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

            <!-- Register Form -->
            <form action="${pageContext.request.contextPath}/register" method="post" class="d-grid gap-4">
                <div class="form-group">
                    <label class="form-label">Tên đăng nhập <span class="text-danger">*</span></label>
                    <div class="input-with-icon">
                        <i class="fa-solid fa-user icon-left"></i>
                        <input type="text" 
                               name="username" 
                               class="form-control" 
                               placeholder="vd: student1" 
                               value="${username}" 
                               required 
                               autocomplete="username" />
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Email <span class="text-danger">*</span></label>
                    <div class="input-with-icon">
                        <i class="fa-solid fa-envelope icon-left"></i>
                        <input type="email" 
                               name="email" 
                               class="form-control" 
                               placeholder="ban@email.com" 
                               value="${email}" 
                               required 
                               autocomplete="email" />
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Mật khẩu <span class="text-danger">*</span></label>
                    <div class="input-with-icon">
                        <i class="fa-solid fa-lock icon-left"></i>
                        <input type="password" 
                               name="password" 
                               class="form-control" 
                               placeholder="Tối thiểu 6 ký tự" 
                               required 
                               minlength="6" 
                               autocomplete="new-password" />
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Xác nhận mật khẩu <span class="text-danger">*</span></label>
                    <div class="input-with-icon">
                        <i class="fa-solid fa-shield-halved icon-left"></i>
                        <input type="password" 
                               name="confirmPassword" 
                               class="form-control" 
                               placeholder="••••••••" 
                               required 
                               minlength="6" 
                               autocomplete="new-password" />
                    </div>
                </div>

                <button type="submit" class="btn btn-primary btn-lg w-full shadow-lift mt-2">
                    Tạo tài khoản
                </button>
            </form>

            <div class="text-center mt-6 pt-4 text-muted" style="border-top: 1px solid var(--border); font-size: 0.85rem;">
                Đã có tài khoản? 
                <a href="${pageContext.request.contextPath}/login" class="fw-bold text-primary">Đăng nhập</a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/common/footer.jsp" />
