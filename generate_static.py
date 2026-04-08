import os

docs_dir = "."

def write_file(filename, content):
    with open(os.path.join(docs_dir, filename), "w", encoding="utf-8") as f:
        f.write(content.strip() + "\n")

# --- ALL HTML PAGES ---
html_template = """<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>{title}</title>
    <link rel="stylesheet" href="src/main/webapp/css/style.css">
    <script>
    (function(){{
        var t = localStorage.getItem('emc-theme');
        if (t === 'anime') t = 'dark';
        document.documentElement.setAttribute('data-theme', t || 'dark');
    }})();
    </script>
    <script src="src/main/webapp/css/theme.js"></script>
    <script src="js/db.js" defer></script>
    <script src="js/{script_name}.js" defer></script>
</head>
<body>
<nav class="sidebar">
    <div class="sidebar-logo">Menu</div>
    <ul class="nav-list">
        <li><a href="index.html"><i class="icon">🏠</i> <span class="nav-text">Launchpad</span></a></li>
        <li><a href="home.html"><i class="icon">🏠</i> <span class="nav-text">Home</span></a></li>
        <li><a href="material.html"><i class="icon">🍱</i> <span class="nav-text">Materials</span></a></li>
        <li><a href="saved.html"><i class="icon">📥</i> <span class="nav-text">Saved Items</span></a></li>
        <li><a href="gunorigin.html"><i class="icon">📦</i> <span class="nav-text">Base Guns</span></a></li>
        <li><a href="fullgun.html"><i class="icon">🛠️</i> <span class="nav-text">Custom Guns</span></a></li>
        <li><a href="overview.html"><i class="icon">📊</i> <span class="nav-text">Overview</span></a></li>
        <li><a href="quickload.html"><i class="icon">⇌</i> <span class="nav-text">Import / Export</span></a></li>
        <li><a href="cleandb.html"><i class="icon">🧹</i> <span class="nav-text">Clean Table</span></a></li>
    </ul>
</nav>

<div class="container">
    <div class="header-top">
        <h1 class="header-title">{title}</h1>
        {header_extra}
        <button class="theme-toggle" id="themeToggle" onclick="cycleTheme()" title="Toggle Theme">
            <span class="theme-toggle-icon" id="themeIcon">🌑</span>
            <span class="theme-toggle-label" id="themeLabel">Dark</span>
        </button>
    </div>
    {content}
</div>
</body>
</html>"""

# Ensure js dir exists
os.makedirs(os.path.join(docs_dir, "js"), exist_ok=True)

# 1. db.js
write_file("js/db.js", """
const DB = {
    get: (key) => JSON.parse(localStorage.getItem(key) || '[]'),
    set: (key, val) => localStorage.setItem(key, JSON.stringify(val)),
    guid: () => Math.random().toString(36).substring(2, 10)
};

// Initial setup
if(!localStorage.getItem('materials')) DB.set('materials', []);
if(!localStorage.getItem('attachments')) DB.set('attachments', []);
if(!localStorage.getItem('basicGuns')) DB.set('basicGuns', []);
if(!localStorage.getItem('customGuns')) DB.set('customGuns', []);
""")

# 2. material
write_file("js/material.js", """
document.addEventListener('DOMContentLoaded', () => {
    let mats = DB.get('materials');
    const tbody = document.getElementById('mat-tbody');
    let editId = null;
    
    function render() {
        if(mats.length === 0) {
            tbody.innerHTML = '<tr><td colspan="4" class="empty-state">No records inscribed.</td></tr>';
            return;
        }
        tbody.innerHTML = mats.map((m, i) => `
            <tr>
                <td style="color:#888">#${i+1}</td>
                <td class="text-gold-force" style="font-weight:700">${m.name}</td>
                <td><span class="badge text-gold-force" style="border: 1px solid #F5C518;">${m.emcValue}</span></td>
                <td>
                    <div class="action-group">
                        <button type="button" onclick="editMat('${m.id}')" class="btn-blue" style="font-size:11px;">Edit</button>
                        <button type="button" onclick="delMat('${m.id}')" class="btn-del">Purge</button>
                    </div>
                </td>
            </tr>
        `).join('');
    }
    
    window.editMat = (id) => {
        const m = mats.find(x => x.id === id);
        if(m) {
            document.getElementById('m-name').value = m.name;
            document.getElementById('m-emc').value = m.emcValue;
            editId = m.id;
            document.getElementById('form-title').innerText = 'Edit Chronicle';
            document.getElementById('submit-btn').innerText = 'Update Record';
        }
    };
    
    window.delMat = (id) => {
        if(confirm('Erase this record?')) {
            mats = mats.filter(x => x.id !== id);
            DB.set('materials', mats);
            render();
        }
    };
    
    document.getElementById('mat-form').onsubmit = (e) => {
        e.preventDefault();
        const name = document.getElementById('m-name').value;
        const emc = parseInt(document.getElementById('m-emc').value);
        if(editId) {
            const m = mats.find(x => x.id === editId);
            m.name = name; m.emcValue = emc;
            editId = null;
            document.getElementById('form-title').innerText = 'Add New Record';
            document.getElementById('submit-btn').innerText = 'Inscribe Record';
        } else {
            mats.push({ id: DB.guid(), name, emcValue: emc });
        }
        DB.set('materials', mats);
        document.getElementById('mat-form').reset();
        render();
    };
    
    render();
});
""")

