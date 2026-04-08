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
