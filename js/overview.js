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
