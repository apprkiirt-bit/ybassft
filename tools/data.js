window.YBASSFT_TABS = [
 {
  "id": "combat",
  "icon": "swords",
  "title": "Combat",
  "cards": [
   {
    "id": "stand_pilot",
    "title": "Stand Pilot",
    "icon": "orbit",
    "pill": "Pilot",
    "toggle": true,
    "desc": "Ведёшь стенд как пилотом — работает на любом стенде, даже без пилота",
    "fields": [
     {
      "type": "select",
      "id": "mode",
      "label": "Mode",
      "options": [
       "Free",
       "Orbit",
       "Locked"
      ],
      "value": "Free"
     },
     {
      "type": "slider",
      "id": "distance",
      "label": "Distance",
      "min": 2,
      "max": 40,
      "value": 8,
      "suffix": " st"
     },
     {
      "type": "slider",
      "id": "speed",
      "label": "Follow speed",
      "min": 5,
      "max": 120,
      "value": 34
     },
     {
      "type": "checkbox",
      "id": "resummon",
      "label": "Auto re-summon",
      "hint": "Подзывает стенд, если он пропал",
      "value": true
     },
     {
      "type": "keybind",
      "id": "toggle_key",
      "label": "Toggle key"
     }
    ],
    "path": "combat.stand_pilot"
   },
   {
    "id": "stand_attack",
    "title": "Stand Attack",
    "icon": "target",
    "pill": "Auto",
    "toggle": true,
    "desc": "Стенд тп-шится к цели и бьёт — LMB или заданные абилки",
    "fields": [
     {
      "type": "select",
      "id": "target",
      "label": "Target",
      "options": [
       "Selected",
       "Nearest",
       "Lowest HP",
       "Highest HP"
      ],
      "value": "Selected"
     },
     {
      "type": "select",
      "id": "attack",
      "label": "Attack",
      "options": [
       "M1",
       "Abilities",
       "Mixed"
      ],
      "value": "Mixed"
     },
     {
      "type": "multi",
      "id": "abilities",
      "label": "Abilities",
      "options": [
       "Barrage",
       "Heavy",
       "Special",
       "Ultimate"
      ]
     },
     {
      "type": "slider",
      "id": "range",
      "label": "Range",
      "min": 4,
      "max": 60,
      "value": 18,
      "suffix": " st"
     },
     {
      "type": "slider",
      "id": "delay",
      "label": "Attack delay",
      "min": 0.05,
      "max": 1,
      "value": 0.15,
      "decimals": 2,
      "suffix": "s"
     },
     {
      "type": "checkbox",
      "id": "switch",
      "label": "Auto switch target",
      "value": true
     },
     {
      "type": "keybind",
      "id": "toggle_key",
      "label": "Toggle key"
     }
    ],
    "path": "combat.stand_attack"
   },
   {
    "id": "target",
    "title": "Target Select",
    "icon": "crosshair",
    "pill": "Focus",
    "toggle": true,
    "desc": "Тыкнул в игрока в ESP — он в фокусе для всех модулей",
    "fields": [
     {
      "type": "select",
      "id": "mode",
      "label": "Pick mode",
      "options": [
       "ESP click",
       "Crosshair",
       "Nearest"
      ],
      "value": "ESP click"
     },
     {
      "type": "checkbox",
      "id": "esp_click",
      "label": "Click on ESP box",
      "value": true
     },
     {
      "type": "keybind",
      "id": "lock_key",
      "label": "Lock key"
     }
    ],
    "path": "combat.target"
   },
   {
    "id": "movestack",
    "title": "Movestack",
    "icon": "layers",
    "pill": "2x",
    "toggle": true,
    "desc": "Две абилки одновременно — барраж + хил, бокс + стенд",
    "fields": [
     {
      "type": "select",
      "id": "ability_a",
      "label": "Ability 1",
      "options": [
       "Barrage",
       "Heavy",
       "Special",
       "Ultimate",
       "M1"
      ],
      "value": "Barrage"
     },
     {
      "type": "select",
      "id": "ability_b",
      "label": "Ability 2",
      "options": [
       "Barrage",
       "Heavy",
       "Special",
       "Ultimate",
       "M1"
      ],
      "value": "Heavy"
     },
     {
      "type": "slider",
      "id": "stack_delay",
      "label": "Stack delay",
      "min": 0,
      "max": 0.5,
      "value": 0.04,
      "decimals": 2,
      "suffix": "s"
     },
     {
      "type": "checkbox",
      "id": "hold",
      "label": "Hold to repeat",
      "value": true
     },
     {
      "type": "keybind",
      "id": "stack_key",
      "label": "Stack key"
     }
    ],
    "path": "combat.movestack"
   },
   {
    "id": "rotation",
    "title": "Ability Rotation",
    "icon": "repeat",
    "pill": "Combo",
    "toggle": true,
    "desc": "Сценарий комбо с шагами и задержками, пресеты под стенд",
    "fields": [
     {
      "type": "select",
      "id": "preset",
      "label": "Preset",
      "options": [
       "Barrage combo",
       "Heavy combo",
       "Custom"
      ],
      "value": "Barrage combo"
     },
     {
      "type": "multi",
      "id": "steps",
      "label": "Steps",
      "options": [
       "Barrage",
       "Heavy",
       "Special",
       "Ultimate"
      ]
     },
     {
      "type": "slider",
      "id": "step_delay",
      "label": "Step delay",
      "min": 0.05,
      "max": 1,
      "value": 0.25,
      "decimals": 2,
      "suffix": "s"
     },
     {
      "type": "checkbox",
      "id": "repeat",
      "label": "Loop combo"
     },
     {
      "type": "keybind",
      "id": "rotation_key",
      "label": "Start key"
     }
    ],
    "path": "combat.rotation"
   },
   {
    "id": "aura",
    "title": "Attack Aura",
    "icon": "zap",
    "pill": "Aura",
    "toggle": true,
    "desc": "M1 в радиусе по NPC и игрокам, как в референсе",
    "fields": [
     {
      "type": "slider",
      "id": "range",
      "label": "Range",
      "min": 4,
      "max": 40,
      "value": 12,
      "suffix": " st"
     },
     {
      "type": "select",
      "id": "mode",
      "label": "Mode",
      "options": [
       "M1 only",
       "Abilities",
       "Mixed"
      ],
      "value": "M1 only"
     },
     {
      "type": "select",
      "id": "targets",
      "label": "Targets",
      "options": [
       "Both",
       "Players only",
       "NPC only"
      ],
      "value": "Both"
     },
     {
      "type": "slider",
      "id": "delay",
      "label": "Hit delay",
      "min": 0.04,
      "max": 1,
      "value": 0.12,
      "decimals": 2,
      "suffix": "s"
     },
     {
      "type": "keybind",
      "id": "aura_key",
      "label": "Toggle key"
     }
    ],
    "path": "combat.aura"
   },
   {
    "id": "fast_m1",
    "title": "Fast M1",
    "icon": "swords",
    "pill": "Fast",
    "toggle": true,
    "desc": "Убирает задержку и анимацию между ударами",
    "fields": [
     {
      "type": "slider",
      "id": "click_delay",
      "label": "Click delay",
      "min": 0.02,
      "max": 0.5,
      "value": 0.06,
      "decimals": 2,
      "suffix": "s"
     },
     {
      "type": "checkbox",
      "id": "skip_anim",
      "label": "Skip swing animation",
      "value": true
     },
     {
      "type": "keybind",
      "id": "m1_key",
      "label": "Toggle key"
     }
    ],
    "path": "combat.fast_m1"
   },
   {
    "id": "hitbox",
    "title": "Hitbox Extend",
    "icon": "scan",
    "pill": "Exp",
    "toggle": true,
    "desc": "Экспериментально: сервер может резать попадания",
    "fields": [
     {
      "type": "slider",
      "id": "range",
      "label": "Hitbox size",
      "min": 6,
      "max": 40,
      "value": 20,
      "suffix": " st"
     },
     {
      "type": "select",
      "id": "mode",
      "label": "Mode",
      "options": [
       "Expand",
       "Extend",
       "Ghost"
      ],
      "value": "Expand"
     }
    ],
    "path": "combat.hitbox"
   }
  ]
 },
 {
  "id": "movement",
  "icon": "footprints",
  "title": "Movement",
  "cards": [
   {
    "id": "speed",
    "title": "Walk Speed",
    "icon": "gauge",
    "pill": "Speed",
    "toggle": true,
    "desc": "Скорость бега или высота шага",
    "fields": [
     {
      "type": "select",
      "id": "mode",
      "label": "Mode",
      "options": [
       "WalkSpeed",
       "HipHeight"
      ],
      "value": "WalkSpeed"
     },
     {
      "type": "slider",
      "id": "speed",
      "label": "Value",
      "min": 16,
      "max": 200,
      "value": 60
     },
     {
      "type": "keybind",
      "id": "toggle_key",
      "label": "Toggle key"
     }
    ],
    "path": "movement.speed"
   },
   {
    "id": "jump",
    "title": "Jump Power",
    "icon": "arrow-up",
    "pill": "Jump",
    "toggle": true,
    "desc": "Сила прыжка и бесконечный прыжок",
    "fields": [
     {
      "type": "slider",
      "id": "power",
      "label": "Power",
      "min": 50,
      "max": 300,
      "value": 90
     },
     {
      "type": "checkbox",
      "id": "infinite",
      "label": "Infinite jump",
      "value": true
     },
     {
      "type": "keybind",
      "id": "toggle_key",
      "label": "Toggle key"
     }
    ],
    "path": "movement.jump"
   },
   {
    "id": "fly",
    "title": "Fly",
    "icon": "plane",
    "pill": "Fly",
    "toggle": true,
    "desc": "Плавный полёт, пробел вверх, ctrl вниз",
    "fields": [
     {
      "type": "slider",
      "id": "speed",
      "label": "Speed",
      "min": 20,
      "max": 250,
      "value": 70
     },
     {
      "type": "slider",
      "id": "vertical",
      "label": "Vertical speed",
      "min": 10,
      "max": 200,
      "value": 50
     },
     {
      "type": "select",
      "id": "mode",
      "label": "Mode",
      "options": [
       "Camera",
       "Straight"
      ],
      "value": "Camera"
     },
     {
      "type": "keybind",
      "id": "toggle_key",
      "label": "Toggle key"
     }
    ],
    "path": "movement.fly"
   },
   {
    "id": "noclip",
    "title": "Noclip",
    "icon": "ghost",
    "pill": "Clip",
    "toggle": true,
    "desc": "Проход сквозь стены",
    "fields": [
     {
      "type": "keybind",
      "id": "toggle_key",
      "label": "Toggle key"
     }
    ],
    "path": "movement.noclip"
   },
   {
    "id": "teleport",
    "title": "Teleport",
    "icon": "move",
    "pill": "TP",
    "desc": "Телепорт к курсору, игроку или точке",
    "fields": [
     {
      "type": "button",
      "id": "to_cursor",
      "text": "To cursor",
      "icon": "mouse-pointer",
      "action": "movement.to_cursor"
     },
     {
      "type": "button",
      "id": "to_target",
      "text": "To target",
      "icon": "crosshair",
      "action": "movement.to_target"
     },
     {
      "type": "select",
      "id": "player",
      "label": "Player",
      "options": [
       "Nearest"
      ],
      "value": "Nearest"
     },
     {
      "type": "button",
      "id": "to_player",
      "text": "To player",
      "icon": "user-round",
      "action": "movement.to_player"
     }
    ],
    "path": "movement.teleport"
   },
   {
    "id": "waypoints",
    "title": "Waypoints",
    "icon": "map-pin",
    "pill": "Points",
    "desc": "Сохранить точку, прыгнуть, удалить",
    "fields": [
     {
      "type": "select",
      "id": "slot",
      "label": "Slot",
      "options": [
       "W1",
       "W2",
       "W3",
       "W4",
       "W5"
      ],
      "value": "W1"
     },
     {
      "type": "button",
      "id": "save",
      "text": "Save here",
      "icon": "save",
      "action": "movement.waypoint_save"
     },
     {
      "type": "button",
      "id": "go",
      "text": "Teleport",
      "icon": "arrow-right",
      "action": "movement.waypoint_go"
     },
     {
      "type": "button",
      "id": "delete",
      "text": "Delete",
      "icon": "trash-2",
      "action": "movement.waypoint_delete"
     }
    ],
    "path": "movement.waypoints"
   },
   {
    "id": "dash",
    "title": "Auto Dash",
    "icon": "wind",
    "pill": "Dash",
    "toggle": true,
    "desc": "Рывок в сторону движения с кулдауном",
    "fields": [
     {
      "type": "slider",
      "id": "power",
      "label": "Power",
      "min": 20,
      "max": 200,
      "value": 90
     },
     {
      "type": "slider",
      "id": "cooldown",
      "label": "Cooldown",
      "min": 0.1,
      "max": 3,
      "value": 0.6,
      "decimals": 2,
      "suffix": "s"
     },
     {
      "type": "keybind",
      "id": "toggle_key",
      "label": "Toggle key"
     }
    ],
    "path": "movement.dash"
   }
  ]
 },
 {
  "id": "farm",
  "icon": "coins",
  "title": "Farm",
  "cards": [
   {
    "id": "autofarm",
    "title": "Auto Farm",
    "icon": "swords",
    "pill": "Farm",
    "toggle": true,
    "desc": "NPC и мобы: выбор цели, радиус, приоритет, тайминги",
    "fields": [
     {
      "type": "select",
      "id": "attack",
      "label": "Attack",
      "options": [
       "M1",
       "Abilities",
       "Mixed"
      ],
      "value": "Mixed"
     },
     {
      "type": "select",
      "id": "priority",
      "label": "Priority",
      "options": [
       "Nearest",
       "Lowest HP",
       "Highest HP"
      ],
      "value": "Nearest"
     },
     {
      "type": "slider",
      "id": "radius",
      "label": "Radius",
      "min": 50,
      "max": 2000,
      "value": 900,
      "suffix": " st"
     },
     {
      "type": "slider",
      "id": "delay",
      "label": "Attack speed",
      "min": 0.05,
      "max": 1,
      "value": 0.2,
      "decimals": 2,
      "suffix": "s"
     },
     {
      "type": "checkbox",
      "id": "tp",
      "label": "TP to target",
      "value": true
     },
     {
      "type": "multi",
      "id": "abilities",
      "label": "Ability order",
      "options": [
       "Barrage",
       "Heavy",
       "Special",
       "Ultimate"
      ]
     },
     {
      "type": "keybind",
      "id": "farm_key",
      "label": "Toggle key"
     }
    ],
    "path": "farm.autofarm"
   },
   {
    "id": "sell",
    "title": "Auto Sell",
    "icon": "banknote",
    "pill": "Sell",
    "toggle": true,
    "desc": "Продажа мерчанту между циклами, с фильтром редкости",
    "fields": [
     {
      "type": "multi",
      "id": "rarity",
      "label": "Rarity filter",
      "options": [
       "Common",
       "Uncommon",
       "Rare",
       "Epic",
       "Legendary",
       "Mythic"
      ]
     },
     {
      "type": "checkbox",
      "id": "skip_dialogue",
      "label": "Skip dialogue",
      "hint": "Ускоряет продажу и сбор Roka",
      "value": true
     },
     {
      "type": "slider",
      "id": "interval",
      "label": "Interval",
      "min": 5,
      "max": 120,
      "value": 20,
      "suffix": "s"
     },
     {
      "type": "slider",
      "id": "threshold",
      "label": "Money threshold",
      "min": 0,
      "max": 100000,
      "value": 0
     }
    ],
    "path": "farm.sell"
   },
   {
    "id": "buy",
    "title": "Auto Buy",
    "icon": "shopping-cart",
    "pill": "Buy",
    "toggle": true,
    "desc": "Lucky Arrow, Roka, Corpse Parts и прочее",
    "fields": [
     {
      "type": "multi",
      "id": "items",
      "label": "Items",
      "options": [
       "Lucky Arrow",
       "Roka",
       "Corpse Parts",
       "Diary",
       "Rib Cage"
      ]
     },
     {
      "type": "slider",
      "id": "interval",
      "label": "Delay",
      "min": 2,
      "max": 60,
      "value": 10,
      "suffix": "s"
     },
     {
      "type": "slider",
      "id": "price_limit",
      "label": "Price limit",
      "min": 0,
      "max": 100000,
      "value": 5000
     }
    ],
    "path": "farm.buy"
   },
   {
    "id": "roll",
    "title": "Auto Roll",
    "icon": "dice",
    "pill": "Roll",
    "toggle": true,
    "desc": "Стрела → проверка стенда → Roka → повтор, стоп на редком",
    "fields": [
     {
      "type": "multi",
      "id": "whitelist",
      "label": "Whitelist",
      "options": [
       "Star Platinum",
       "The World",
       "Killer Queen",
       "Crazy Diamond",
       "Gold Experience",
       "King Crimson",
       "Made in Heaven",
       "D4C",
       "C-Moon",
       "Whitesnake"
      ]
     },
     {
      "type": "checkbox",
      "id": "stop_rare",
      "label": "Stop on rare",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "log",
      "label": "Log rolls",
      "value": true
     },
     {
      "type": "slider",
      "id": "delay",
      "label": "Roll delay",
      "min": 0.5,
      "max": 10,
      "value": 2,
      "decimals": 1,
      "suffix": "s"
     },
     {
      "type": "keybind",
      "id": "roll_key",
      "label": "Toggle key"
     }
    ],
    "path": "farm.roll"
   },
   {
    "id": "collect",
    "title": "Auto Collect",
    "icon": "package",
    "pill": "Loot",
    "toggle": true,
    "desc": "ТП к спавну итема и подбор по приоритету",
    "fields": [
     {
      "type": "multi",
      "id": "items",
      "label": "Item priority",
      "options": [
       "Roka",
       "Pure Roka",
       "Arrow",
       "Diary",
       "Corpse Parts",
       "Rib Cage",
       "Lucky Arrow"
      ]
     },
     {
      "type": "checkbox",
      "id": "tp",
      "label": "TP to item",
      "value": true
     },
     {
      "type": "slider",
      "id": "max_distance",
      "label": "Max distance",
      "min": 20,
      "max": 800,
      "value": 400,
      "suffix": " st"
     },
     {
      "type": "slider",
      "id": "delay",
      "label": "Scan delay",
      "min": 0.2,
      "max": 5,
      "value": 0.8,
      "decimals": 1,
      "suffix": "s"
     }
    ],
    "path": "farm.collect"
   },
   {
    "id": "quest",
    "title": "Auto Quest",
    "icon": "scroll",
    "pill": "Quest",
    "toggle": true,
    "desc": "Берёт и сдаёт квесты по NPC-цепочке",
    "fields": [
     {
      "type": "checkbox",
      "id": "accept",
      "label": "Auto accept",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "turn_in",
      "label": "Auto turn in",
      "value": true
     },
     {
      "type": "slider",
      "id": "delay",
      "label": "Delay",
      "min": 1,
      "max": 30,
      "value": 3,
      "suffix": "s"
     }
    ],
    "path": "farm.quest"
   },
   {
    "id": "stats",
    "title": "Farm Stats",
    "icon": "chart",
    "pill": "Stats",
    "desc": "Счётчики в HUD фарма",
    "fields": [
     {
      "type": "checkbox",
      "id": "kills",
      "label": "Kill counter",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "cycle",
      "label": "Cycle time",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "money",
      "label": "Money / hour",
      "value": true
     },
     {
      "type": "button",
      "id": "reset",
      "text": "Reset stats",
      "icon": "rotate-ccw",
      "action": "farm.reset"
     }
    ],
    "path": "farm.stats"
   }
  ]
 },
 {
  "id": "visuals",
  "icon": "image",
  "title": "Visuals",
  "cards": [
   {
    "id": "players",
    "title": "Player ESP",
    "icon": "users",
    "pill": "ESP",
    "toggle": true,
    "desc": "Бокс, имя, дистанция, HP, chams, трассеры",
    "fields": [
     {
      "type": "checkbox",
      "id": "box",
      "label": "Box",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "name",
      "label": "Name",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "distance",
      "label": "Distance",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "health",
      "label": "Health bar",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "chams",
      "label": "Chams"
     },
     {
      "type": "checkbox",
      "id": "tracers",
      "label": "Tracers"
     },
     {
      "type": "slider",
      "id": "max_distance",
      "label": "Max distance",
      "min": 50,
      "max": 2000,
      "value": 500,
      "suffix": " st"
     }
    ],
    "path": "visuals.players"
   },
   {
    "id": "items",
    "title": "Item ESP",
    "icon": "package",
    "pill": "Loot",
    "toggle": true,
    "desc": "Roka, Pure Roka, Corpse Parts, Diary, Lucky Arrow, Rib Cage",
    "fields": [
     {
      "type": "checkbox",
      "id": "rare_only",
      "label": "Rare only",
      "value": false
     },
     {
      "type": "checkbox",
      "id": "sound",
      "label": "Sound alert",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "names",
      "label": "Show names",
      "value": true
     },
     {
      "type": "slider",
      "id": "max_distance",
      "label": "Max distance",
      "min": 50,
      "max": 1500,
      "value": 400,
      "suffix": " st"
     }
    ],
    "path": "visuals.items"
   },
   {
    "id": "npcs",
    "title": "NPC ESP",
    "icon": "bot",
    "pill": "NPC",
    "toggle": true,
    "desc": "Мобы и боссы, приоритет по имени",
    "fields": [
     {
      "type": "checkbox",
      "id": "bosses",
      "label": "Bosses only"
     },
     {
      "type": "slider",
      "id": "max_distance",
      "label": "Max distance",
      "min": 50,
      "max": 1500,
      "value": 600,
      "suffix": " st"
     }
    ],
    "path": "visuals.npcs"
   },
   {
    "id": "remove_mih",
    "title": "Remove MIH Reset",
    "icon": "sun",
    "pill": "MIH",
    "toggle": true,
    "desc": "Убирает анимацию world reset без нагрузки на кадры",
    "fields": [
     {
      "type": "checkbox",
      "id": "reset_anim",
      "label": "Reset animation",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "particles",
      "label": "Particles",
      "value": true
     }
    ],
    "path": "visuals.remove_mih"
   },
   {
    "id": "remove_kq",
    "title": "Remove KQ Effects",
    "icon": "bomb",
    "pill": "KQ",
    "toggle": true,
    "desc": "Взрывы и партиклы Killer Queen и Bites the Dust",
    "fields": [
     {
      "type": "checkbox",
      "id": "explosions",
      "label": "Explosion effects",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "particles",
      "label": "Particles",
      "value": true
     }
    ],
    "path": "visuals.remove_kq"
   },
   {
    "id": "low_gfx",
    "title": "Low GFX",
    "icon": "monitor",
    "pill": "FPS",
    "toggle": true,
    "desc": "Режет VFX, партиклы и постобработку через Modules.Composer",
    "fields": [
     {
      "type": "checkbox",
      "id": "vfx",
      "label": "VFX",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "particles",
      "label": "Particles",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "postfx",
      "label": "Post FX",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "shadows",
      "label": "Shadows",
      "value": true
     }
    ],
    "path": "visuals.low_gfx"
   },
   {
    "id": "camera",
    "title": "Camera",
    "icon": "camera",
    "pill": "View",
    "toggle": true,
    "desc": "FOV unlock, zoom unlock, freecam",
    "fields": [
     {
      "type": "slider",
      "id": "fov",
      "label": "FOV",
      "min": 50,
      "max": 120,
      "value": 70
     },
     {
      "type": "slider",
      "id": "zoom",
      "label": "Max zoom",
      "min": 32,
      "max": 512,
      "value": 128
     },
     {
      "type": "checkbox",
      "id": "freecam",
      "label": "Freecam"
     }
    ],
    "path": "visuals.camera"
   },
   {
    "id": "hud",
    "title": "HUD",
    "icon": "layout",
    "pill": "HUD",
    "toggle": true,
    "value": true,
    "desc": "Watermark, keybinds и счётчики",
    "fields": [
     {
      "type": "checkbox",
      "id": "player",
      "label": "Player name",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "fps",
      "label": "FPS",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "ping",
      "label": "Ping",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "rage",
      "label": "Rage tracker",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "barrage",
      "label": "Barrage timer",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "farm",
      "label": "Farm stats",
      "value": false
     },
     {
      "type": "checkbox",
      "id": "target",
      "label": "Target info",
      "value": false
     },
     {
      "type": "checkbox",
      "id": "coords",
      "label": "Coordinates",
      "value": false
     }
    ],
    "path": "visuals.hud"
   }
  ]
 },
 {
  "id": "protection",
  "icon": "shield",
  "title": "Protection",
  "cards": [
   {
    "id": "anti_ts",
    "title": "Anti Time Stop",
    "icon": "clock",
    "pill": "TS",
    "toggle": true,
    "desc": "Камера и инпут не залипают в таймстопе",
    "fields": [
     {
      "type": "checkbox",
      "id": "restore_camera",
      "label": "Restore camera",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "restore_input",
      "label": "Restore input",
      "value": true
     }
    ],
    "path": "protection.anti_ts"
   },
   {
    "id": "anti_ger",
    "title": "Anti GER",
    "icon": "refresh",
    "pill": "GER",
    "toggle": true,
    "desc": "Возврат из reset-to-zero, стенд и абилки не сбрасываются",
    "fields": [
     {
      "type": "checkbox",
      "id": "keep_stand",
      "label": "Keep stand",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "keep_abilities",
      "label": "Keep abilities",
      "value": true
     }
    ],
    "path": "protection.anti_ger"
   },
   {
    "id": "anti_erase",
    "title": "Anti Time Erase",
    "icon": "history",
    "pill": "KC",
    "toggle": true,
    "desc": "Выход из пропуска KC/KCR",
    "fields": [
     {
      "type": "checkbox",
      "id": "restore_pos",
      "label": "Restore position",
      "value": true
     }
    ],
    "path": "protection.anti_erase"
   },
   {
    "id": "anti_stun",
    "title": "Anti Stun",
    "icon": "hand",
    "pill": "Stun",
    "toggle": true,
    "desc": "Быстрый выход из стана и рэгдолла",
    "fields": [
     {
      "type": "checkbox",
      "id": "cancel",
      "label": "Cancel ragdoll",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "clear_joints",
      "label": "Clear joints",
      "value": true
     }
    ],
    "path": "protection.anti_stun"
   },
   {
    "id": "anti_slow",
    "title": "Anti Slow",
    "icon": "rabbit",
    "pill": "Slow",
    "toggle": true,
    "desc": "Снимает дебаффы скорости от абилок",
    "fields": [
     {
      "type": "slider",
      "id": "minimum",
      "label": "Min speed",
      "min": 16,
      "max": 60,
      "value": 16
     }
    ],
    "path": "protection.anti_slow"
   },
   {
    "id": "anti_kick",
    "title": "Anti Kick",
    "icon": "shield-off",
    "pill": "Soft",
    "toggle": true,
    "desc": "Мягкий фильтр кик-причин, без палева",
    "fields": [
     {
      "type": "checkbox",
      "id": "log",
      "label": "Log kick reasons",
      "value": false
     }
    ],
    "path": "protection.anti_kick"
   },
   {
    "id": "anti_void",
    "title": "Anti Void",
    "icon": "anchor",
    "pill": "Void",
    "toggle": true,
    "value": true,
    "desc": "Упал за карту — вернуло на последнюю точку",
    "fields": [
     {
      "type": "slider",
      "id": "threshold",
      "label": "Y threshold",
      "min": -200,
      "max": 0,
      "value": -50
     }
    ],
    "path": "protection.anti_void"
   }
  ]
 },
 {
  "id": "files",
  "icon": "folder",
  "title": "Files",
  "cards": [
   {
    "id": "config",
    "title": "Config",
    "icon": "save",
    "pill": "v1.0",
    "desc": "Профили, автосейв, загрузка",
    "fields": [
     {
      "type": "button",
      "id": "save",
      "text": "Save config",
      "icon": "save",
      "action": "files.config.save"
     },
     {
      "type": "button",
      "id": "load",
      "text": "Load config",
      "icon": "upload",
      "action": "files.config.load"
     },
     {
      "type": "button",
      "id": "delete",
      "text": "Delete config",
      "icon": "trash-2",
      "action": "files.config.delete"
     },
     {
      "type": "checkbox",
      "id": "autosave",
      "label": "Autosave on unload",
      "value": true
     }
    ],
    "path": "files.config"
   },
   {
    "id": "keybinds",
    "title": "Keybinds",
    "icon": "keyboard",
    "pill": "Keys",
    "desc": "Список биндов и очистка",
    "fields": [
     {
      "type": "button",
      "id": "list",
      "text": "List keybinds",
      "icon": "list",
      "action": "files.keybinds.list"
     },
     {
      "type": "button",
      "id": "clear",
      "text": "Clear keybinds",
      "icon": "eraser",
      "action": "files.keybinds.clear"
     }
    ],
    "path": "files.keybinds"
   },
   {
    "id": "interface",
    "title": "Interface",
    "icon": "layout",
    "pill": "UI",
    "desc": "Тема, масштаб, блюр, клавиша меню",
    "fields": [
     {
      "type": "slider",
      "id": "scale",
      "label": "Scale",
      "min": 0.7,
      "max": 1.4,
      "value": 1,
      "decimals": 2
     },
     {
      "type": "checkbox",
      "id": "blur",
      "label": "Blur background"
     },
     {
      "type": "keybind",
      "id": "menu_key",
      "label": "Menu key",
      "value": "RightShift"
     }
    ],
    "path": "files.interface"
   },
   {
    "id": "about",
    "title": "About",
    "icon": "info",
    "pill": "Build",
    "desc": "Загрузка с GitHub, reload, unload",
    "fields": [
     {
      "type": "button",
      "id": "copy",
      "text": "Copy loadstring",
      "icon": "terminal",
      "action": "files.about.copy"
     },
     {
      "type": "button",
      "id": "reload",
      "text": "Reload",
      "icon": "rotate-ccw",
      "action": "files.about.reload"
     },
     {
      "type": "button",
      "id": "unload",
      "text": "Unload",
      "icon": "power",
      "action": "files.about.unload"
     }
    ],
    "path": "files.about"
   }
  ]
 }
];
