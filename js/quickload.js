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
