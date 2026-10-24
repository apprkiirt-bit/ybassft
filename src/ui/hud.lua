return function(ctx)
	local Util = ctx.require("core.util")
	local Theme = ctx.require("ui.theme")
	local Components = ctx.require("ui.components")

	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")

	local HUD = {}
	local store = nil
	local registry = nil
	local gui = nil
	local watermark = nil
	local nameChip = nil
	local statusBox = nil
	local bindsFrame = nil
	local bindsHeader = nil
	local bindsCount = nil
	local bindsList = nil
	local elements = {}
	local order = { "fps", "ping", "rage", "barrage", "farm", "target", "coords" }
	local statuses = {}
	local shown = {}
	local stats = { fps = 60, ping = 0 }
	local rebuildQueued = false

	local categoryIcon = {
		combat = "swords",
		movement = "footprints",
		farm = "coins",
		visuals = "image",
		protection = "shield",
		files = "folder",
	}

	local function white()
		return Theme.color("icon")
	end

	local function box(parent, height, order2)
		local frame = Util.create("Frame", {
			BackgroundColor3 = Theme.color("panel"),
			BackgroundTransparency = 0.06,
			Size = UDim2.fromOffset(0, height or 26),
			AutomaticSize = Enum.AutomaticSize.X,
			LayoutOrder = order2 or 1,
			Parent = parent,
		})
		Util.corner(4)
		Util.stroke(Theme.color("border"), 1, 0.15).Parent = frame
		Theme.bind(frame, "BackgroundColor3", "panel")
		return frame
	end

	local function chip(parent, iconName, text, layoutOrder)
		local frame = Util.create("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(0, 14),
			AutomaticSize = Enum.AutomaticSize.X,
			LayoutOrder = layoutOrder,
			Parent = parent,
		})
		Util.hlist({ Padding = UDim.new(0, 6), Parent = frame })
		Components.icon(frame, iconName, 15, "icon", 1)
		local label = Util.create("TextLabel", {
			BackgroundTransparency = 1,
			Text = text,
			Font = Util.Fonts.medium,
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = white(),
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 1, 0),
			LayoutOrder = 2,
			Parent = frame,
		})
		Theme.bind(label, "TextColor3", "icon")
		return { frame = frame, text = label }
	end

	local function divider(parent)
		local frame = Util.create("Frame", {
			BackgroundColor3 = Theme.color("border"),
			Size = UDim2.fromOffset(1, 12),
			LayoutOrder = 5,
			Parent = parent,
		})
		Theme.bind(frame, "BackgroundColor3", "border")
		return frame
	end

	function HUD.setStatus(key, value)
		statuses[key] = value
		local element = elements[key]
		if not element then
			return
		end
		element.text.Text = value or ""
		HUD.refresh()
	end

	function HUD.addElement(key, iconName, initial)
		if elements[key] then
			return elements[key]
		end
		local holder = Util.create("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(0, 14),
			AutomaticSize = Enum.AutomaticSize.X,
			LayoutOrder = 20 + #order,
			Parent = statusBox,
		})
		local layout = Util.hlist({ Padding = UDim.new(0, 6), Parent = holder })
		local icon = Components.icon(holder, iconName, 15, "icon", 1)
		local label = Util.create("TextLabel", {
			BackgroundTransparency = 1,
			Text = initial or "",
			Font = Util.Fonts.medium,
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = white(),
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 1, 0),
			LayoutOrder = 2,
			Parent = holder,
		})
		Theme.bind(label, "TextColor3", "icon")
		local sep = Util.create("Frame", {
			BackgroundColor3 = Theme.color("border"),
			Size = UDim2.fromOffset(1, 12),
			LayoutOrder = 19 + #order,
			Parent = statusBox,
		})
		Theme.bind(sep, "BackgroundColor3", "border")
		elements[key] = { frame = holder, text = label, icon = icon, divider = sep, layout = layout }
		table.insert(order, key)
		return elements[key]
	end

	local function enabled(key)
		return store.get("visuals.hud." .. key, false)
	end

	function HUD.refresh()
		if not gui or not watermark then
			return
		end
		local hudOn = store.get("visuals.hud.enabled", true)
		watermark.Visible = hudOn
		if bindsFrame then
			bindsFrame.Visible = hudOn
		end
		if not hudOn then
			return
		end

		shown = {}
		nameChip.Visible = store.get("visuals.hud.player", true)
		local visibleCount = 0
		local any = false
		for _, key in ipairs(order) do
			local element = elements[key]
			if element then
				local on = enabled(key) and statuses[key] ~= nil and statuses[key] ~= ""
				shown[key] = on
				element.frame.Visible = on
				element.divider.Visible = on and any
				if on then
					any = true
					visibleCount = visibleCount + 1
				end
			end
		end
		statusBox.Visible = visibleCount > 0
	end

	local function queueBinds()
		if rebuildQueued then
			return
		end
		rebuildQueued = true
		task.defer(function()
			rebuildQueued = false
			HUD.refreshBinds()
		end)
	end

	function HUD.refreshBinds()
		if not bindsList or not registry then
			return
		end
		for _, child in ipairs(bindsList:GetChildren()) do
			if child:IsA("Frame") then
				child:Destroy()
			end
		end
		local rows = 0
		for _, tab in ipairs(registry.tabs) do
			for _, spec in ipairs(tab.cards) do
				if spec.toggle and store.get(spec.path .. ".enabled", false) then
					local keyLabel = "on"
					for _, field in ipairs(spec.fields or {}) do
						if field.type == "keybind" then
							local value = store.get(spec.path .. "." .. field.id)
							if value then
								keyLabel = tostring(value)
							end
						end
					end
					rows = rows + 1
					local line = Util.create("Frame", {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 20),
						LayoutOrder = rows,
						Parent = bindsList,
					})
					Util.hlist({ Padding = UDim.new(0, 2), Parent = line })

					local labelBox = Util.create("Frame", {
						BackgroundColor3 = Theme.color("panel"),
						BackgroundTransparency = 0.06,
						Size = UDim2.new(1, -34, 1, 0),
						LayoutOrder = 1,
						Parent = line,
					})
					Util.corner(3)
					Util.stroke(Theme.color("border"), 1, 0.1).Parent = labelBox
					Theme.bind(labelBox, "BackgroundColor3", "panel")
					local labelLayout = Util.hlist({ Padding = UDim.new(0, 6), Parent = labelBox })
					Util.create("UIPadding", { PaddingLeft = UDim.new(0, 7), Parent = labelBox })
					Components.icon(labelBox, categoryIcon[tab.id] or "box", 12, "icon", 1)
					local label = Util.create("TextLabel", {
						BackgroundTransparency = 1,
						Text = spec.title,
						Font = Util.Fonts.medium,
						TextSize = 10,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextColor3 = white(),
						Size = UDim2.new(1, -20, 1, 0),
						LayoutOrder = 2,
						Parent = labelBox,
					})
					label.TextTruncate = Enum.TextTruncate.AtEnd
					Theme.bind(label, "TextColor3", "icon")

					local keyBox = Util.create("Frame", {
						BackgroundColor3 = Theme.color("panel2"),
						Size = UDim2.fromOffset(32, 20),
						LayoutOrder = 2,
						Parent = line,
					})
					Util.corner(3)
					Util.stroke(Theme.color("border"), 1, 0.1).Parent = keyBox
					Theme.bind(keyBox, "BackgroundColor3", "panel2")
					local keyText = Util.create("TextLabel", {
						BackgroundTransparency = 1,
						Text = keyLabel,
						Font = Util.Fonts.medium,
						TextSize = 9,
						TextColor3 = Theme.color("muted"),
						Size = UDim2.fromScale(1, 1),
						Parent = keyBox,
					})
					Theme.bind(keyText, "TextColor3", "muted")
				end
			end
		end
		bindsCount.Text = "Keybinds " .. rows
		bindsList.Visible = rows > 0
	end

	function HUD.init(parent, storeRef, registryRef)
		store = storeRef
		registry = registryRef
		gui = Util.create("Frame", {
			Name = "HUD",
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ZIndex = 10,
			Parent = parent,
		})

		watermark = Util.create("Frame", {
			Name = "Watermark",
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(14, 14),
			Size = UDim2.fromOffset(0, 26),
			AutomaticSize = Enum.AutomaticSize.X,
			ZIndex = 11,
			Parent = gui,
		})
		Util.hlist({ Padding = UDim.new(0, 2), Parent = watermark })

		local nameBox = box(watermark, 26, 1)
		Util.hlist({ Padding = UDim.new(0, 7), Parent = nameBox })
		Util.create("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = nameBox })
		Components.icon(nameBox, "diamond", 16, "accent", 1)
		local nameLabel = Util.create("TextLabel", {
			BackgroundTransparency = 1,
			Text = Players.LocalPlayer.Name,
			Font = Util.Fonts.bold,
			TextSize = 11,
			TextColor3 = white(),
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 1, 0),
			LayoutOrder = 2,
			Parent = nameBox,
		})
		Theme.bind(nameLabel, "TextColor3", "icon")
		nameChip = nameBox

		statusBox = box(watermark, 26, 2)
		Util.hlist({ Padding = UDim.new(0, 7), Parent = statusBox })
		Util.create("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = statusBox })

		local fps = chip(statusBox, "activity", "60 fps", 1)
		local ping = chip(statusBox, "wifi", "0 ms", 3)
		local rage = chip(statusBox, "flame", "0%", 4)
		local barrage = chip(statusBox, "timer", "idle", 5)
		elements.fps = fps
		elements.ping = ping
		elements.rage = rage
		elements.barrage = barrage
		elements.fps.divider = Util.create("Frame", { BackgroundTransparency = 1, Size = UDim2.new(), Visible = false, Parent = statusBox })
		elements.ping.divider = divider(statusBox)
		elements.rage.divider = divider(statusBox)
		elements.barrage.divider = divider(statusBox)
		statuses.fps = "60 fps"
		statuses.ping = "0 ms"
		statuses.rage = "0%"
		statuses.barrage = "idle"

		bindsFrame = Util.create("Frame", {
			Name = "Keybinds",
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -14, 0, 14),
			Size = UDim2.fromOffset(158, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			ZIndex = 11,
			Parent = gui,
		})
		Util.list({ Padding = UDim.new(0, 2), Parent = bindsFrame })

		local header = box(bindsFrame, 22, 1)
		header.Size = UDim2.new(1, 0, 0, 22)
		header.AutomaticSize = Enum.AutomaticSize.None
		Util.hlist({ Padding = UDim.new(0, 4), Parent = header })
		Util.create("UIPadding", { PaddingLeft = UDim.new(0, 7), PaddingRight = UDim.new(0, 7), Parent = header })
		bindsCount = Util.create("TextLabel", {
			BackgroundTransparency = 1,
			Text = "Keybinds 0",
			Font = Util.Fonts.medium,
			TextSize = 10,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = Theme.color("muted"),
			Size = UDim2.new(1, -16, 1, 0),
			LayoutOrder = 1,
			Parent = header,
		})
		Theme.bind(bindsCount, "TextColor3", "muted")
		Components.icon(header, "keyboard", 13, "icon", 2)
		bindsHeader = header

		bindsList = Util.create("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 2,
			Parent = bindsFrame,
		})
		Util.list({ Padding = UDim.new(0, 2), Parent = bindsList })

		HUD.refresh()
		HUD.refreshBinds()

		task.spawn(function()
			local frames = 0
			local clock = os.clock()
			local connection = RunService.RenderStepped:Connect(function()
				frames = frames + 1
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
				HUD.setStatus("fps", stats.fps .. " fps")
				HUD.setStatus("ping", stats.ping .. " ms")
			end
			connection:Disconnect()
		end)
	end

	HUD.onStoreChanged = queueBinds

	function HUD.value(key)
		return statuses[key]
	end

	function HUD.gui()
		return gui
	end

	return HUD
end
