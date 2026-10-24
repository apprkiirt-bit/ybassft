# Graph Report - ybassft  (2026-10-24)

## Corpus Check
- 16 files · ~27,202 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 1 file(s) not represented in the graph (top: (none) 1)

## Summary
- 143 nodes · 301 edges · 12 communities (11 shown, 1 thin omitted)
- Extraction: 82% EXTRACTED · 18% INFERRED · 0% AMBIGUOUS · INFERRED: 53 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `de803005`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- window.lua
- Theme.color
- util.lua
- main.lua
- gen-data.js
- store.lua
- hud.lua
- signal.lua
- config.lua
- icons.lua
- ybassft

## God Nodes (most connected - your core abstractions)
1. `Theme.color()` - 24 edges
2. `Components.card()` - 17 edges
3. `Theme.bind()` - 16 edges
4. `Components.text()` - 15 edges
5. `Components.icon()` - 14 edges
6. `Components.select()` - 8 edges
7. `Components.checkbox()` - 8 edges
8. `Window.openThemes()` - 8 edges
9. `Window.init()` - 8 edges
10. `U.create()` - 7 edges

## Surprising Connections (you probably didn't know these)
- `Components.toggle()` --calls--> `Theme.onChanged()`  [INFERRED]
  src/ui/components.lua → src/ui/theme.lua
- `Components.icon()` --calls--> `Icons.get()`  [INFERRED]
  src/ui/components.lua → src/core/icons.lua
- `applyBlur()` --calls--> `Store.get()`  [INFERRED]
  src/main.lua → src/core/store.lua
- `applyScale()` --calls--> `Store.get()`  [INFERRED]
  src/main.lua → src/core/store.lua
- `applyTheme()` --calls--> `Store.set()`  [INFERRED]
  src/main.lua → src/core/store.lua

## Import Cycles
- None detected.

## Communities (12 total, 1 thin omitted)

### Community 0 - "window.lua"
Cohesion: 0.18
Nodes (19): Components.init(), Theme.get(), buildTab(), closeMenus(), columnCount(), createNav(), createTools(), createTrafficLights() (+11 more)

### Community 1 - "Theme.color"
Cohesion: 0.41
Nodes (19): Components.button(), Components.card(), Components.checkbox(), Components.divider(), Components.icon(), Components.keybind(), Components.label(), Components.multi() (+11 more)

### Community 2 - "util.lua"
Cohesion: 0.16
Nodes (9): U.corner(), U.create(), U.deepCopy(), U.gradient(), U.hlist(), U.list(), U.merge(), U.padding() (+1 more)

### Community 3 - "main.lua"
Cohesion: 0.15
Nodes (7): applyTheme(), join(), require(), palette(), Theme.apply(), Theme.onChanged(), Theme.palette()

### Community 4 - "gen-data.js"
Cohesion: 0.16
Nodes (9): files, root, ast, cards, convert(), fields, src, tabs (+1 more)

### Community 5 - "store.lua"
Cohesion: 0.24
Nodes (7): copy(), navigate(), Store.get(), Store.set(), Store.snapshot(), Store.toggle(), applyBlur()

### Community 6 - "hud.lua"
Cohesion: 0.29
Nodes (8): applyScale(), HUD.addElement(), HUD.gui(), HUD.init(), HUD.refresh(), HUD.setStatus(), visibleKeys(), Window.scale()

### Community 7 - "signal.lua"
Cohesion: 0.28
Nodes (3): Connection.new(), Signal:Connect(), Signal:Once()

### Community 8 - "config.lua"
Cohesion: 0.43
Nodes (6): Config.delete(), Config.init(), Config.load(), Config.save(), join(), pathOf()

### Community 9 - "icons.lua"
Cohesion: 0.48
Nodes (5): ensureFolder(), Icons.get(), Icons.setup(), join(), resolve()

### Community 10 - "ybassft"
Cohesion: 0.33
Nodes (5): load, state paths, status, structure, ybassft

## Knowledge Gaps
- **1 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Theme.color()` connect `Theme.color` to `window.lua`, `main.lua`, `hud.lua`?**
  _High betweenness centrality (0.039) - this node is a cross-community bridge._
- **Are the 20 inferred relationships involving `Theme.color()` (e.g. with `Components.button()` and `Components.card()`) actually correct?**
  _`Theme.color()` has 20 INFERRED edges - model-reasoned connections that need verification._
- **Should `main.lua` be split into smaller, more focused modules?**
  _Cohesion score 0.14705882352941177 - nodes in this community are weakly interconnected._
- **Why does `Theme.bind()` connect `Theme.color` to `window.lua`, `main.lua`, `hud.lua`?**
  _High betweenness centrality (0.010) - this node is a cross-community bridge._
- **Are the 3 inferred relationships involving `Components.card()` (e.g. with `Theme.bind()` and `Theme.color()`) actually correct?**
  _`Components.card()` has 3 INFERRED edges - model-reasoned connections that need verification._
- **Why does `Components.icon()` connect `Theme.color` to `window.lua`, `icons.lua`, `hud.lua`?**
  _High betweenness centrality (0.010) - this node is a cross-community bridge._
- **Are the 14 inferred relationships involving `Theme.bind()` (e.g. with `Components.button()` and `Components.card()`) actually correct?**
  _`Theme.bind()` has 14 INFERRED edges - model-reasoned connections that need verification._