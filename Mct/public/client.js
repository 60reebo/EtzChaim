// פלאגין עץ ההשתלשלות - ישירות כאן
function HishtalshelutTreePlugin() {
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
                        obj.identifier = identifier;
                        obj.location = obj.location || 'ROOT';
                        obj.type = obj.type || 'folder';
                        if (obj.children) {
                            obj.composition = obj.children.map(child => child.identifier);
                        }
                        return obj;
                    });
            },
            load: function(identifier) {
                return this.get(identifier).then(obj => obj.composition || []);
            }
        });
    };
}

document.addEventListener('DOMContentLoaded', function () {
    window.openmct.setAssetPath('./openmct/');
    window.openmct.install(window.openmct.plugins.LocalStorage());
    window.openmct.install(window.openmct.plugins.MyItems());
    window.openmct.install(window.openmct.plugins.UTCTimeSystem());
    window.openmct.install(window.openmct.plugins.Timeline());
    window.openmct.install(window.openmct.plugins.Espresso());
    // התקנת פלאגין עץ ההשתלשלות
    window.openmct.install(HishtalshelutTreePlugin());
    window.openmct.start();
});
