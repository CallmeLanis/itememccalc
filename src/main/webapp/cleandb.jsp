<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Clean Data Records</title>
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
        <h1 class="header-title">Clean Table Records</h1>
        <!-- ===== THEME TOGGLE ===== -->
        <button class="theme-toggle" id="themeToggle" onclick="cycleTheme()" title="Toggle Theme">
            <span class="theme-toggle-icon" id="themeIcon">🌑</span>
            <span class="theme-toggle-label" id="themeLabel">Dark</span>
        </button>
    </div>

    <div class="card-panel" style="max-width: 800px; margin: 0 auto;">
        <h2>Database Sanitization</h2>
        <c:if test="${not empty actionMsg}">
            <div class="msg" style="width: 100%; text-align: center; margin-bottom: 25px;">${actionMsg}</div>
        </c:if>
        
        <div class="info-text" style="display: block; text-align: center; margin-bottom: 30px;">
            Warning: These actions are permanent. Ensure you have exported your data before cleaning.
        </div>

        <table class="styled-table">
            <thead>
                <tr>
                    <th style="width: 60%">Table Name</th>
                    <th style="width: 20%; text-align: center;">Record Count</th>
                    <th style="width: 20%; text-align: center;">Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="entry" items="${tableCounts}">
                    <tr>
                        <td style="font-weight: 700; text-transform: uppercase; letter-spacing: 1px;">
                            ${entry.key}
                        </td>
                        <td style="text-align: center;">
                            <span class="badge ${entry.value > 0 ? '' : 'badge-dim'}">
                                ${entry.value}
                            </span>
                        </td>
                        <td style="text-align: center;">
                            <form action="cleandb" method="post" style="margin: 0;" onsubmit="return confirm('wanna del this table?')">
                                <input type="hidden" name="table" value="${entry.key}">
                                <button type="submit" class="btn-del" style="cursor: pointer;">Del</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>
