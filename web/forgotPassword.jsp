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
                    <i class="fa-solid fa-key text-primary" style="font-size: 1.5rem;"></i>
                </div>
                <h1 class="text-ink fw-extrabold tracking-tight" style="font-size: 1.75rem;">
                    Quên mật khẩu?
                </h1>
                <p class="text-muted mt-1" style="font-size: 0.875rem;">
                    Nhập địa chỉ email đăng ký tài khoản của bạn để nhận mã xác thực OTP qua Gmail.
                </p>
            </div>

            <!-- Notifications -->
            <c:if test="${not empty requestScope.errorMessage}">
                <div class="alert-box alert-error mb-4">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                    <div>${requestScope.errorMessage}</div>
                </div>
            </c:if>

            <!-- Form gửi OTP -->
            <form action="${pageContext.request.contextPath}/forgot-password" method="post" class="d-grid gap-4">
                <div class="form-group">
                    <label class="form-label">Địa chỉ Email</label>
                    <div class="input-with-icon">
                        <i class="fa-solid fa-envelope icon-left"></i>
                        <input type="email" 
                               name="email" 
                               class="form-control" 
                               placeholder="example@gmail.com" 
                               value="${email}" 
                               required 
                               autocomplete="email" 
                               autofocus />
                    </div>
                </div>

                <button type="submit" class="btn btn-primary btn-lg w-full shadow-lift mt-2">
                    <i class="fa-solid fa-paper-plane me-1"></i> Gửi mã xác thực OTP
                </button>

                <div class="text-center mt-2">
                    <a href="${pageContext.request.contextPath}/login" class="text-muted hover-underline" style="font-size: 0.875rem;">
                        <i class="fa-solid fa-arrow-left me-1"></i> Quay lại trang Đăng nhập
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/common/footer.jsp" />
