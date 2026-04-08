<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Material Configuration</title>
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
        <h1 class="header-title">Mats Compendium</h1>
        <div style="display: flex; gap: 8px; align-items: center;">
            <button type="button" id="sortBtn" class="btn-secondary" style="font-size: 11px; padding: 6px 14px;" onclick="toggleSort()">Sort By: Name</button>
            <button type="button" id="dirBtn" class="btn-secondary" style="font-size: 11px; padding: 6px 14px;" onclick="toggleDir()">Order: ASC</button>
        </div>
        <!-- ===== THEME TOGGLE ===== -->
        <button class="theme-toggle" id="themeToggle" onclick="cycleTheme()" title="Toggle Theme">
            <span class="theme-toggle-icon" id="themeIcon">🌑</span>
            <span class="theme-toggle-label" id="themeLabel">Dark</span>
        </button>
    </div>

    <!-- Maintain vertical stacking for better space mapping as requested earlier! -->
    <div class="card-panel">
        <h2>${itemEdit != null ? 'Edit Chronicle' : 'Add New Record'}</h2>
        <form action="material" method="post">
            <input type="hidden" name="id" value="${itemEdit.id}" />
            <div class="form-row">
                <div class="input-group">
                    <span class="input-label">Name</span>
                    <input type="text" name="name" value="${itemEdit.name}" class="input-field" placeholder="E.g., Iron Ingot" required />
                </div>
                <div class="input-group">
                    <span class="input-label">EMC</span>
                    <input type="number" step="1" min="0" name="emc" value="${itemEdit.emcValue}" class="input-field" placeholder="E.g., 256" required />
                </div>
                <button type="submit" class="btn-primary" style="color:white;">${itemEdit != null ? 'Update Record' : 'Inscribe Record'}</button>
                <c:if test="${itemEdit != null}">
                    <a href="material" class="btn-cancel">Discard</a>
                </c:if>
            </div>
        </form>
    </div>

    <div class="card-panel">
        <table class="styled-table mat-table">
            <thead>
                <tr>
                    <th width="10%">No.</th>
                    <th width="40%">Artifact Name</th>
                    <th width="25%">Value (EMC)</th>
                    <th width="25%">Directives</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty materials}">
                        <tr>
                            <td colspan="4" class="empty-state">No records inscribed. Commence drafting above.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${materials}" var="m" varStatus="loop">
                            <tr>
                                <td style="color: #888;">#${loop.count}</td>
                                <td class="text-gold-force" style="font-weight: 700;">${m.name}</td>
                                <td><span class="badge text-gold-force" style="border: 1px solid #F5C518;">${m.emcValue}</span></td>
                                <td>
                                    <div class="action-group">
                                        <a href="material?action=edit&id=${m.id}" class="btn-blue" style="font-size:11px;">Update Record</a>
                                        <a href="material?action=delete&id=${m.id}" class="btn-del" onclick="return confirm('Erase this record completely?')">Purge</a>
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

<script>
    let sortMode = 'Name'; 
    let sortDir = 'ASC';
    
    function toggleDir() {
        sortDir = (sortDir === 'ASC') ? 'DESC' : 'ASC';
        document.getElementById('dirBtn').textContent = 'Order: ' + sortDir;
        renderSorted();
    }

    function toggleSort() {
        sortMode = (sortMode === 'Name') ? 'EMC' : 'Name';
        document.getElementById('sortBtn').textContent = 'Sort By: ' + sortMode;
        renderSorted();
    }

    function renderSorted() {
        const gridBody = document.querySelector('.mat-table tbody');
        const rows = Array.from(gridBody.querySelectorAll('tr')).filter(r => !r.querySelector('.empty-state'));
        if (rows.length === 0) return;
        
        rows.sort((a, b) => {
            let valA, valB;
            if (sortMode === 'EMC') {
                valA = parseInt(a.querySelector('.badge').textContent);
                valB = parseInt(b.querySelector('.badge').textContent);
            } else {
                valA = a.cells[1].textContent.toLowerCase();
                valB = b.cells[1].textContent.toLowerCase();
            }
            
            let res = 0;
            if (valA < valB) res = -1;
            if (valA > valB) res = 1;
            return (sortDir === 'ASC') ? res : -res;
        });
        
        gridBody.innerHTML = '';
        rows.forEach((r, idx) => {
            r.cells[0].textContent = '#' + (idx + 1);
            gridBody.appendChild(r);
        });
    }
</script>






</body>
</html>