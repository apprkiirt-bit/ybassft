return function(ctx)
	local Util = ctx.require("core.util")
	local Theme = ctx.require("ui.theme")
	local Components = ctx.require("ui.components")

	local RunService = game:GetService("RunService")

	local HUD = {}
	local store = nil
	local gui = nil
	local watermark = nil
	local anchorLine = nil
	local statuses = {}
	local elements = {}
	local shown = {}
	local stats = { fps = 60, ping = 0 }

	function HUD.setStatus(key, value)
		statuses[key] = value
		local element = elements[key]
		if not element then
			return
		end
		element.text.Text = value or ""
		local on = shown[key] == true and value ~= nil and value ~= ""
		element.frame.Visible = on
		if element.divider.Parent then
			element.divider.Visible = on
		end
	end

	function HUD.addElement(key, iconName, initial)
		if elements[key] then
			return elements[key]
		end
		local slot = #elements
		local frame = Util.create("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(0, 14),
			AutomaticSize = Enum.AutomaticSize.X,
			LayoutOrder = 10 + slot * 2,
			Parent = anchorLine,
		})
		local layout = Util.hlist({ Padding = UDim.new(0, 5), Parent = frame })
		local icon = Components.icon(frame, iconName, 13, "icon", 1)
		local label = Util.create("TextLabel", {
			BackgroundTransparency = 1,
			Text = initial or "",
			Font = Util.Fonts.medium,
			TextSize = 10,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = Theme.color("muted"),
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 1, 0),
			LayoutOrder = 2,
			Parent = frame,
		})
		Theme.bind(label, "TextColor3", "muted")
		local divider = Util.create("Frame", {
			BackgroundColor3 = Theme.color("border"),
			Size = UDim2.fromOffset(1, 12),
			LayoutOrder = 9 + slot * 2,
			Parent = anchorLine,
		})
		Theme.bind(divider, "BackgroundColor3", "border")
		elements[key] = { frame = frame, text = label, icon = icon, divider = divider }
		return elements[key]
	end

	local function visibleKeys()
		local hudOn = store.get("visuals.hud.enabled", true)
		if not hudOn then
			return {}
		end
		local order = {}
		if store.get("visuals.hud.player", true) then
			table.insert(order, "player")
		end
		if store.get("visuals.hud.fps", true) then
			table.insert(order, "fps")
		end
		if store.get("visuals.hud.ping", true) then
			table.insert(order, "ping")
		end
		if store.get("visuals.hud.rage", true) then
			table.insert(order, "rage")
		end
		if store.get("visuals.hud.barrage", true) then
			table.insert(order, "barrage")
		end
		if store.get("visuals.hud.farm", false) then
			table.insert(order, "farm")
		end
		if store.get("visuals.hud.target", false) then
			table.insert(order, "target")
		end
		if store.get("visuals.hud.coords", false) then
			table.insert(order, "coords")
		end
		return order
	end

	function HUD.refresh()
		if not gui or not watermark then
			return
		end
		local keys = visibleKeys()
		shown = {}
		for _, key in ipairs(keys) do
			shown[key] = true
		end
		local name = elements.name
		if name then
			name.frame.Visible = shown.player == true
			name.divider.Visible = false
		end
		for key, element in pairs(elements) do
			if key ~= "name" then
				local on = shown[key] == true
				element.frame.Visible = on
				element.divider.Visible = on
			end
		end
		watermark.Visible = #keys > 0
	end

	function HUD.init(parent, storeRef)
		store = storeRef
		gui = Util.create("Frame", {
			Name = "HUD",
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ZIndex = 10,
			Parent = parent,
		})

		watermark = Util.create("Frame", {
			Name = "Watermark",
			BackgroundColor3 = Theme.color("panel"),
			BackgroundTransparency = 0.12,
			Position = UDim2.fromOffset(14, 14),
			Size = UDim2.fromOffset(0, 24),
			AutomaticSize = Enum.AutomaticSize.X,
			ZIndex = 11,
			Parent = gui,
		})
		Util.corner(8)
		Util.stroke(Theme.color("border"), 1, 0.2).Parent = watermark
		Util.create("UIPadding", {
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 8),
			Parent = watermark,
		})
		anchorLine = Util.create("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			Parent = watermark,
		})
		Util.hlist({ Padding = UDim.new(0, 7), Parent = anchorLine })

		local nameChip = Util.create("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(0, 14),
			AutomaticSize = Enum.AutomaticSize.X,
			LayoutOrder = 1,
			Parent = anchorLine,
		})
		Util.hlist({ Padding = UDim.new(0, 6), Parent = nameChip })
		Components.icon(nameChip, "diamond", 13, "accent", 1)
		local nameText = Util.create("TextLabel", {
			BackgroundTransparency = 1,
			Text = game:GetService("Players").LocalPlayer.Name,
			Font = Util.Fonts.bold,
			TextSize = 11,
			TextColor3 = Theme.color("icon"),
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 1, 0),
			LayoutOrder = 2,
			Parent = nameChip,
		})
		Theme.bind(nameText, "TextColor3", "icon")
		elements.name = {
			frame = nameChip,
			text = nameText,
			divider = Util.create("Frame", { Size = UDim2.new(), Visible = false, Parent = watermark }),
		}

		HUD.addElement("fps", "activity", "fps 60")
		HUD.addElement("ping", "wifi", "42 ms")
		HUD.addElement("rage", "flame", "rage 0%")
		HUD.addElement("barrage", "timer", "barrage idle")
		HUD.addElement("farm", "coins", "farm 0/h")
		HUD.addElement("target", "crosshair", "no target")
		HUD.addElement("coords", "map-pin", "0, 0, 0")

		HUD.refresh()

		task.spawn(function()
			local frames = 0
			local clock = os.clock()
			local connection = RunService.RenderStepped:Connect(function()
				frames += 1
			end)
			while gui.Parent do
				task.wait(0.5)
				local now = os.clock()
				local span = math.max(now - clock, 0.001)
				stats.fps = math.floor(frames / span + 0.5)
				frames = 0
				clock = now
				local pingOk, pingValue = pcall(function()
					return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
				end)
				stats.ping = pingOk and math.floor(pingValue) or 0
				HUD.setStatus("fps", "fps " .. stats.fps)
				HUD.setStatus("ping", stats.ping .. " ms")
			end
			connection:Disconnect()
		end)
	end

	function HUD.value(key)
		return statuses[key]
	end

	function HUD.gui()
		return gui
	end

	return HUD
end