write_file("material.html", html_template.format(
    title="Mats Compendium",
    script_name="material",
    header_extra="",
    content="""
    <div class="card-panel">
        <h2 id="form-title">Add New Record</h2>
        <form id="mat-form">
            <div class="form-row">
                <div class="input-group">
                    <span class="input-label">Name</span>
                    <input type="text" id="m-name" class="input-field" placeholder="E.g., Iron Ingot" required />
                </div>
                <div class="input-group">
                    <span class="input-label">EMC</span>
                    <input type="number" id="m-emc" class="input-field" required />
                </div>
                <button type="submit" id="submit-btn" class="btn-primary" style="color:white;">Inscribe Record</button>
            </div>
        </form>
    </div>
    <div class="card-panel">
        <table class="styled-table mat-table">
            <thead><tr><th width="10%">No.</th><th width="40%">Artifact Name</th><th width="25%">Value (EMC)</th><th width="25%">Directives</th></tr></thead>
            <tbody id="mat-tbody"></tbody>
        </table>
    </div>
    """
))

# 3. home (Forge Attachment)
write_file("js/home.js", """
document.addEventListener('DOMContentLoaded', () => {
    const mats = DB.get('materials');
    const atts = DB.get('attachments');
    
    const matTbody = document.getElementById('mats-container');
    
    let html = '';
    mats.forEach((m, i) => {
        if(i % 5 === 0) html += '<tr>';
        html += `
        <td>
            <div class="mat-cell">
                <span class="mat-name">${m.name}</span>
                <span class="badge">${m.emcValue}</span>
                <input type="number" class="minimal-input mat-qty" data-emc="${m.emcValue}" value="0" min="0" />
            </div>
        </td>`;
        if((i+1) % 5 === 0) html += '</tr>';
    });
    // paddings if not multiple of 5
    if (mats.length % 5 !== 0) {
        for(let i=0; i < (5 - (mats.length % 5)); i++) html += '<td style="background:transparent;box-shadow:none;"></td>';
        html += '</tr>';
    }
    matTbody.innerHTML = html;
    
    function renderTbody() {
        const tbody = document.getElementById('att-tbody');
        tbody.innerHTML = atts.map(a => `
            <tr>
                <td style="font-weight:600">${a.name}</td>
                <td>${a.totalEmc}</td>
                <td><button type="button" onclick="delAtt('${a.id}')" class="btn-del">Del</button></td>
            </tr>
        `).join('');
    }
    
    window.delAtt = (id) => {
        if(confirm('Purge?')) {
            const items = DB.get('attachments').filter(x => x.id !== id);
            DB.set('attachments', items);
            atts.length = 0; atts.push(...items);
            renderTbody();
        }
    };
    
    document.getElementById('forge-form').onsubmit = (e) => {
        e.preventDefault();
        const name = document.getElementById('att-name').value;
        let emc = 0;
        document.querySelectorAll('.mat-qty').forEach(inp => {
            emc += parseInt(inp.value) * parseInt(inp.dataset.emc);
            inp.value = 0;
        });
        atts.push({ id: DB.guid(), name, totalEmc: emc });
        DB.set('attachments', atts);
        document.getElementById('forge-form').reset();
        renderTbody();
    };
    
    renderTbody();
});
""")

