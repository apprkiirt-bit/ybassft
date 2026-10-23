const fs = require("fs");
const path = require("path");
const luaparse = require("luaparse");

const src = fs.readFileSync(path.join(__dirname, "..", "src", "features", "registry.lua"), "utf8");
const ast = luaparse.parse(src, { luaVersion: "5.1", scope: false });

let table = null;

function walk(node) {
  if (!node || typeof node !== "object") return;
  if (Array.isArray(node)) {
    for (const item of node) walk(item);
    return;
  }
  if (node.type === "AssignmentStatement") {
    const target = node.variables && node.variables[0];
    if (
      target &&
      target.type === "MemberExpression" &&
      target.indexer === "." &&
      target.identifier &&
      target.identifier.name === "tabs" &&
      target.base &&
      target.base.name === "Registry"
    ) {
      table = node.init && node.init[0];
    }
  }
  for (const key of Object.keys(node)) {
    if (key === "type") continue;
    walk(node[key]);
  }
}

function convert(node) {
  if (!node) return null;
  switch (node.type) {
    case "TableConstructorExpression": {
      const entries = [];
      let numeric = true;
      let nextIndex = 1;
      for (const field of node.fields) {
        if (field.type === "TableValue") {
          entries.push([nextIndex++, convert(field.value)]);
        } else if (field.type === "TableKeyString") {
          numeric = false;
          entries.push([field.key.name, convert(field.value)]);
        } else if (field.type === "TableKey") {
          numeric = false;
          const raw = field.key;
          const key = raw && raw.type === "Identifier" ? raw.name : String(convert(raw));
          entries.push([key, convert(field.value)]);
        }
      }
      if (numeric) {
        return entries.sort((a, b) => a[0] - b[0]).map((entry) => entry[1]);
      }
      const out = {};
      for (const [key, value] of entries) out[key] = value;
      return out;
    }
    case "StringLiteral":
      if (node.value !== null && node.value !== undefined) return node.value;
      return String(node.raw || "").replace(/^["\x27]|["\x27]$/g, "");
    case "NumericLiteral":
      return node.value;
    case "BooleanLiteral":
      return node.value;
    case "NilLiteral":
      return null;
    case "Identifier":
      return node.name;
    case "UnaryExpression":
      return node.operator === "-" ? -convert(node.argument) : convert(node.argument);
    case "CallExpression": {
      const base = node.base;
      if (base && base.type === "Identifier" && base.name === "card") {
        return convert(node.arguments[1]);
      }
      return null;
    }
    default:
      return null;
  }
}

walk(ast);
if (!table) {
  console.error("registry.tabs not found");
  process.exit(1);
}

const tabs = convert(table);
for (const tab of tabs) {
  for (const cardSpec of tab.cards) {
    cardSpec.path = tab.id + "." + cardSpec.id;
  }
}

const out = "window.YBASSFT_TABS = " + JSON.stringify(tabs, null, 1) + ";\n";
fs.writeFileSync(path.join(__dirname, "data.js"), out, "utf8");
const cards = tabs.reduce((sum, tab) => sum + tab.cards.length, 0);
const fields = tabs.reduce((sum, tab) => sum + tab.cards.reduce((n, c) => n + (c.fields ? c.fields.length : 0), 0), 0);
console.log(`tabs=${tabs.length} cards=${cards} fields=${fields}`);
