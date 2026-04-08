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
