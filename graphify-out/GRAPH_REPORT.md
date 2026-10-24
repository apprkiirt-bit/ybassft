# Graph Report - ybassft  (2026-10-24)

## Corpus Check
- 22 files · ~33,166 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 1 file(s) not represented in the graph (top: (none) 1)

## Summary
- 260 nodes · 656 edges · 12 communities (11 shown, 1 thin omitted)
- Extraction: 77% EXTRACTED · 23% INFERRED · 0% AMBIGUOUS · INFERRED: 150 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `a4355f54`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- window.lua
- Theme.color
- util.lua
- yba.lua
- gen-data.js
- main.lua
- movement.lua
- signal.lua
- farm.lua
- visuals.lua
- ybassft

## God Nodes (most connected - your core abstractions)
1. `Theme.color()` - 28 edges
2. `Theme.bind()` - 21 edges
3. `YBA.humanoid()` - 17 edges
4. `Components.card()` - 17 edges
5. `YBA.root()` - 16 edges
6. `Components.icon()` - 16 edges
7. `Store.get()` - 14 edges
8. `Components.text()` - 14 edges
9. `YBA.stand()` - 11 edges
10. `HUD.init()` - 11 edges

## Surprising Connections (you probably didn't know these)
- `Window.openThemes()` --calls--> `Theme.get()`  [INFERRED]
  src/ui/window.lua → src/ui/theme.lua
- `Components.icon()` --calls--> `Icons.get()`  [INFERRED]
  src/ui/components.lua → src/core/icons.lua
- `Combat.init()` --calls--> `Store.get()`  [INFERRED]
  src/features/combat.lua → src/core/store.lua
- `on()` --calls--> `Store.get()`  [INFERRED]
  src/features/combat.lua → src/core/store.lua
- `Farm.init()` --calls--> `Store.get()`  [INFERRED]
  src/features/farm.lua → src/core/store.lua

## Import Cycles
- None detected.

## Communities (12 total, 1 thin omitted)

### Community 0 - "window.lua"
Cohesion: 0.19
Nodes (19): Components.init(), bindCard(), buildTab(), closeMenus(), columnCount(), createNav(), createTools(), createTrafficLights() (+11 more)

### Community 1 - "Theme.color"
Cohesion: 0.17
Nodes (34): Components.button(), Components.card(), Components.checkbox(), Components.divider(), Components.icon(), Components.keybind(), Components.label(), Components.multi() (+26 more)

### Community 2 - "util.lua"
Cohesion: 0.16
Nodes (9): U.corner(), U.create(), U.deepCopy(), U.gradient(), U.hlist(), U.list(), U.merge(), U.padding() (+1 more)

### Community 3 - "yba.lua"
Cohesion: 0.14
Nodes (35): attackAura(), Combat.init(), Combat.trigger(), currentTarget(), fastM1(), hitbox(), movestack(), on() (+27 more)

### Community 4 - "gen-data.js"
Cohesion: 0.16
Nodes (9): files, root, ast, cards, convert(), fields, src, tabs (+1 more)

### Community 5 - "main.lua"
Cohesion: 0.07
Nodes (29): Config.delete(), Config.init(), Config.load(), Config.save(), join(), pathOf(), ensureFolder(), Icons.get() (+21 more)

### Community 6 - "movement.lua"
Cohesion: 0.16
Nodes (28): applyJump(), applySpeed(), autoDash(), flyStep(), infiniteJump(), Movement.teleportToCursor(), Movement.teleportToPlayer(), Movement.teleportToWaypoint() (+20 more)

### Community 7 - "signal.lua"
Cohesion: 0.28
Nodes (3): Connection.new(), Signal:Connect(), Signal:Once()

### Community 8 - "farm.lua"
Cohesion: 0.25
Nodes (19): autoBuy(), autoCollect(), autoQuest(), autoRoll(), autoSell(), Farm.init(), Farm.resetStats(), Farm.stats() (+11 more)

### Community 9 - "visuals.lua"
Cohesion: 0.27
Nodes (17): applyCamera(), applyLowGfx(), clearDrawings(), drawItem(), drawPlayer(), freecamStep(), hide(), installRemovalHooks() (+9 more)

### Community 10 - "ybassft"
Cohesion: 0.40
Nodes (4): HUD, ybassft, Структура, Что внутри

## Knowledge Gaps
- **1 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Store.get()` connect `main.lua` to `farm.lua`, `visuals.lua`, `yba.lua`, `movement.lua`?**
  _High betweenness centrality (0.024) - this node is a cross-community bridge._
- **Are the 24 inferred relationships involving `Theme.color()` (e.g. with `Components.button()` and `Components.card()`) actually correct?**
  _`Theme.color()` has 24 INFERRED edges - model-reasoned connections that need verification._
- **Should `yba.lua` be split into smaller, more focused modules?**
  _Cohesion score 0.13765182186234817 - nodes in this community are weakly interconnected._
- **Why does `Theme.color()` connect `Theme.color` to `window.lua`, `main.lua`?**
  _High betweenness centrality (0.021) - this node is a cross-community bridge._
- **Are the 19 inferred relationships involving `Theme.bind()` (e.g. with `Components.button()` and `Components.card()`) actually correct?**
  _`Theme.bind()` has 19 INFERRED edges - model-reasoned connections that need verification._
- **Should `main.lua` be split into smaller, more focused modules?**
  _Cohesion score 0.06765327695560254 - nodes in this community are weakly interconnected._
- **Why does `YBA.root()` connect `movement.lua` to `farm.lua`, `yba.lua`, `main.lua`?**
  _High betweenness centrality (0.019) - this node is a cross-community bridge._