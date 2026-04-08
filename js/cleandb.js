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
