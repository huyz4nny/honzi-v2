<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/common/header.jsp" />
<jsp:include page="/common/navbar.jsp" />

<div class="auth-page py-12">
    <div class="container container-sm">
        <div class="card-plain shadow-card" style="max-width: 440px; margin: 0 auto;">
            <!-- Header Icon & Title -->
            <div class="text-center mb-6">
                <div style="width: 56px; height: 56px; border-radius: 50%; background: rgba(46, 117, 89, 0.1); display: inline-flex; align-items: center; justify-content: center; margin-bottom: 1rem;">
                    <i class="fa-solid fa-shield-halved text-success" style="font-size: 1.5rem; color: #2e7559;"></i>
                </div>
                <h1 class="text-ink fw-extrabold tracking-tight" style="font-size: 1.75rem;">
                    Xác thực mã OTP
                </h1>
                <p class="text-muted mt-1" style="font-size: 0.875rem;">
                    Mã xác thực gồm 6 chữ số đã được gửi tới email <br>
                    <b class="text-ink">${sessionScope.resetEmail}</b>
                </p>
            </div>

            <!-- Notifications -->
            <c:if test="${not empty sessionScope.infoMessage}">
                <div class="alert-box alert-info mb-4" style="background: rgba(59, 130, 246, 0.08); border: 1px solid rgba(59, 130, 246, 0.2); color: #1d4ed8; padding: 0.75rem 1rem; border-radius: 8px; font-size: 0.85rem; display: flex; gap: 0.5rem; align-items: center;">
                    <i class="fa-solid fa-circle-info"></i>
                    <div>${sessionScope.infoMessage}</div>
                </div>
                <c:remove var="infoMessage" scope="session" />
            </c:if>

            <c:if test="${not empty requestScope.errorMessage}">
                <div class="alert-box alert-error mb-4">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                    <div>${requestScope.errorMessage}</div>
                </div>
            </c:if>

            <!-- Form nhập OTP -->
            <form action="${pageContext.request.contextPath}/verify-otp" method="post" class="d-grid gap-4">
                <div class="form-group">
                    <label class="form-label text-center d-block">Nhập mã OTP 6 chữ số</label>
                    <input type="text" 
                           name="otp" 
                           class="form-control text-center fw-extrabold" 
                           style="font-size: 1.75rem; letter-spacing: 8px; height: 3.5rem; color: var(--primary);" 
                           maxlength="6" 
                           pattern="[0-9]{6}" 
                           placeholder="••••••" 
                           required 
                           autofocus 
                           autocomplete="one-time-code" />
                    <span class="text-muted text-center d-block mt-2" style="font-size: 0.8rem;">
                        <i class="fa-regular fa-clock me-1"></i> Mã có hiệu lực trong 5 phút
                    </span>
                </div>

                <button type="submit" class="btn btn-primary btn-lg w-full shadow-lift">
                    <i class="fa-solid fa-circle-check me-1"></i> Xác nhận mã OTP
                </button>
            </form>

            <div class="d-flex justify-content-between align-items-center mt-6 pt-4 border-top">
                <!-- Nút gửi lại mã -->
                <form action="${pageContext.request.contextPath}/verify-otp" method="post" style="margin: 0;">
                    <input type="hidden" name="resend" value="true">
                    <button type="submit" class="btn btn-ghost btn-sm" style="color: var(--primary); font-weight: 600;">
                        <i class="fa-solid fa-rotate-right me-1"></i> Gửi lại mã OTP
                    </button>
                </form>

                <a href="${pageContext.request.contextPath}/forgot-password" class="text-muted hover-underline" style="font-size: 0.85rem;">
                    Đổi email khác
                </a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/common/footer.jsp" />
