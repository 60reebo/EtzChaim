const express = require('express');
const path = require('path');
const cors = require('cors');
const fs = require('fs');

const app = express();
app.use(cors());
app.use(express.static(path.join(__dirname, '../public')));

// Utility: Recursively search for object by key
function findByKey(obj, key) {
    if (obj.identifier && obj.identifier.key === key) return obj;
    if (obj.children && Array.isArray(obj.children)) {
        for (const child of obj.children) {
            const found = findByKey(child, key);
            if (found) return found;
        }
    }
    return null;
}

app.get('/api/hishtalshelut/:key', (req, res) => {
    const dataPath = path.join(__dirname, 'data/hishtalshelut.json');
    const data = JSON.parse(fs.readFileSync(dataPath, 'utf8'));
    const key = req.params.key;
    const obj = findByKey(data, key);
    if (obj) {
        res.json(obj);
    } else {
        res.status(404).json({ error: 'Not found' });
    }
});

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
    console.log(`OpenMCT server running at http://localhost:${PORT}`);
});
