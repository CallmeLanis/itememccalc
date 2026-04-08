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
