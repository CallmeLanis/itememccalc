<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>All Data Overview</title>
        <link rel="stylesheet" href="css/style.css">
    <!-- ===== NO-FLASH THEME INIT ===== -->
    <script>
    (function(){
        var t = localStorage.getItem('emc-theme');
        if (t === 'anime') t = 'dark';
        document.documentElement.setAttribute('data-theme', t || 'dark');
    })();
    </script>
    <script src="css/theme.js"></script>
</head>
<body>
<nav class="sidebar">
    <div class="sidebar-logo">Menu</div>
        <ul class="nav-list">
        <li><a href="main"><i class="icon">🏠</i> <span class="nav-text">Home</span></a></li>
        <li><a href="material"><i class="icon">🍱</i> <span class="nav-text">Materials</span></a></li>
        <li><a href="saved"><i class="icon">📥</i> <span class="nav-text">Saved Items</span></a></li>
        <li><a href="gunorigin"><i class="icon">📦</i> <span class="nav-text">Base Guns</span></a></li>
        <li><a href="fullgun"><i class="icon">🛠️</i> <span class="nav-text">Custom Guns</span></a></li>
        <li><a href="overview"><i class="icon">📊</i> <span class="nav-text">Overview</span></a></li>
        <li><a href="quickload"><i class="icon">⇌</i> <span class="nav-text">Import / Export</span></a></li>
        <li><a href="cleandb"><i class="icon">🧹</i> <span class="nav-text">Clean Table</span></a></li>
    </ul>
</nav>

<div class="container">
    <div class="header-top">
                    <h1 class="header-title">Data Overview</h1>
                    <!-- ===== THEME TOGGLE ===== -->
                    <button class="theme-toggle" id="themeToggle" onclick="cycleTheme()" title="Toggle Theme">
                        <span class="theme-toggle-icon" id="themeIcon">🌑</span>
                        <span class="theme-toggle-label" id="themeLabel">Dark</span>
                    </button>
                </div>

    <div class="flex-layout">
        <!-- Mats -->
        <div class="card-panel">
            <h2>Vanilla Materials</h2>
            <c:choose>
                <c:when test="${empty materials}">
                    <div class="empty-state">No Data Found.</div>
                </c:when>
                <c:otherwise>
                    <table class="styled-table">
                        <thead><tr><th>Name</th><th>EMC</th></tr></thead>
                        <tbody>
                            <c:forEach items="${materials}" var="m">
                                <tr><td>${m.name}</td><td><span class="badge">${m.emcValue}</span></td></tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Attachments -->
        <div class="card-panel">
            <h2>Attachments</h2>
            <c:choose>
                <c:when test="${empty attachments}">
                    <div class="empty-state">No Data Found.</div>
                </c:when>
                <c:otherwise>
                    <table class="styled-table">
                        <thead><tr><th>Name</th><th>EMC</th></tr></thead>
                        <tbody>
                            <c:forEach items="${attachments}" var="a">
                                <tr><td>${a.name}</td><td><span class="badge">${a.totalEmc}</span></td></tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Gun Origins (Session) -->
        <div class="card-panel">
            <h2>Base Guns</h2>
            <c:choose>
                <c:when test="${empty basicGunList}">
                    <div class="empty-state">No Data Found.</div>
                </c:when>
                <c:otherwise>
                    <table class="styled-table">
                        <thead><tr><th>Name</th><th>EMC</th></tr></thead>
                        <tbody>
                            <c:forEach items="${basicGunList}" var="bg">
                                <tr><td>${bg.name}</td><td><span class="badge">${bg.totalEmc}</span></td></tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Full Custom Guns (Session) -->
        <div class="card-panel">
            <h2>Custom Guns</h2>
            <c:choose>
                <c:when test="${empty gunList}">
                    <div class="empty-state">No Data Found.</div>
                </c:when>
                <c:otherwise>
                    <table class="styled-table">
                        <thead><tr><th>Name</th><th>EMC</th></tr></thead>
                        <tbody>
                            <c:forEach items="${gunList}" var="cg">
                                <tr><td>${cg.name}</td><td><span class="badge">${cg.totalEmc}</span></td></tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>



</body>
</html>