write_file("home.html", html_template.format(
    title="Forge Attachment",
    script_name="home",
    header_extra="",
    content="""
    <div class="flex-layout">
        <div class="card-panel">
            <h2>Step 1: Vanilla Materials</h2>
            <form id="forge-form">
                <div class="input-group">
                    <span class="input-label">Name</span>
                    <input type="text" id="att-name" class="input-field" placeholder="E.g., Iron Sight" required />
                </div>
                <div style="overflow-x: auto;">
                    <table class="styled-table" style="width:100%; table-layout:fixed;">
                        <tbody id="mats-container"></tbody>
                    </table>
                </div>
                <button type="submit" class="btn-primary" style="margin-top:20px;">Forge Attachment</button>
            </form>
        </div>
        <div class="card-panel">
            <h2>Step 2: Tacz Attachments</h2>
            <table class="styled-table">
                <thead><tr><th>Name</th><th>Unit EMC</th><th>Actions</th></tr></thead>
                <tbody id="att-tbody"></tbody>
            </table>
        </div>
    </div>
    """
))

# 4. saved
write_file("js/saved.js", """
document.addEventListener('DOMContentLoaded', () => {
    let atts = DB.get('attachments');
    
    function render() {
        const tbody = document.getElementById('att-tbody');
        if(atts.length===0) { tbody.innerHTML = `<tr><td colspan="3" class="empty-state">No saved attachments</td></tr>`; return;}
        tbody.innerHTML = atts.map(a => `
            <tr>
                <td style="font-weight:600">${a.name}</td>
                <td><span class="badge badge-dim">${a.totalEmc}</span></td>
                <td><button type="button" onclick="delAtt('${a.id}')" class="btn-del">Del</button></td>
            </tr>
        `).join('');
    }
    
    window.delAtt = (id) => {
        if(confirm('Purge?')) {
            atts = atts.filter(x => x.id !== id);
            DB.set('attachments', atts);
            render();
        }
    };
    render();
});
""")

write_file("saved.html", html_template.format(
    title="Saved Items",
    script_name="saved",
    header_extra="",
    content="""
    <div class="card-panel">
        <h2>Attachments</h2>
        <table class="styled-table saved-base-block">
            <thead><tr><th>Name</th><th>Total EMC</th><th>Actions</th></tr></thead>
            <tbody id="att-tbody"></tbody>
        </table>
    </div>
    """
))

# 5. gunorigin
write_file("js/gunorigin.js", """
document.addEventListener('DOMContentLoaded', () => {
    const mats = DB.get('materials');
    const guns = DB.get('basicGuns');
    
    const matTbody = document.getElementById('mats-container');
    
    let html = '';
    mats.forEach((m, i) => {
        if(i % 5 === 0) html += '<tr>';
        html += `
        <td>
            <div class="mat-cell">
                <span class="mat-name">${m.name}</span>
                <span class="badge">${m.emcValue}</span>
                <input type="number" class="minimal-input mat-qty" data-emc="${m.emcValue}" value="0" min="0" />
            </div>
        </td>`;
        if((i+1) % 5 === 0) html += '</tr>';
    });
    // paddings if not multiple of 5
    if (mats.length % 5 !== 0) {
        for(let i=0; i < (5 - (mats.length % 5)); i++) html += '<td style="background:transparent;box-shadow:none;"></td>';
        html += '</tr>';
    }
    matTbody.innerHTML = html;
    
    function renderTbody() {
        const tbody = document.getElementById('gun-tbody');
        tbody.innerHTML = guns.map(a => `
            <tr>
                <td style="font-weight:600">${a.name}</td>
                <td><span class="badge">${a.totalEmc}</span></td>
                <td><button type="button" onclick="delGun('${a.id}')" class="btn-del">Del</button></td>
            </tr>
        `).join('');
    }
    
    window.delGun = (id) => {
        if(confirm('Purge?')) {
            const items = DB.get('basicGuns').filter(x => x.id !== id);
            DB.set('basicGuns', items);
            guns.length = 0; guns.push(...items);
            renderTbody();
        }
    };
    
    document.getElementById('gun-form').onsubmit = (e) => {
        e.preventDefault();
        const name = document.getElementById('gun-name').value;
        let emc = 0;
        document.querySelectorAll('.mat-qty').forEach(inp => {
            emc += parseInt(inp.value) * parseInt(inp.dataset.emc);
            inp.value = 0;
        });
        guns.push({ id: DB.guid(), name, totalEmc: emc });
        DB.set('basicGuns', guns);
        document.getElementById('gun-form').reset();
        renderTbody();
    };
    
    renderTbody();
});
""")

