<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Quick Load & Export</title>
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
                    <h1 class="header-title">Import / Export</h1>
                    <!-- ===== THEME TOGGLE ===== -->
                    <button class="theme-toggle" id="themeToggle" onclick="cycleTheme()" title="Toggle Theme">
                        <span class="theme-toggle-icon" id="themeIcon">🌑</span>
                        <span class="theme-toggle-label" id="themeLabel">Dark</span>
                    </button>
                </div>

    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
        <!-- Method 1: Vanilla Mats -->
        <div class="card-panel">
            <h2 class="text-gold-force">Method 1: Vanilla Mats</h2>
            <form action="quickload" method="post">
                <textarea name="vanillaData" class="input-field" style="width: 100%; height: 100px; font-family: monospace;" placeholder="Name,EMC">${vanillaExport}</textarea>
                <div style="display: flex; gap:10px; margin-top:10px;">
                    <button type="submit" name="action" value="loadVanilla" class="btn-primary" style="flex:1; color: #F5C518 !important; font-weight: 800;">[ LOAD TO DB ]</button>
                    <button type="submit" name="action" value="exportVanilla" class="btn-secondary" style="flex:1;">Export</button>
                </div>
                <div class="info-text" style="width: 100%; margin-top: 15px; margin-bottom: 0; box-sizing: border-box;">Example: diamond,8192</div>
            </form>
            <c:if test="${not empty msg1}"><div class="badge" style="margin-top:10px;">${msg1}</div></c:if>
        </div>

        <!-- Method 2: Attachments -->
        <div class="card-panel">
            <h2 class="text-gold-force">Method 2: Attachments</h2>
            <form action="quickload" method="post">
                <textarea name="attachmentData" class="input-field" style="width: 100%; height: 100px; font-family: monospace;" placeholder="Name,EMC,Mat:Qty|Mat:Qty">${attachmentExport}</textarea>
                <div style="display: flex; gap:10px; margin-top:10px;">
                    <button type="submit" name="action" value="loadAttachment" class="btn-primary" style="flex:1; color: #F5C518 !important; font-weight: 800;">[ LOAD TO DB ]</button>
                    <button type="submit" name="action" value="exportAttachment" class="btn-secondary" style="flex:1;">Export</button>
                </div>
                <div class="info-text" style="width: 100%; margin-top: 15px; margin-bottom: 0; box-sizing: border-box;">Example: Iron Sight,2000,Iron Ingot:4|Glass:1</div>
            </form>
            <c:if test="${not empty msg2}"><div class="badge" style="margin-top:10px;">${msg2}</div></c:if>
        </div>

        <!-- Method 3: Gun Origins -->
        <div class="card-panel">
            <h2 class="text-gold-force">Method 3: Gun Origins</h2>
            <form action="quickload" method="post">
                <textarea name="originData" class="input-field" style="width: 100%; height: 100px; font-family: monospace;" placeholder="Name,EMC,Mat:Qty|Att:Qty">${originExport}</textarea>
                <div style="display: flex; gap:10px; margin-top:10px;">
                    <button type="submit" name="action" value="loadGunOrigin" class="btn-primary" style="flex:1; color: #F5C518 !important; font-weight: 800;">[ LOAD TO DB ]</button>
                    <button type="submit" name="action" value="exportGunOrigin" class="btn-secondary" style="flex:1;">Export</button>
                </div>
                <div class="info-text" style="width: 100%; margin-top: 15px; margin-bottom: 0; box-sizing: border-box;">Example: AK-47,15000,Iron Ingot:10|Wood:5</div>
            </form>
            <c:if test="${not empty msg3}"><div class="badge" style="margin-top:10px;">${msg3}</div></c:if>
        </div>

        <!-- Method 4: Custom Guns -->
        <div class="card-panel">
            <h2 class="text-gold-force">Method 4: Custom Guns</h2>
            <form action="quickload" method="post">
                <textarea name="customData" class="input-field" style="width: 100%; height: 100px; font-family: monospace;" placeholder="Name,EMC,Origin:1|Att:2">${customExport}</textarea>
                <div style="display: flex; gap:10px; margin-top:10px;">
                    <button type="submit" name="action" value="loadCustomGun" class="btn-primary" style="flex:1; color: #F5C518 !important; font-weight: 800;">[ LOAD TO DB ]</button>
                    <button type="submit" name="action" value="exportCustomGun" class="btn-secondary" style="flex:1;">Export</button>
                </div>
                <div class="info-text" style="width: 100%; margin-top: 15px; margin-bottom: 0; box-sizing: border-box;">Example: Golden AK-47,25000,AK-47:1|Gold Ingot:5</div>
            </form>
            <c:if test="${not empty msg4}"><div class="badge" style="margin-top:10px;">${msg4}</div></c:if>
        </div>
    </div>
</div>




</body>
</html>
