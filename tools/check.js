const fs = require("fs");
const path = require("path");
const luaparse = require("luaparse");

const root = path.join(__dirname, "..", "src");
const files = [];
(function walk(dir) {
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) walk(full);
    else if (entry.name.endsWith(".lua")) files.push(full);
  }
})(root);

let failed = 0;
for (const file of files) {
  const src = fs.readFileSync(file, "utf8");
  try {
    luaparse.parse(src, { luaVersion: "5.1", scope: false });
    console.log("ok    " + path.relative(root, file));
  } catch (err) {
    failed++;
    console.log("FAIL  " + path.relative(root, file) + " :: " + err.message);
  }
}
console.log(`\n${files.length - failed}/${files.length} parsed`);
process.exit(failed ? 1 : 0);
