# ybassft

YBA (Your Bizarre Adventure) utility menu. Luau, modular, built for executors.

## load

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/USER/ybassft/main/src/main.lua"))()
```

Menu key: `RightShift`.

## structure

```
src/
  main.lua              loader, wiring, unload
  core/
    util.lua            instance/tween/color helpers
    signal.lua          lightweight event
    store.lua           reactive state, paths like "combat.stand_pilot.enabled"
    config.lua          config save/load/delete/list
    icons.lua           icon resolution: custom asset -> download -> cache
  ui/
    theme.lua           7 palettes, live recolor
    components.lua      card, toggle, select, multi, slider, checkbox, keybind, button
    window.lua          shell: traffic lights, nav, tools, columns, drag, resize
    hud.lua             watermark + arraylist + status rows
    notify.lua          toasts
  features/
    registry.lua        every card and field, single source of truth
assets/
  icons/                76 white png icons (tinted at runtime)
tools/
  check.js              syntax check (node tools/check.js)
  preview.html          static design preview
```

## state paths

`store.get("farm.auto_sell.rarity")` — tab.card.field. Card on/off is `...enabled`.

## status

GUI stage: layout, animations, themes, HUD, config plumbing done. Feature logic next.
