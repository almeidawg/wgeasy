const fs = require('fs');
const path = require('path');

const root = path.join(__dirname, '..', 'src');
const exts = ['.ts', '.tsx', '.js', '.jsx'];
const re = /import\s+\{([^}]+)\}\s+from\s+['\"]lucide-react['\"]/g;

function walk(dir) {
  let results = [];
  const list = fs.readdirSync(dir, { withFileTypes: true });
  for (const d of list) {
    const full = path.join(dir, d.name);
    if (d.isDirectory()) results = results.concat(walk(full));
    else if (exts.includes(path.extname(d.name))) results.push(full);
  }
  return results;
}

const files = walk(root);
const icons = new Set();
for (const f of files) {
  try {
    const txt = fs.readFileSync(f, 'utf8');
    let m;
    while ((m = re.exec(txt)) !== null) {
      const group = m[1];
      group.split(',').map(s => s.trim()).filter(Boolean).forEach(name => {
        const clean = name.split(/\s+as\s+/)[0].trim();
        icons.add(clean);
      });
    }
  } catch (e) {}
}
const out = Array.from(icons).sort().join('\n');
fs.writeFileSync(path.join(__dirname, '..', 'lucide-uses.txt'), out, 'utf8');
console.log(out);
