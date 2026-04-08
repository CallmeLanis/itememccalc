<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Full Accessory Gun</title>
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
                    <h1 class="header-title">Custom Gun Builder</h1>
                    <!-- ===== THEME TOGGLE ===== -->
                    <button class="theme-toggle" id="themeToggle" onclick="cycleTheme()" title="Toggle Theme">
                        <span class="theme-toggle-icon" id="themeIcon">🌑</span>
                        <span class="theme-toggle-label" id="themeLabel">Dark</span>
                    </button>
                </div>

    <div class="card-panel">
        <form action="fullgun" method="post">
            <input type="hidden" name="action" value="calcGun" />
            <div class="input-group">
                <span class="input-label">Gun Name</span>
                <input type="text" name="gunName" class="input-field" required />
            </div>


            
            <div style="display: flex; gap: 20px; flex-wrap: wrap;">
                <div style="flex: 1; min-width: 300px;">
                    <h3 class="text-gold-force">Vanilla Mats</h3>
                    <div style="overflow-x: auto;">
                        <table class="styled-table">
                            <tbody>
                                <tr>
                                <c:forEach items="${materials}" var="m" varStatus="st">
                                    <td style="text-align: center; border-radius: 12px;">
                                        <div style="font-weight: 700; font-size: 0.8em; margin-bottom: 5px;">${m.name}</div>
                                        <input type="number" name="mat_${m.id}" class="minimal-input" value="0" min="0" step="1" style="width: 45px;" />
                                    </td>
                                    <c:if test="${st.count % 5 == 0 && !st.last}"></tr><tr></c:if>
                                </c:forEach>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div style="flex: 1; min-width: 300px;">
                    <h3 class="text-gold-force">Attachments</h3>
                    <div style="overflow-x: auto;">
                        <table class="styled-table">
                            <tbody>
                                <tr>
                                <c:forEach items="${subItemList}" var="s" varStatus="st">
                                    <td style="text-align: center; border-radius: 12px;">
                                        <div style="font-weight: 700; font-size: 0.8em; margin-bottom: 5px;">${s.name}</div>
                                        <input type="number" name="att_${s.id}" class="minimal-input" value="0" min="0" step="1" style="width: 45px;" />
                                    </td>
                                    <c:if test="${st.count % 5 == 0 && !st.last}"></tr><tr></c:if>
                                </c:forEach>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div style="flex: 1; min-width: 300px;">
                    <h3 class="text-gold-force">Gun Origins</h3>
                    <div style="overflow-x: auto;">
                        <table class="styled-table">
                            <tbody>
                                <tr>
                                <c:forEach items="${basicGunList}" var="g" varStatus="st">
                                    <td style="text-align: center; border-radius: 12px;">
                                        <div style="font-weight: 700; font-size: 0.8em; margin-bottom: 5px;">${g.name}</div>
                                        <input type="number" name="origin_${g.id}" class="minimal-input" value="0" min="0" step="1" style="width: 45px;" />
                                    </td>
                                    <c:if test="${st.count % 5 == 0 && !st.last}"></tr><tr></c:if>
                                </c:forEach>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            
            <div class="card-panel" style="margin-top: 25px;">
                <h2 class="text-gold-force">Block 2: Final Integration</h2>
                <button type="submit" class="btn-primary" style="width: 100%; color: #F5C518 !important; font-weight: 800; font-size: 1.1em; margin-top: 10px;">
                    [ CALCULATE & SAVE CUSTOM GUN ]
                </button>
            </div>
        </form>
    </div>

    <!-- Permanent Result Grid (5 per row) -->
    <c:if test="${not empty gunList}">
        <div style="margin-top: 40px;">
            <h2 class="text-gold-force" style="text-align: center; margin-bottom: 30px;">Strategic Custom Gun Deployments</h2>
            <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px;">
                <c:forEach items="${gunList}" var="g">
                    <div class="card-panel" style="margin: 0; display: flex; flex-direction: column; gap: 15px; border-top: 3px solid #F5C518;">
                        <div style="display: flex; gap: 10px; justify-content: space-between; align-items: stretch;">
                            <span class="box-gold" style="flex: 1; text-align: center; display: flex; align-items: center; justify-content: center;">${g.name}</span>
                            <span class="box-gold" style="width: 120px; text-align: center; display: flex; align-items: center; justify-content: center;">${g.totalEmc} EMC</span>
                        </div>
                        
                        <div class="saved-base-block" style="padding: 12px; border-radius: 8px; flex: 1;">
                            <span style="font-size: 0.8em; opacity: 0.6; display: block; margin-bottom: 10px;">Inventory:</span>
                            <div style="display: flex; flex-wrap: wrap; gap: 10px;">
                                <c:forEach items="${g.materialDetails}" var="d">
                                    <span class="text-gold-force" style="font-size: 0.9em; font-weight: 700;">${d.name}: ${d.qty}</span>
                                </c:forEach>
                            </div>
                        </div>

                        <div style="text-align: right;">
                            <a href="fullgun?action=delGun&id=${g.id}" class="btn-del" style="font-size: 11px; padding: 6px 15px;" onclick="return confirm('Archive gun data?')">Purge Record</a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>


</body>
</html>
