<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <html>

        <head>
            <title>EMC Calculator</title>
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
                    <h1 class="header-title">EMC Calculator</h1>
                    <!-- ===== THEME TOGGLE ===== -->
                    <button class="theme-toggle" id="themeToggle" onclick="cycleTheme()" title="Toggle Theme">
                        <span class="theme-toggle-icon" id="themeIcon">🌑</span>
                        <span class="theme-toggle-label" id="themeLabel">Dark</span>
                    </button>
                </div>

                <!-- 2 Block Horizontal Layout -->
                <div class="flex-layout">
                    <div class="card-panel" style="animation-delay: 0.1s;">
                        <h2 style="margin-bottom: 20px;">Step 1: Vanilla Materials</h2>
                        <form action="main" method="post">
                            <input type="hidden" name="action" value="saveSubItem" />
                            <div class="input-group">
                                <span class="input-label">Name</span>
                                <input type="text" name="subItemName" class="input-field attach-name"
                                    placeholder="E.g., Iron Sight" style="flex:1" required />
                            </div>
                            <div style="display: flex; gap: 8px; margin-bottom: 20px; align-items: center;">
                                <button type="button" id="sortBtn" class="btn-secondary" style="font-size: 11px; padding: 6px 14px;" onclick="toggleSort()">Sort By: Name</button>
                                <button type="button" id="dirBtn" class="btn-secondary" style="font-size: 11px; padding: 6px 14px;" onclick="toggleDir()">Order: ASC</button>
                            </div>

                            <!-- 5-per-row Material Grid -->
                            <div style="overflow-x: auto;">
                                <table class="styled-table" style="width: 100%; table-layout: fixed;">
                                    <colgroup>
                                        <col style="width:20%"><col style="width:20%"><col style="width:20%">
                                        <col style="width:20%"><col style="width:20%">
                                    </colgroup>
                                    <tbody>
                                        <tr>
                                        <c:forEach items="${materials}" var="m" varStatus="st">
                                            <td>
                                                <div class="mat-cell">
                                                    <span class="mat-name">${m.name}</span>
                                                    <span class="badge">${m.emcValue}</span>
                                                    <input type="number" name="qty_${m.id}"
                                                        class="minimal-input" value="0" min="0" step="1" />
                                                </div>
                                            </td>
                                            <c:if test="${st.count % 5 == 0 && !st.last}">
                                                </tr><tr>
                                            </c:if>
                                        </c:forEach>
                                        <!-- Fill empty cells if not a multiple of 5 -->
                                        <c:if test="${materials.size() % 5 != 0}">
                                            <c:forEach begin="1" end="${5 - (materials.size() % 5)}">
                                                <td style="background: transparent; box-shadow: none;"></td>
                                            </c:forEach>
                                        </c:if>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>

                            <button type="submit" class="btn-primary" style="margin-top: 20px;">Forge Attachment</button>
                        </form>
                    </div>

                    <div class="card-panel" style="animation-delay: 0.3s;">
                        <h2 style="margin-bottom: 25px;">Step 2: Tacz Attachments</h2>
                        <div style="overflow-x: auto;">
                            <table id="attachTable">
                                <thead>
                                    <tr>
                                        <th>Name</th>
                                        <th>Unit EMC</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${subItemList}" var="s">
                                        <tr>
                                            <td style="font-weight: 600;">${s.name}</td>
                                            <td>${s.totalEmc}</td>
                                            <td>
                                                <a href="main?action=delSub&id=${s.id}&origin=home" class="btn-del" onclick="return confirm('Purge record?')">Del</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
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
            const gridBody = document.querySelector('.styled-table tbody');
            const cells = Array.from(gridBody.querySelectorAll('td')).filter(td => td.querySelector('.mat-cell'));
            
            cells.sort((a, b) => {
                let valA, valB;
                if (sortMode === 'EMC') {
                    valA = parseInt(a.querySelector('.badge').textContent);
                    valB = parseInt(b.querySelector('.badge').textContent);
                } else {
                    valA = a.querySelector('.mat-name').textContent.toLowerCase();
                    valB = b.querySelector('.mat-name').textContent.toLowerCase();
                }
                
                let res = 0;
                if (valA < valB) res = -1;
                if (valA > valB) res = 1;
                return (sortDir === 'ASC') ? res : -res;
            });
            
            gridBody.innerHTML = '';
            let currentRow = document.createElement('tr');
            cells.forEach((td, index) => {
                currentRow.appendChild(td);
                if ((index + 1) % 5 === 0) {
                    gridBody.appendChild(currentRow);
                    currentRow = document.createElement('tr');
                }
            });
            
            if (cells.length % 5 !== 0) {
                for (let i = 0; i < (5 - (cells.length % 5)); i++) {
                    const filler = document.createElement('td');
                    filler.style.background = 'transparent';
                    currentRow.appendChild(filler);
                }
                gridBody.appendChild(currentRow);
            }
        }
    </script>
</body>

        </html>