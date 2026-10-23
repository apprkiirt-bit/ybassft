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
    "desc": "Управление стендом как пилотом, на любом стенде",
    "fields": [
     {
      "type": "select",
      "id": "mode",
      "label": "Mode",
      "options": [
       "Free",
       "Orbit",
       "Locked",
       "Follow"
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
      "label": "Speed",
      "min": 5,
      "max": 120,
      "value": 34
     },
     {
      "type": "checkbox",
      "id": "resummon",
      "label": "Auto re-summon",
      "value": true
     },
     {
      "type": "keybind",
      "id": "key",
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
    "desc": "Стенд тп-шится к цели и бьёт за тебя",
    "fields": [
     {
      "type": "select",
      "id": "target",
      "label": "Target",
      "options": [
       "Selected",
       "Nearest",
       "Crosshair",
       "Lowest HP"
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
       "Finisher",
       "Projectile",
       "Heavy",
       "Grab",
       "Heal",
       "Counter"
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
      "id": "key",
      "label": "Toggle key"
     }
    ],
    "path": "combat.stand_attack"
   },
   {
    "id": "movestack",
    "title": "Movestack",
    "icon": "layers",
    "pill": "2x",
    "toggle": true,
    "desc": "Две абилки одновременно, как старый баг с боксом",
    "fields": [
     {
      "type": "select",
      "id": "first",
      "label": "Ability 1",
      "options": [
       "Barrage",
       "Heavy",
       "Projectile",
       "Grab",
       "Counter",
       "Heal",
       "M1"
      ],
      "value": "Barrage"
     },
     {
      "type": "select",
      "id": "second",
      "label": "Ability 2",
      "options": [
       "Boxing barrage",
       "Hamon",
       "Spin",
       "Sword",
       "Vampire",
       "M1"
      ],
      "value": "Boxing barrage"
     },
     {
      "type": "slider",
      "id": "delay",
      "label": "Stack delay",
      "min": 0,
      "max": 0.5,
      "value": 0.04,
      "decimals": 2,
      "suffix": "s"
     },
     {
      "type": "checkbox",
      "id": "repeat",
      "label": "Hold to repeat"
     },
     {
      "type": "keybind",
      "id": "key",
      "label": "Stack key"
     }
    ],
    "path": "combat.movestack"
   },
   {
    "id": "attack_aura",
    "title": "Attack Aura",
    "icon": "zap",
    "pill": "Aura",
    "toggle": true,
    "fields": [
     {
      "type": "slider",
      "id": "range",
      "label": "Range",
      "min": 3,
      "max": 30,
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
      "type": "slider",
      "id": "delay",
      "label": "Delay",
      "min": 0.05,
      "max": 1,
      "value": 0.2,
      "decimals": 2,
      "suffix": "s"
     },
     {
      "type": "checkbox",
      "id": "players",
      "label": "Include players",
      "value": false
     },
     {
      "type": "multi",
      "id": "ignore",
      "label": "Ignore list",
      "options": [
       "Friends",
       "Party",
       "Low HP",
       "NPC",
       "Dummies"
      ]
     }
    ],
    "path": "combat.attack_aura"
   },
   {
    "id": "auto_block",
    "title": "Auto Block",
    "icon": "shield",
    "pill": "Guard",
    "toggle": true,
    "desc": "Держит блок под атакой, умеет ловить perfect block",
    "fields": [
     {
      "type": "select",
      "id": "mode",
      "label": "Mode",
      "options": [
       "Hold",
       "Proximity",
       "On attack",
       "Smart"
      ],
      "value": "Proximity"
     },
     {
      "type": "slider",
      "id": "range",
      "label": "Trigger range",
      "min": 2,
      "max": 30,
      "value": 10,
      "suffix": " st"
     },
     {
      "type": "checkbox",
      "id": "parry",
      "label": "Perfect block window",
      "value": true
     },
     {
      "type": "slider",
      "id": "window",
      "label": "Parry window",
      "min": 0.05,
      "max": 0.4,
      "value": 0.14,
      "decimals": 2,
      "suffix": "s"
     },
     {
      "type": "checkbox",
      "id": "barraged",
      "label": "Block while barraged",
      "value": true
     },
     {
      "type": "keybind",
      "id": "key",
      "label": "Toggle key"
     }
    ],
    "path": "combat.auto_block"
   },
   {
    "id": "fast_m1",
    "title": "Fast M1",
    "icon": "mouse-pointer-click",
    "pill": "Fast",
    "toggle": true,
    "fields": [
     {
      "type": "slider",
      "id": "delay",
      "label": "Click delay",
      "min": 0.02,
      "max": 0.3,
      "value": 0.06,
      "decimals": 2,
      "suffix": "s"
     },
     {
      "type": "checkbox",
      "id": "anim",
      "label": "Skip swing animation",
      "value": true
     },
     {
      "type": "keybind",
      "id": "key",
      "label": "Toggle key"
     }
    ],
    "path": "combat.fast_m1"
   },
   {
    "id": "target_lock",
    "title": "Target Lock",
    "icon": "crosshair",
    "pill": "Lock",
    "toggle": true,
    "fields": [
     {
      "type": "select",
      "id": "mode",
      "label": "Mode",
      "options": [
       "Camera",
       "Character",
       "Stand"
      ],
      "value": "Camera"
     },
     {
      "type": "slider",
      "id": "smooth",
      "label": "Smoothing",
      "min": 0,
      "max": 1,
      "value": 0.35,
      "decimals": 2
     },
     {
      "type": "checkbox",
      "id": "follow",
      "label": "Follow through walls",
      "value": false
     },
     {
      "type": "keybind",
      "id": "key",
      "label": "Lock key"
     }
    ],
    "path": "combat.target_lock"
   },
   {
    "id": "ability_use",
    "title": "Ability Auto-Use",
    "icon": "activity",
    "pill": "Cycle",
    "toggle": true,
    "fields": [
     {
      "type": "multi",
      "id": "abilities",
      "label": "Rotation",
      "options": [
       "Barrage",
       "Heavy",
       "Projectile",
       "Grab",
       "Counter",
       "Heal",
       "Awakening"
      ]
     },
     {
      "type": "slider",
      "id": "delay",
      "label": "Step delay",
      "min": 0.1,
      "max": 2,
      "value": 0.5,
      "decimals": 2,
      "suffix": "s"
     },
     {
      "type": "slider",
      "id": "hp",
      "label": "Heal under",
      "min": 10,
      "max": 100,
      "value": 55,
      "suffix": "%"
     },
     {
      "type": "checkbox",
      "id": "onattack",
      "label": "Only while in combat",
      "value": true
     }
    ],
    "path": "combat.ability_use"
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
    "title": "Speed",
    "icon": "wind",
    "pill": "Move",
    "toggle": true,
    "fields": [
     {
      "type": "slider",
      "id": "value",
      "label": "WalkSpeed",
      "min": 16,
      "max": 300,
      "value": 34
     },
     {
      "type": "checkbox",
      "id": "jump",
      "label": "Scale jump too"
     },
     {
      "type": "keybind",
      "id": "key",
      "label": "Toggle key"
     }
    ],
    "path": "movement.speed"
   },
   {
    "id": "jump",
    "title": "Jump",
    "icon": "arrow-up-right",
    "pill": "Jump",
    "toggle": true,
    "fields": [
     {
      "type": "slider",
      "id": "power",
      "label": "JumpPower",
      "min": 50,
      "max": 250,
      "value": 70
     },
     {
      "type": "checkbox",
      "id": "infinite",
      "label": "Infinite jump",
      "value": true
     }
    ],
    "path": "movement.jump"
   },
   {
    "id": "fly",
    "title": "Fly",
    "icon": "orbit",
    "pill": "Fly",
    "toggle": true,
    "fields": [
     {
      "type": "slider",
      "id": "speed",
      "label": "Speed",
      "min": 10,
      "max": 300,
      "value": 80
     },
     {
      "type": "select",
      "id": "mode",
      "label": "Mode",
      "options": [
       "CFrame",
       "Velocity",
       "Hybrid"
      ],
      "value": "CFrame"
     },
     {
      "type": "checkbox",
      "id": "vertical",
      "label": "Space / Ctrl vertical",
      "value": true
     },
     {
      "type": "keybind",
      "id": "key",
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
    "fields": [
     {
      "type": "checkbox",
      "id": "auto",
      "label": "Always on",
      "value": true
     },
     {
      "type": "keybind",
      "id": "key",
      "label": "Hold key"
     }
    ],
    "path": "movement.noclip"
   },
   {
    "id": "teleport",
    "title": "Teleport",
    "icon": "map-pin",
    "pill": "TP",
    "toggle": false,
    "fields": [
     {
      "type": "button",
      "id": "to_cursor",
      "text": "Teleport to cursor",
      "icon": "mouse-pointer-click"
     },
     {
      "type": "multi",
      "id": "player",
      "label": "Player",
      "options": [
       "Nearest",
       "Random",
       "Selected"
      ]
     },
     {
      "type": "button",
      "id": "to_player",
      "text": "Teleport to player",
      "icon": "user",
      "role": "accent"
     },
     {
      "type": "divider"
     },
     {
      "type": "button",
      "id": "save_point",
      "text": "Save waypoint",
      "icon": "save"
     },
     {
      "type": "multi",
      "id": "points",
      "label": "Waypoints",
      "options": [
       "Spawn",
       "Merchant",
       "Arcade",
       "Shop",
       "Boss"
      ]
     },
     {
      "type": "button",
      "id": "to_point",
      "text": "Teleport to waypoint",
      "icon": "arrow-right"
     }
    ],
    "path": "movement.teleport"
   },
   {
    "id": "hip",
    "title": "Hip Height",
    "icon": "move",
    "pill": "Body",
    "toggle": true,
    "fields": [
     {
      "type": "slider",
      "id": "value",
      "label": "HipHeight",
      "min": -2,
      "max": 12,
      "value": 2,
      "decimals": 1
     }
    ],
    "path": "movement.hip"
   }
  ]
 },
 {
  "id": "farm",
  "icon": "grid-2x2",
  "title": "Farm",
  "cards": [
   {
    "id": "auto_farm",
    "title": "Auto Farm",
    "icon": "target",
    "pill": "Core",
    "toggle": true,
    "desc": "Фарм NPC: цель, скорость, порядок абилок, дистанция",
    "fields": [
     {
      "type": "select",
      "id": "target",
      "label": "Target",
      "options": [
       "Nearest",
       "Selected",
       "Boss only",
       "Quest NPC",
       "Dummies",
       "Custom"
      ],
      "value": "Nearest"
     },
     {
      "type": "slider",
      "id": "radius",
      "label": "Search radius",
      "min": 10,
      "max": 300,
      "value": 90,
      "suffix": " st"
     },
     {
      "type": "select",
      "id": "attack",
      "label": "Attack mode",
      "options": [
       "M1",
       "Abilities",
       "Mixed",
       "Safest"
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
       "Projectile",
       "Grab",
       "Counter",
       "Awakening"
      ]
     },
     {
      "type": "slider",
      "id": "delay",
      "label": "Attack delay",
      "min": 0.05,
      "max": 1,
      "value": 0.18,
      "decimals": 2,
      "suffix": "s"
     },
     {
      "type": "slider",
      "id": "keep",
      "label": "Keep distance",
      "min": 2,
      "max": 25,
      "value": 6,
      "suffix": " st"
     },
     {
      "type": "checkbox",
      "id": "tp",
      "label": "Teleport to target",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "heal",
      "label": "Auto heal",
      "value": true
     },
     {
      "type": "slider",
      "id": "heal_hp",
      "label": "Heal under",
      "min": 10,
      "max": 80,
      "value": 45,
      "suffix": "%"
     },
     {
      "type": "slider",
      "id": "pause",
      "label": "Cycle pause",
      "min": 0,
      "max": 5,
      "value": 0.4,
      "decimals": 1,
      "suffix": "s"
     },
     {
      "type": "checkbox",
      "id": "stuck",
      "label": "Anti-stuck",
      "value": true
     },
     {
      "type": "keybind",
      "id": "key",
      "label": "Toggle key"
     }
    ],
    "path": "farm.auto_farm"
   },
   {
    "id": "farm_route",
    "title": "Farm Route",
    "icon": "map-pin",
    "pill": "Route",
    "toggle": false,
    "fields": [
     {
      "type": "select",
      "id": "zone",
      "label": "Zone",
      "options": [
       "Auto",
       "Naples",
       "Morioh",
       "Cafe",
       "Arcade",
       "Sewers"
      ],
      "value": "Auto"
     },
     {
      "type": "checkbox",
      "id": "return",
      "label": "Return to spot",
      "value": true
     },
     {
      "type": "slider",
      "id": "reset",
      "label": "Reset after",
      "min": 10,
      "max": 300,
      "value": 60,
      "decimals": 0,
      "suffix": "s"
     },
     {
      "type": "button",
      "id": "pin",
      "text": "Pin current position",
      "icon": "map-pin"
     }
    ],
    "path": "farm.farm_route"
   },
   {
    "id": "auto_sell",
    "title": "Auto Sell",
    "icon": "banknote",
    "pill": "Money",
    "toggle": true,
    "desc": "Продаёт лут, помогает фарму а не мешает ему",
    "fields": [
     {
      "type": "select",
      "id": "mode",
      "label": "Mode",
      "options": [
       "Everything",
       "By rarity",
       "Blacklist"
      ],
      "value": "By rarity"
     },
     {
      "type": "select",
      "id": "rarity",
      "label": "Sell at or below",
      "options": [
       "Common",
       "Uncommon",
       "Rare",
       "Legendary",
       "Mythic"
      ],
      "value": "Uncommon"
     },
     {
      "type": "multi",
      "id": "keep",
      "label": "Never sell",
      "options": [
       "Roka",
       "Pure Roka",
       "Corpse Part",
       "Diary",
       "Lucky Arrow",
       "Rib Cage"
      ]
     },
     {
      "type": "slider",
      "id": "reserve",
      "label": "Money reserve",
      "min": 0,
      "max": 30000,
      "value": 5000
     },
     {
      "type": "slider",
      "id": "interval",
      "label": "Interval",
      "min": 1,
      "max": 60,
      "value": 6,
      "suffix": "s"
     },
     {
      "type": "checkbox",
      "id": "sync",
      "label": "Sell between farm cycles",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "skip",
      "label": "Skip merchant dialogue",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "notify",
      "label": "Notify on sell",
      "value": true
     }
    ],
    "path": "farm.auto_sell"
   },
   {
    "id": "auto_collect",
    "title": "Auto Collect",
    "icon": "package",
    "pill": "Loot",
    "toggle": true,
    "fields": [
     {
      "type": "multi",
      "id": "priority",
      "label": "Priority",
      "options": [
       "Roka",
       "Pure Roka",
       "Corpse Part",
       "Diary",
       "Lucky Arrow",
       "Any"
      ]
     },
     {
      "type": "slider",
      "id": "distance",
      "label": "Max distance",
      "min": 50,
      "max": 600,
      "value": 250,
      "suffix": " st"
     },
     {
      "type": "checkbox",
      "id": "tp",
      "label": "Teleport on pickup",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "sound",
      "label": "Sound on rare",
      "value": true
     }
    ],
    "path": "farm.auto_collect"
   },
   {
    "id": "auto_buy",
    "title": "Auto Buy",
    "icon": "shopping-cart",
    "pill": "Shop",
    "toggle": false,
    "fields": [
     {
      "type": "multi",
      "id": "items",
      "label": "Items",
      "options": [
       "Lucky Arrow",
       "Roka",
       "Arrow",
       "Rib Cage",
       "Stone Mask",
       "Corpse Part"
      ]
     },
     {
      "type": "slider",
      "id": "price",
      "label": "Max price",
      "min": 100,
      "max": 30000,
      "value": 2500
     },
     {
      "type": "slider",
      "id": "reserve",
      "label": "Keep money",
      "min": 0,
      "max": 30000,
      "value": 1000
     },
     {
      "type": "slider",
      "id": "interval",
      "label": "Restock check",
      "min": 1,
      "max": 60,
      "value": 10,
      "suffix": "s"
     },
     {
      "type": "checkbox",
      "id": "confirm",
      "label": "Confirm purchase",
      "value": true
     }
    ],
    "path": "farm.auto_buy"
   },
   {
    "id": "auto_roll",
    "title": "Auto Roll",
    "icon": "refresh-cw",
    "pill": "Stands",
    "toggle": false,
    "fields": [
     {
      "type": "multi",
      "id": "goal",
      "label": "Keep stands",
      "options": [
       "Star Platinum",
       "The World",
       "Killer Queen",
       "Gold Experience",
       "King Crimson",
       "Tusk",
       "D4C",
       "Whitesnake",
       "Made in Heaven"
      ]
     },
     {
      "type": "slider",
      "id": "arrows",
      "label": "Max arrows",
      "min": 1,
      "max": 100,
      "value": 10
     },
     {
      "type": "select",
      "id": "fail",
      "label": "On fail",
      "options": [
       "Use Roka",
       "Keep rolling",
       "Stop"
      ],
      "value": "Use Roka"
     },
     {
      "type": "checkbox",
      "id": "stop_rare",
      "label": "Stop on rare skin",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "log",
      "label": "Log results",
      "value": true
     }
    ],
    "path": "farm.auto_roll"
   },
   {
    "id": "auto_quest",
    "title": "Auto Quest",
    "icon": "list",
    "pill": "Quest",
    "toggle": false,
    "fields": [
     {
      "type": "select",
      "id": "chain",
      "label": "Chain",
      "options": [
       "Auto",
       "Storyline",
       "DIO",
       "Jotaro",
       "Jesus"
      ],
      "value": "Auto"
     },
     {
      "type": "checkbox",
      "id": "accept",
      "label": "Auto accept",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "skip",
      "label": "Skip dialogue",
      "value": true
     },
     {
      "type": "slider",
      "id": "speed",
      "label": "Dialogue speed",
      "min": 0.05,
      "max": 1,
      "value": 0.1,
      "decimals": 2,
      "suffix": "s"
     },
     {
      "type": "checkbox",
      "id": "turnin",
      "label": "Auto turn in",
      "value": true
     }
    ],
    "path": "farm.auto_quest"
   },
   {
    "id": "stats",
    "title": "Farm Stats",
    "icon": "gauge",
    "pill": "Live",
    "toggle": false,
    "fields": [
     {
      "type": "hint",
      "label": "Kills, cycles and money per hour are shown in the HUD"
     },
     {
      "type": "button",
      "id": "reset",
      "text": "Reset stats",
      "icon": "rotate-ccw"
     },
     {
      "type": "button",
      "id": "copy",
      "text": "Copy session report",
      "icon": "save"
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
    "id": "hud",
    "title": "HUD",
    "icon": "monitor",
    "pill": "Overlay",
    "toggle": true,
    "desc": "Выбери что показывать в оверлее",
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
   },
   {
    "id": "player_esp",
    "title": "Player ESP",
    "icon": "users",
    "pill": "ESP",
    "toggle": true,
    "fields": [
     {
      "type": "checkbox",
      "id": "name",
      "label": "Name",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "box",
      "label": "Box",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "hp",
      "label": "Health",
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
      "id": "tracer",
      "label": "Tracer",
      "value": false
     },
     {
      "type": "checkbox",
      "id": "chams",
      "label": "Chams",
      "value": false
     },
     {
      "type": "slider",
      "id": "max",
      "label": "Max distance",
      "min": 50,
      "max": 2000,
      "value": 500,
      "suffix": " st"
     },
     {
      "type": "select",
      "id": "color",
      "label": "Color",
      "options": [
       "Theme",
       "Red",
       "Green",
       "Cyan",
       "White"
      ],
      "value": "Theme"
     }
    ],
    "path": "visuals.player_esp"
   },
   {
    "id": "item_esp",
    "title": "Item ESP",
    "icon": "package",
    "pill": "Loot",
    "toggle": true,
    "fields": [
     {
      "type": "multi",
      "id": "priority",
      "label": "Priority",
      "options": [
       "Roka",
       "Pure Roka",
       "Corpse Part",
       "Diary",
       "Lucky Arrow",
       "Rib Cage",
       "Any"
      ]
     },
     {
      "type": "slider",
      "id": "max",
      "label": "Max distance",
      "min": 100,
      "max": 3000,
      "value": 900,
      "suffix": " st"
     },
     {
      "type": "checkbox",
      "id": "beam",
      "label": "Beam marker",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "sound",
      "label": "Sound on spawn",
      "value": true
     }
    ],
    "path": "visuals.item_esp"
   },
   {
    "id": "npc_esp",
    "title": "NPC ESP",
    "icon": "skull",
    "pill": "ESP",
    "toggle": false,
    "fields": [
     {
      "type": "multi",
      "id": "filter",
      "label": "Show",
      "options": [
       "NPC",
       "Boss",
       "Dummy",
       "Quest"
      ]
     },
     {
      "type": "slider",
      "id": "max",
      "label": "Max distance",
      "min": 50,
      "max": 2000,
      "value": 400,
      "suffix": " st"
     }
    ],
    "path": "visuals.npc_esp"
   },
   {
    "id": "effects",
    "title": "Effects",
    "icon": "sparkles",
    "pill": "VFX",
    "toggle": true,
    "desc": "Режет тяжёлые эффекты, чтобы не лагало",
    "fields": [
     {
      "type": "checkbox",
      "id": "worldreset",
      "label": "Remove world reset animation",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "kq",
      "label": "Remove Killer Queen explosions",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "kqbtd",
      "label": "Remove KQ: Bites the Dust explosion",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "ability_vfx",
      "label": "Remove ability VFX",
      "value": false
     },
     {
      "type": "checkbox",
      "id": "cutscenes",
      "label": "Skip cutscenes",
      "value": false
     },
     {
      "type": "checkbox",
      "id": "speedlines",
      "label": "Remove speed lines",
      "value": false
     }
    ],
    "path": "visuals.effects"
   },
   {
    "id": "graphics",
    "title": "Graphics",
    "icon": "cpu",
    "pill": "FPS",
    "toggle": true,
    "fields": [
     {
      "type": "select",
      "id": "quality",
      "label": "Quality",
      "options": [
       "Low",
       "Medium",
       "High",
       "Custom"
      ],
      "value": "Low"
     },
     {
      "type": "checkbox",
      "id": "post",
      "label": "Disable post-processing",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "particles",
      "label": "Disable particles",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "shadows",
      "label": "Disable shadows",
      "value": false
     },
     {
      "type": "slider",
      "id": "fps",
      "label": "FPS cap",
      "min": 30,
      "max": 360,
      "value": 240
     }
    ],
    "path": "visuals.graphics"
   },
   {
    "id": "camera",
    "title": "Camera",
    "icon": "eye",
    "pill": "View",
    "toggle": true,
    "fields": [
     {
      "type": "slider",
      "id": "fov",
      "label": "FOV",
      "min": 40,
      "max": 120,
      "value": 70
     },
     {
      "type": "checkbox",
      "id": "zoom",
      "label": "Unlock zoom",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "freecam",
      "label": "Freecam",
      "value": false
     },
     {
      "type": "checkbox",
      "id": "shake",
      "label": "Remove camera shake",
      "value": true
     },
     {
      "type": "keybind",
      "id": "key",
      "label": "Freecam key"
     }
    ],
    "path": "visuals.camera"
   },
   {
    "id": "trackers",
    "title": "Rage & Barrage",
    "icon": "flame",
    "pill": "Track",
    "toggle": true,
    "fields": [
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
      "type": "select",
      "id": "mode",
      "label": "Display",
      "options": [
       "HUD row",
       "Bar",
       "Both"
      ],
      "value": "HUD row"
     },
     {
      "type": "slider",
      "id": "warn",
      "label": "Warn under",
      "min": 5,
      "max": 50,
      "value": 20,
      "suffix": "%"
     }
    ],
    "path": "visuals.trackers"
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
    "icon": "timer",
    "pill": "Anti",
    "toggle": true,
    "fields": [
     {
      "type": "select",
      "id": "mode",
      "label": "Mode",
      "options": [
       "Input",
       "Visual",
       "Both"
      ],
      "value": "Both"
     },
     {
      "type": "checkbox",
      "id": "camera",
      "label": "Restore camera",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "notify",
      "label": "Notify on stop",
      "value": false
     }
    ],
    "path": "protection.anti_ts"
   },
   {
    "id": "anti_ger",
    "title": "Anti GER",
    "icon": "rotate-ccw",
    "pill": "Anti",
    "toggle": true,
    "desc": "Возврат состояния после reset-to-zero",
    "fields": [
     {
      "type": "checkbox",
      "id": "stand",
      "label": "Restore stand",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "anim",
      "label": "Block reset animation",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "restore",
      "label": "Restore ability state",
      "value": true
     }
    ],
    "path": "protection.anti_ger"
   },
   {
    "id": "anti_erase",
    "title": "Anti Time Erase",
    "icon": "wind",
    "pill": "Anti",
    "toggle": true,
    "fields": [
     {
      "type": "select",
      "id": "mode",
      "label": "Mode",
      "options": [
       "Position",
       "State",
       "Both"
      ],
      "value": "Both"
     },
     {
      "type": "checkbox",
      "id": "cancel",
      "label": "Cancel stun after",
      "value": true
     }
    ],
    "path": "protection.anti_erase"
   },
   {
    "id": "anti_stun",
    "title": "Anti Stun",
    "icon": "activity",
    "pill": "Anti",
    "toggle": true,
    "fields": [
     {
      "type": "checkbox",
      "id": "ragdoll",
      "label": "Cancel ragdoll",
      "value": true
     },
     {
      "type": "slider",
      "id": "max",
      "label": "Max stun time",
      "min": 0,
      "max": 2,
      "value": 0.15,
      "decimals": 2,
      "suffix": "s"
     },
     {
      "type": "checkbox",
      "id": "anim",
      "label": "Reset animation",
      "value": true
     }
    ],
    "path": "protection.anti_stun"
   },
   {
    "id": "anti_slow",
    "title": "Anti Slow",
    "icon": "gauge",
    "pill": "Anti",
    "toggle": true,
    "fields": [
     {
      "type": "checkbox",
      "id": "walk",
      "label": "Restore WalkSpeed",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "jump",
      "label": "Restore JumpPower",
      "value": true
     }
    ],
    "path": "protection.anti_slow"
   },
   {
    "id": "anti_void",
    "title": "Anti Void",
    "icon": "arrow-up-right",
    "pill": "Safe",
    "toggle": true,
    "fields": [
     {
      "type": "slider",
      "id": "height",
      "label": "Min height",
      "min": -200,
      "max": 0,
      "value": -40
     },
     {
      "type": "checkbox",
      "id": "spawn",
      "label": "Teleport to spawn",
      "value": true
     },
     {
      "type": "checkbox",
      "id": "reset",
      "label": "Respawn if stuck",
      "value": false
     }
    ],
    "path": "protection.anti_void"
   },
   {
    "id": "anti_kick",
    "title": "Anti Kick",
    "icon": "lock",
    "pill": "Guard",
    "toggle": false,
    "fields": [
     {
      "type": "select",
      "id": "mode",
      "label": "Mode",
      "options": [
       "Soft",
       "Silent",
       "Strict"
      ],
      "value": "Soft"
     },
     {
      "type": "checkbox",
      "id": "log",
      "label": "Log to console",
      "value": true
     }
    ],
    "path": "protection.anti_kick"
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
    "pill": "Save",
    "toggle": false,
    "fields": [
     {
      "type": "button",
      "id": "save",
      "text": "Save current config",
      "icon": "save",
      "role": "accent"
     },
     {
      "type": "multi",
      "id": "slots",
      "label": "Profiles",
      "options": [
       "default",
       "pvp",
       "farm",
       "afk"
      ]
     },
     {
      "type": "button",
      "id": "load",
      "text": "Load selected",
      "icon": "upload"
     },
     {
      "type": "button",
      "id": "delete",
      "text": "Delete selected",
      "icon": "trash-2"
     }
    ],
    "path": "files.config"
   },
   {
    "id": "interface",
    "title": "Interface",
    "icon": "palette",
    "pill": "UI",
    "toggle": false,
    "fields": [
     {
      "type": "select",
      "id": "theme",
      "label": "Theme",
      "options": [
       "Violet",
       "Midnight",
       "Crimson",
       "Emerald",
       "Amber",
       "JoJo Gold",
       "Mono"
      ],
      "value": "Violet",
      "icon": "palette"
     },
     {
      "type": "slider",
      "id": "scale",
      "label": "Scale",
      "min": 0.7,
      "max": 1.3,
      "value": 1,
      "decimals": 2
     },
     {
      "type": "checkbox",
      "id": "blur",
      "label": "Background blur",
      "value": false
     },
     {
      "type": "checkbox",
      "id": "animations",
      "label": "Animations",
      "value": true
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
    "pill": "v1.0",
    "toggle": false,
    "fields": [
     {
      "type": "hint",
      "label": "ybassft — YBA utility. GUI stage build, features wiring in progress."
     },
     {
      "type": "button",
      "id": "copy",
      "text": "Copy loadstring",
      "icon": "terminal"
     },
     {
      "type": "button",
      "id": "reload",
      "text": "Reload script",
      "icon": "refresh-cw"
     },
     {
      "type": "button",
      "id": "unload",
      "text": "Unload",
      "icon": "power",
      "role": "accent"
     }
    ],
    "path": "files.about"
   },
   {
    "id": "keybinds",
    "title": "Keybinds",
    "icon": "keyboard",
    "pill": "Keys",
    "toggle": false,
    "fields": [
     {
      "type": "hint",
      "label": "Show every active keybind in one list"
     },
     {
      "type": "button",
      "id": "list",
      "text": "List keybinds",
      "icon": "list"
     },
     {
      "type": "button",
      "id": "clear",
      "text": "Clear all",
      "icon": "trash-2"
     }
    ],
    "path": "files.keybinds"
   }
  ]
 }
];