write_file("gunorigin.html", html_template.format(
    title="Base Guns Module",
    script_name="gunorigin",
    header_extra="",
    content="""
    <div class="flex-layout">
        <div class="card-panel">
            <h2>Craft Base Gun</h2>
            <form id="gun-form">
                <div class="input-group">
                    <span class="input-label">Name</span>
                    <input type="text" id="gun-name" class="input-field" required />
                </div>
                <div style="overflow-x: auto;">
                    <table class="styled-table" style="width:100%; table-layout:fixed;">
                        <tbody id="mats-container"></tbody>
                    </table>
                </div>
                <button type="submit" class="btn-primary" style="margin-top:20px;">Forge Base Gun</button>
            </form>
        </div>
        <div class="card-panel">
            <h2>Base Guns Formed</h2>
            <table class="styled-table">
                <thead><tr><th>Name</th><th>Unit EMC</th><th>Actions</th></tr></thead>
                <tbody id="gun-tbody"></tbody>
            </table>
        </div>
    </div>
    """
))

# 6. fullgun
write_file("js/fullgun.js", """
document.addEventListener('DOMContentLoaded', () => {
    const bGuns = DB.get('basicGuns');
    const atts = DB.get('attachments');
    let customGuns = DB.get('customGuns');
    
    document.getElementById('bg-select').innerHTML = `<option value="">Select a Base Gun...</option>` + bGuns.map(g => `<option value="${g.id},${g.totalEmc},${g.name}">${g.name} (${g.totalEmc} EMC)</option>`).join('');
    
    document.getElementById('att-selects').innerHTML = atts.map(a => `
        <div style="margin-bottom:10px; display:flex; gap:10px; align-items:center;">
            <input type="number" class="att-qty minimal-input" data-emc="${a.totalEmc}" value="0" min="0" style="width:60px;" />
            <span style="font-weight:bold; color:var(--text-light);">${a.name} (${a.totalEmc} EMC)</span>
        </div>
    `).join('');
    
    function renderCG() {
        const tb = document.getElementById('cg-tbody');
        tb.innerHTML = customGuns.map(cg => `
            <tr><td><span class="text-gold-force">${cg.name}</span><br><small style="color:var(--text-dim)">[${cg.baseGun}]</small></td><td><span class="badge">${cg.totalEmc}</span></td><td><button type="button" onclick="delCG('${cg.id}')" class="btn-del">Del</button></td></tr>
        `).join('');
    }
    
    window.delCG = (id) => {
        if(confirm('Purge?')) {
            customGuns = customGuns.filter(x => x.id !== id);
            DB.set('customGuns', customGuns);
            renderCG();
        }
    };
    
    document.getElementById('cg-form').onsubmit = (e) => {
        e.preventDefault();
        const cgName = document.getElementById('cg-name').value;
        const bgVal = document.getElementById('bg-select').value;
        if(!bgVal) return alert('No base gun selected!');
        const [bgId, bgEmc, bgName] = bgVal.split(',');
        
        let emc = parseInt(bgEmc);
        document.querySelectorAll('.att-qty').forEach(inp => {
            emc += parseInt(inp.value) * parseInt(inp.dataset.emc);
            inp.value = 0;
        });
        
        customGuns.push({ id: DB.guid(), name: cgName, totalEmc: emc, baseGun: bgName });
        DB.set('customGuns', customGuns);
        document.getElementById('cg-form').reset();
        renderCG();
    };
    renderCG();
});
""")

write_file("fullgun.html", html_template.format(
    title="Custom Guns",
    script_name="fullgun",
    header_extra="",
    content="""
    <div class="flex-layout">
        <div class="card-panel">
            <h2>Assemble Full Weapon</h2>
            <form id="cg-form">
                <div class="input-group">
                    <span class="input-label">Gun Name</span>
                    <input type="text" id="cg-name" class="input-field" required />
                </div>
                <h3>Base Gun Selection</h3>
                <select id="bg-select" class="input-field" style="margin-bottom:20px; width:100%;"></select>
                <h3>Attachments</h3>
                <div id="att-selects" style="margin-bottom:20px;"></div>
                <button type="submit" class="btn-primary">Assemble Gun</button>
            </form>
        </div>
        <div class="card-panel">
            <h2>Custom Gun Configurations</h2>
            <table class="styled-table">
                <thead><tr><th>Name</th><th>Total EMC</th><th>Action</th></tr></thead>
                <tbody id="cg-tbody"></tbody>
            </table>
        </div>
    </div>
    """
))

