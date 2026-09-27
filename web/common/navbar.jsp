<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String currentURI = request.getRequestURI();
    String contextPath = request.getContextPath();
    String path = currentURI.substring(contextPath.length());
    request.setAttribute("reqPath", path);
%>

<header class="site-header">
    <div class="container header-inner">
        <!-- Logo Brand -->
        <a href="${pageContext.request.contextPath}/index.jsp" class="brand-logo">
            <span class="logo-icon">汉</span>
            <span class="logo-text">HonziGo</span>
        </a>

        <!-- Desktop Navigation -->
        <nav class="main-nav md-flex">
            <a href="${pageContext.request.contextPath}/index.jsp" 
               class="nav-link-item ${reqPath eq '/' or reqPath eq '/index.jsp' ? 'active' : ''}">
                Trang chủ
            </a>
            <a href="${pageContext.request.contextPath}/words" 
               class="nav-link-item ${reqPath.startsWith('/words') and sessionScope.user.role ne 'ADMIN' ? 'active' : ''}">
                Từ vựng
            </a>
            <a href="${pageContext.request.contextPath}/flashcard" 
               class="nav-link-item ${reqPath.startsWith('/flashcard') ? 'active' : ''}">
                Flashcard
            </a>
            <a href="${pageContext.request.contextPath}/quiz" 
               class="nav-link-item ${reqPath.startsWith('/quiz') ? 'active' : ''}">
                Kiểm tra
            </a>
            <a href="${pageContext.request.contextPath}/progress" 
               class="nav-link-item ${reqPath.startsWith('/progress') ? 'active' : ''}">
                Thống kê
            </a>
            <c:if test="${sessionScope.user.role eq 'ADMIN'}">
                <a href="${pageContext.request.contextPath}/words" 
                   class="nav-link-item ${reqPath.startsWith('/words') ? 'active' : ''}" 
                   style="color: var(--primary); font-weight: 600;">
                    <i class="fa-solid fa-list-check me-1"></i> Quản lý từ vựng
                </a>
                <a href="${pageContext.request.contextPath}/admin/users" 
                   class="nav-link-item ${reqPath.startsWith('/admin') ? 'active' : ''}" 
                   style="color: var(--primary); font-weight: 600;">
                    <i class="fa-solid fa-chart-pie me-1"></i> Thống kê học viên
                </a>
            </c:if>
        </nav>

        <!-- Right Side: User & Auth Buttons -->
        <div class="d-flex align-items-center gap-2" style="margin-left: auto;">
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <span class="text-muted d-none sm-block" style="font-size: 0.875rem; max-width: 160px;" title="${sessionScope.user.username}">
                        <i class="fa-regular fa-user me-1"></i> ${sessionScope.user.username}
                        <c:if test="${sessionScope.user.role eq 'ADMIN'}">
                            <span class="badge badge-primary ms-1" style="font-size: 0.65rem;">Admin</span>
                        </c:if>
                    </span>
                    <a href="${pageContext.request.contextPath}/logout" 
                       class="btn btn-ghost btn-icon" 
                       title="Đăng xuất" 
                       aria-label="Đăng xuất">
                        <i class="fa-solid fa-arrow-right-from-bracket"></i>
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-sm">
                        Đăng nhập
                    </a>
                </c:otherwise>
            </c:choose>

            <!-- Mobile Hamburger Toggle -->
            <button type="button" 
                    class="btn btn-ghost btn-icon md-hidden" 
                    id="mobileMenuToggle" 
                    aria-label="Menu"
                    onclick="toggleMobileMenu()">
                <i class="fa-solid fa-bars" style="font-size: 1.1rem;"></i>
            </button>
        </div>
    </div>

    <!-- Mobile Drawer Menu -->
    <div class="mobile-menu-drawer" id="mobileMenuDrawer">
        <nav class="d-grid gap-1">
            <a href="${pageContext.request.contextPath}/index.jsp" 
               class="nav-link-item ${reqPath eq '/' or reqPath eq '/index.jsp' ? 'active' : ''}">
                Trang chủ
            </a>
            <a href="${pageContext.request.contextPath}/words" 
               class="nav-link-item ${reqPath.startsWith('/words') and sessionScope.user.role ne 'ADMIN' ? 'active' : ''}">
                Từ vựng
            </a>
            <a href="${pageContext.request.contextPath}/flashcard" 
               class="nav-link-item ${reqPath.startsWith('/flashcard') ? 'active' : ''}">
                Flashcard
            </a>
            <a href="${pageContext.request.contextPath}/quiz" 
               class="nav-link-item ${reqPath.startsWith('/quiz') ? 'active' : ''}">
                Kiểm tra
            </a>
            <a href="${pageContext.request.contextPath}/progress" 
               class="nav-link-item ${reqPath.startsWith('/progress') ? 'active' : ''}">
                Thống kê
            </a>
            <c:if test="${sessionScope.user.role eq 'ADMIN'}">
                <a href="${pageContext.request.contextPath}/words" 
                   class="nav-link-item ${reqPath.startsWith('/words') ? 'active' : ''}"
                   style="color: var(--primary); font-weight: 600;">
                    <i class="fa-solid fa-list-check me-1"></i> Quản lý từ vựng
                </a>
                <a href="${pageContext.request.contextPath}/admin/users" 
                   class="nav-link-item ${reqPath.startsWith('/admin') ? 'active' : ''}"
                   style="color: var(--primary); font-weight: 600;">
                    <i class="fa-solid fa-chart-pie me-1"></i> Thống kê học viên
                </a>
            </c:if>
            <c:if test="${empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/register" 
                   class="nav-link-item">
                    Tạo tài khoản mới
                </a>
            </c:if>
        </nav>
    </div>
</header>
