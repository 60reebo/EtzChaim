export default function HishtalshelutTreePlugin() {
    return function install(openmct) {
        // הוספת טיפוסים בסיסיים
        openmct.types.addType('world', {
            name: 'עולם',
            description: 'עולם במודל ההשתלשלות',
            cssClass: 'icon-folder'
        });
        openmct.types.addType('sefirah', {
            name: 'ספירה',
            description: 'ספירה במודל ההשתלשלות',
            cssClass: 'icon-telemetry'
        });
        openmct.types.addType('folder', {
            name: 'תיקיה',
            description: 'קבוצת אובייקטים',
            cssClass: 'icon-folder'
        });

        // הוספת ROOT
        openmct.objects.addRoot({ namespace: 'etzchaim', key: 'hishtalshelut-root' });

        // ספק אובייקטים דינמי מה-API
        openmct.objects.addProvider('etzchaim', {
            get: function(identifier) {
                return fetch(`/api/hishtalshelut/${identifier.key}`)
                    .then(res => {
                        if (!res.ok) throw new Error('Not found');
                        return res.json();
                    })
                    .then(obj => {
                        // המרה למבנה OpenMCT
                        obj.identifier = identifier;
                        obj.location = obj.location || 'ROOT';
                        obj.type = obj.type || 'folder';
                        if (obj.children) {
                            obj.composition = obj.children.map(child => child.identifier);
                        }
                        return obj;
                    });
            },
            // תמיכה ב-composition (ילדים)
            load: function(identifier) {
                return this.get(identifier).then(obj => obj.composition || []);
            }
        });
    };
}
