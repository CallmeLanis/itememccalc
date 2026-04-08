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
