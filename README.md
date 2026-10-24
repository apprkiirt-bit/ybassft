# ybassft

YBA (Your Bizarre Adventure) utility — Luau, modular, loaded with `loadstring`.

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/USER/ybassft/main/src/main.lua"))()
```

`USER` заменяется на актуальный GitHub-аккаунт после пуша.

## Что внутри

**Combat** — stand pilot на любом стенде, stand attack (тп к цели + LMB/абилки), target select кликом по ESP,
movestack двух абилок, ability rotation с пресетами, attack aura, fast m1, hitbox extend.

**Movement** — walkspeed / hippheight, jump power + infinite jump, fly, noclip, телепорт к курсору/игроку/точке,
waypoints (5 слотов), auto dash.

**Farm** — auto farm NPC с радиусом и приоритетом, auto sell мерчанту с фильтром редкости и скипом диалогов,
auto buy, auto roll со стопом на редком, auto collect по приоритету, auto quest, статистика kills / money per hour.

**Visuals** — player ESP (box/name/dist/hp/chams/tracers), item ESP с приоритетом рарки, NPC ESP,
удаление анимации MIH world reset, удаление эффектов Killer Queen / Bites the Dust, low gfx, camera (fov/zoom/freecam), HUD.

**Protection** — anti time stop, anti GER, anti time erase, anti stun, anti slow, anti kick, anti void.

**Files** — конфиг save/load/delete + autosave, список и очистка биндов, масштаб/блюр/клавиша меню, reload/unload.

## HUD

Watermark из двух боксов: `[ромб + ник]` и `[fps | ping | rage | barrage]`, справа панель Keybinds,
снизу нотификации с тогглом. Всё в белом, иконки — SVG-исходники, в игре PNG 96px.

## Структура

```
src/
  main.lua            загрузчик, действия, бинды, HUD-фиды
  core/               util, signal, store, config, icons
  ui/                 theme, components, window, notify, hud
  features/
    registry.lua      единый список карточек и настроек
    yba.lua           обёртка над игрой: стенд, цели, итемы, клавиши, ремоуты
    combat.lua movement.lua visuals.lua farm.lua protection.lua
assets/
  svg/                исходные lucide svg
  icons/              белые png 96x96 для ImageLabel
tools/
  preview.html        интерактивное превью GUI (данные из registry)
  gen-data.js         registry → preview data
  check.js            синтаксическая проверка всех модулей
graphify-out/         граф кода (graphify update .)
```
