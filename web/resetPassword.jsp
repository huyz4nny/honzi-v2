<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/common/header.jsp" />
<jsp:include page="/common/navbar.jsp" />

<div class="auth-page py-12">
    <div class="container container-sm">
        <div class="card-plain shadow-card" style="max-width: 440px; margin: 0 auto;">
            <!-- Header Icon & Title -->
            <div class="text-center mb-6">
                <div style="width: 56px; height: 56px; border-radius: 50%; background: rgba(235, 78, 43, 0.1); display: inline-flex; align-items: center; justify-content: center; margin-bottom: 1rem;">
                    <i class="fa-solid fa-lock-open text-primary" style="font-size: 1.5rem;"></i>
                </div>
                <h1 class="text-ink fw-extrabold tracking-tight" style="font-size: 1.75rem;">
                    Đặt lại mật khẩu mới
                </h1>
                <p class="text-muted mt-1" style="font-size: 0.875rem;">
                    Tạo mật khẩu mới cho tài khoản liên kết với <br>
                    <b class="text-ink">${sessionScope.resetEmail}</b>
                </p>
            </div>

            <!-- Notifications -->
            <c:if test="${not empty requestScope.errorMessage}">
                <div class="alert-box alert-error mb-4">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                    <div>${requestScope.errorMessage}</div>
                </div>
            </c:if>

            <!-- Form đặt lại mật khẩu -->
            <form action="${pageContext.request.contextPath}/reset-password" method="post" class="d-grid gap-4">
                <div class="form-group">
                    <label class="form-label">Mật khẩu mới</label>
                    <div class="input-with-icon">
                        <i class="fa-solid fa-lock icon-left"></i>
                        <input type="password" 
                               name="newPassword" 
                               class="form-control" 
                               placeholder="Tối thiểu 6 ký tự" 
                               minlength="6" 
                               required 
                               autofocus 
                               autocomplete="new-password" />
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Xác nhận mật khẩu mới</label>
                    <div class="input-with-icon">
                        <i class="fa-solid fa-check-double icon-left"></i>
                        <input type="password" 
                               name="confirmPassword" 
                               class="form-control" 
                               placeholder="Nhập lại mật khẩu mới" 
                               minlength="6" 
                               required 
                               autocomplete="new-password" />
                    </div>
                </div>

                <button type="submit" class="btn btn-primary btn-lg w-full shadow-lift mt-2">
                    <i class="fa-solid fa-floppy-disk me-1"></i> Lưu mật khẩu mới
                </button>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/common/footer.jsp" />