# 7. overview
write_file("js/overview.js", """
document.addEventListener('DOMContentLoaded', () => {
    const m = DB.get('materials');
    const a = DB.get('attachments');
    const b = DB.get('basicGuns');
    const c = DB.get('customGuns');
    
    const r = (items, id) => {
        document.getElementById(id).innerHTML = items.length ? items.map(x => `<tr><td>${x.name}</td><td><span class="badge">${x.emcValue || x.totalEmc}</span></td></tr>`).join('') : '<tr><td colspan="2"><div class="empty-state">No Data Found.</div></td></tr>';
    };
    
    r(m, 't-m'); r(a, 't-a'); r(b, 't-b'); r(c, 't-c');
});
""")

write_file("overview.html", html_template.format(
    title="Data Overview",
    script_name="overview",
    header_extra="",
    content="""
    <div class="flex-layout">
        <div class="card-panel"><h2>Materials</h2><table class="styled-table"><thead><tr><th>Name</th><th>EMC</th></tr></thead><tbody id="t-m"></tbody></table></div>
        <div class="card-panel"><h2>Attachments</h2><table class="styled-table"><thead><tr><th>Name</th><th>EMC</th></tr></thead><tbody id="t-a"></tbody></table></div>
        <div class="card-panel"><h2>Base Guns</h2><table class="styled-table"><thead><tr><th>Name</th><th>EMC</th></tr></thead><tbody id="t-b"></tbody></table></div>
        <div class="card-panel"><h2>Custom Guns</h2><table class="styled-table"><thead><tr><th>Name</th><th>EMC</th></tr></thead><tbody id="t-c"></tbody></table></div>
    </div>
    """
))

# 8. quickload
write_file("js/quickload.js", """
document.addEventListener('DOMContentLoaded', () => {
    document.getElementById('export-btn').onclick = () => {
         const data = {
             materials: DB.get('materials'),
             attachments: DB.get('attachments'),
             basicGuns: DB.get('basicGuns'),
             customGuns: DB.get('customGuns')
         };
         document.getElementById('io-area').value = JSON.stringify(data, null, 2);
    };
    
    document.getElementById('import-btn').onclick = () => {
        try {
            const data = JSON.parse(document.getElementById('io-area').value);
            if(data.materials) DB.set('materials', data.materials);
            if(data.attachments) DB.set('attachments', data.attachments);
            if(data.basicGuns) DB.set('basicGuns', data.basicGuns);
            if(data.customGuns) DB.set('customGuns', data.customGuns);
            alert('Import Successful!');
        } catch(e) {
            alert('JSON Malformed');
        }
    };
});
""")

write_file("quickload.html", html_template.format(
    title="Import / Export Data",
    script_name="quickload",
    header_extra="",
    content="""
    <div class="card-panel">
        <h2>Data I/O</h2>
        <textarea id="io-area" class="textarea-data" placeholder="Paste JSON here..."></textarea>
        <div class="action-group">
            <button type="button" id="import-btn" class="btn-primary">Import</button>
            <button type="button" id="export-btn" class="btn-secondary">Export to Textarea</button>
        </div>
    </div>
    """
))

# 9. cleandb
write_file("js/cleandb.js", """
document.addEventListener('DOMContentLoaded', () => {
    const keys = ['materials', 'attachments', 'basicGuns', 'customGuns'];
    const tb = document.getElementById('c-tb');
    
    function r() {
        tb.innerHTML = keys.map(k => `
            <tr>
                <td style="font-weight:700; text-transform:uppercase;">${k}</td>
                <td style="text-align:center;"><span class="badge ${DB.get(k).length ? '' : 'badge-dim'}">${DB.get(k).length}</span></td>
                <td style="text-align:center;"><button type="button" onclick="clearT('${k}')" class="btn-del">Del</button></td>
            </tr>
        `).join('');
    }
    
    window.clearT = (k) => {
        if(confirm('Clear table '+k+'?')) {
            DB.set(k, []); r();
        }
    };
    r();
});
""")

write_file("cleandb.html", html_template.format(
    title="Clean Data Records",
    script_name="cleandb",
    header_extra="",
    content="""
    <div class="card-panel" style="max-width:800px; margin:0 auto;">
        <h2>Database Sanitization</h2>
        <table class="styled-table">
            <thead><tr><th>Table Name</th><th style="text-align:center;">Count</th><th style="text-align:center;">Action</th></tr></thead>
            <tbody id="c-tb"></tbody>
        </table>
    </div>
    """
))

print("Static generation completed successfully.")
