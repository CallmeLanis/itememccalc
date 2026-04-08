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
