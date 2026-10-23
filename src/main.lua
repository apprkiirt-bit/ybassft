-- ybassft | YBA utility
local RAW = "https://raw.githubusercontent.com/USER/ybassft/main/"

local function join(...)
	return table.concat({ ... }, "/")
end

local loaded = {}
local function require(name)
	if loaded[name] then
		return loaded[name]
	end
	local path = join(RAW, "src", (string.gsub(name, "%.", "/")) .. ".lua")
	local source = game:HttpGet(path)
	local chunk = assert(loadstring(source, "ybassft:" .. name))
	local module = chunk()
	module = module({ require = require })
	loaded[name] = module
	return module
end

local Util = require("core.util")
local Signal = require("core.signal")
local Store = require("core.store")
local Icons = require("core.icons")
local Config = require("core.config")
local Theme = require("ui.theme")
local Notify = require("ui.notify")
local Window = require("ui.window")
local HUD = require("ui.hud")
local Registry = require("features.registry")

Icons.setup(RAW, join(RAW, "assets", "icons"))
Config.init()

if getgenv and getgenv().ybassft then
	pcall(function()
		getgenv().ybassft.unload()
	end)
end

local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local screen = Util.create("ScreenGui", {
	Name = "ybassft",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	DisplayOrder = 9999,
	Parent = playerGui,
})

local saved = Config.load("autoload")
Store.loadDefaults(Registry.defaults())
if saved then
	Store.setRaw(saved)
	Store.loadDefaults(Registry.defaults())
end

Registry.hydrate(Store)

local themeByLabel = {}
for id, palette in pairs(Theme.palettes) do
	themeByLabel[palette.label] = id
end

local function applyTheme(label, animated)
	local id = themeByLabel[label] or "violet"
	Theme.apply(id, animated)
	Store.set("files.interface.theme", label)
end

Notify.init(screen)
Window.init(screen, Registry.tabs, Store)
HUD.init(screen, Store)

local function applyScale()
	local scale = Store.get("files.interface.scale", 1)
	local uiScale = Window.scale()
	if uiScale then
		Util.tween(uiScale, 0.15, { Scale = scale })
	end
	local hudGui = HUD.gui()
	if hudGui then
		local hudScale = hudGui:FindFirstChildOfClass("UIScale")
		if not hudScale then
			hudScale = Util.create("UIScale", { Parent = hudGui })
		end
		hudScale.Scale = scale
	end
end

local blur = nil
local function applyBlur()
	local enabled = Store.get("files.interface.blur", false)
	local lighting = game:GetService("Lighting")
	if enabled and not blur then
		blur = Util.create("BlurEffect", { Size = 0, Parent = lighting })
		Util.tween(blur, 0.3, { Size = 14 })
	elseif not enabled and blur then
		local target = blur
		blur = nil
		Util.tween(target, 0.25, { Size = 0 })
		task.delay(0.3, function()
			target:Destroy()
		end)
	end
end

applyTheme(Store.get("files.interface.theme", "Violet"), false)
applyScale()
applyBlur()

Store.AnyChanged:Connect(function(path)
	if path == "files.interface.scale" then
		applyScale()
	elseif path == "files.interface.blur" then
		applyBlur()
	elseif path == "files.interface.theme" then
		local id = themeByLabel[Store.get(path)]
		if id then
			Theme.apply(id)
		end
	elseif string.match(path, "^visuals%.hud%.") or string.match(path, "^visuals%.trackers%.") then
		HUD.refresh()
	end
end)

Theme.onChanged(function(id)
	local palette = Theme.palettes[id]
	if palette and Store.get("files.interface.theme") ~= palette.label then
		Store.set("files.interface.theme", palette.label)
	end
end)

local input = game:GetService("UserInputService")
local menuKey = Store.get("files.interface.menu_key", "RightShift")
input.InputBegan:Connect(function(inputObject, processed)
	if processed then
		return
	end
	if inputObject.KeyCode.Name == menuKey then
		Window.toggleOpen()
	end
end)
Store.on("files.interface.menu_key", function(value)
	menuKey = value or "RightShift"
end)

Registry.actions = {
	["files.config.save"] = function()
		local ok = Config.save("autoload", Store.snapshot())
		Notify.push({ title = ok and "Config saved" or "Save failed", icon = "save" })
	end,
	["files.config.load"] = function()
		local data = Config.load("autoload")
		if not data then
			Notify.push({ title = "No config found", icon = "info" })
			return
		end
		Store.setRaw(data)
		Store.loadDefaults(Registry.defaults())
		Theme.apply(themeByLabel[Store.get("files.interface.theme", "Violet")] or "violet")
		Window.build()
		Notify.push({ title = "Config loaded", icon = "upload" })
	end,
	["files.config.delete"] = function()
		Config.delete("autoload")
		Notify.push({ title = "Config deleted", icon = "trash-2" })
	end,
	["files.interface.menu_key"] = function() end,
	["files.about.copy"] = function()
		local text = string.format('loadstring(game:HttpGet("%s"))()', join(RAW, "src", "main.lua"))
		if setclipboard then
			setclipboard(text)
			Notify.push({ title = "Loadstring copied", icon = "terminal" })
		else
			Notify.push({ title = "Clipboard unavailable", icon = "info" })
		end
	end,
	["files.about.reload"] = function()
		if getgenv and getgenv().ybassft then
			getgenv().ybassft.unload()
		end
		game:HttpGet(join(RAW, "src", "main.lua"))
	end,
	["files.about.unload"] = function()
		if getgenv and getgenv().ybassft then
			getgenv().ybassft.unload()
		end
	end,
	["files.keybinds.list"] = function()
		local rows = {}
		for _, tab in ipairs(Registry.tabs) do
			for _, spec in ipairs(tab.cards) do
				for _, field in ipairs(spec.fields or {}) do
					if field.type == "keybind" then
						local value = Store.get(spec.path .. "." .. field.id)
						if value then
							table.insert(rows, string.format("%s — %s", field.label or field.id, value))
						end
					end
				end
			end
		end
		Notify.push({
			title = "Keybinds",
			body = #rows > 0 and table.concat(rows, "\n") or "nothing bound yet",
			icon = "keyboard",
			duration = 6,
		})
	end,
	["files.keybinds.clear"] = function()
		for _, tab in ipairs(Registry.tabs) do
			for _, spec in ipairs(tab.cards) do
				for _, field in ipairs(spec.fields or {}) do
					if field.type == "keybind" then
						Store.set(spec.path .. "." .. field.id, nil)
					end
				end
			end
		end
		Window.build()
		Notify.push({ title = "Keybinds cleared", icon = "trash-2" })
	end,
}

local function unload()
	pcall(function()
		if blur then
			blur:Destroy()
		end
	end)
	screen:Destroy()
	if getgenv then
		getgenv().ybassft = nil
	end
end

if getgenv then
	getgenv().ybassft = { unload = unload, store = Store }
end

Notify.push({ title = "ybassft loaded", body = "RightShift to toggle · GUI stage", icon = "diamond", duration = 4 })
