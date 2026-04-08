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
