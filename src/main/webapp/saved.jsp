<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Saved Items</title>
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
                    <h1 class="header-title">Stored Item List</h1>
                    <!-- ===== THEME TOGGLE ===== -->
                    <button class="theme-toggle" id="themeToggle" onclick="cycleTheme()" title="Toggle Theme">
                        <span class="theme-toggle-icon" id="themeIcon">🌑</span>
                        <span class="theme-toggle-label" id="themeLabel">Dark</span>
                    </button>
                </div>

          <table>
            <thead>
                <tr>
                    <th width="10%">No.</th>
                    <th width="35%">Sub-Item Manifest</th>
                    <th width="20%">Total Unit Cost</th>
                    <th width="20%">Details</th>
                    <th width="15%">Directives</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty subItemList}">
                        <tr>
                            <td colspan="5" class="empty-state">No Sub-Items recorded. Initialize sequence at the Forge.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${subItemList}" var="s" varStatus="loop">
                            <tr>
                                <td style="color: #888;">#${loop.count}</td>
                                <td style="font-weight: 600;">${s.name}</td>
                                <td class="emc-tag">${s.totalEmc} EMC</td>
                                <td>
                                    <ul class="details-list">
                                        <c:forEach items="${s.materialDetails}" var="d">
                                            <li>${d.name}: ${d.qty}</li>
                                        </c:forEach>
                                    </ul>
                                </td>
                                <td>
                                    <div class="action-group">
                                        <a href="main?action=delSub&id=${s.id}" class="btn-del" onclick="return confirm('Purge record?')">Del</a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>




</body>
</html>
