return function(ctx)
	local Util = ctx.require("core.util")
	local Theme = ctx.require("ui.theme")
	local Components = ctx.require("ui.components")

	local HUD = {}
	local store = nil
	local gui = nil
	local watermark = nil
	local arrayFrame = nil
	local rows = {}
	local order = 0
	local statuses = {}
	local fpsLabel = nil
	local stats = { fps = 60, ping = 0 }

	local function text(parent, props)
		local cfg = {
			BackgroundTransparency = 1,
			Font = Util.Fonts.medium,
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			Text = "",
			Size = UDim2.new(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			Parent = parent,
		}
		local role = "text"
		for key, value in pairs(props or {}) do
			if key == "__role" then
				role = value
			else
				cfg[key] = value
			end
		end
		local label = Util.create("TextLabel", cfg)
		if not cfg.TextColor3 then
			Theme.bind(label, "TextColor3", role)
		end
		return label
	end

	local function worldPing()
		local ok, value = pcall(function()
			return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
		end)
		return ok and math.floor(value) or 0
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
			BackgroundTransparency = 0.15,
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
			PaddingRight = UDim.new(0, 9),
			Parent = watermark,
		})
		local wmList = Util.hlist({ Padding = UDim.new(0, 5), Parent = watermark })
		local brand = Components.icon(watermark, "diamond", 12, "accent")
		brand.LayoutOrder = 1
		local brandText = text(watermark, { Text = "ybassft", TextSize = 11, Font = Util.Fonts.bold, LayoutOrder = 2 })
		Theme.bind(brandText, "TextColor3", "accent")
		fpsLabel = text(watermark, { Text = "60 fps", TextSize = 10, LayoutOrder = 3, __role = "muted" })

		arrayFrame = Util.create("Frame", {
			Name = "ArrayList",
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -14, 0, 14),
			Size = UDim2.fromOffset(180, 10),
			AutomaticSize = Enum.AutomaticSize.Y,
			ZIndex = 11,
			Parent = gui,
		})
		Util.create("UIListLayout", {
			Padding = UDim.new(0, 3),
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			Parent = arrayFrame,
		})

		HUD.refresh()

		task.spawn(function()
			while gui.Parent do
				local dt = task.wait(0.5)
				stats.fps = math.floor(1 / math.max(dt, 0.001))
				stats.ping = worldPing()
				if fpsLabel and fpsLabel.Parent then
					local parts = { stats.fps .. " fps" }
					if store.get("visuals.hud.ping", true) then
						table.insert(parts, stats.ping .. " ms")
					end
					fpsLabel.Text = table.concat(parts, "  ")
				end
			end
		end)
	end

	local function applyScale()
		local scale = (store and store.get("settings.scale", 1)) or 1
		if gui then
			local uiScale = gui:FindFirstChildOfClass("UIScale")
			if not uiScale then
				uiScale = Util.create("UIScale", { Parent = gui })
			end
			uiScale.Scale = scale
		end
	end

	function HUD.setStatus(key, value)
		statuses[key] = value
		local row = rows[key]
		if value == nil or value == "" then
			if row then
				row.frame.Visible = false
			end
			return
		end
		if not row then
			row = HUD.addRow(key, value, { transparent = true })
		end
		row.label.Text = value
		row.frame.Visible = true
	end

	function HUD.addRow(id, label, opts)
		if rows[id] then
			return rows[id]
		end
		order = order + 1
		local frame = Util.create("Frame", {
			BackgroundColor3 = Theme.color("panel"),
			BackgroundTransparency = (opts and opts.transparent) and 1 or 0.25,
			Size = UDim2.new(1, 0, 0, 18),
			LayoutOrder = order,
			ClipsDescendants = true,
			ZIndex = 11,
			Parent = arrayFrame,
		})
		Util.corner(5)
		local bar = Util.create("Frame", {
			Size = UDim2.fromOffset(2, 18),
			BackgroundColor3 = Theme.color("accent"),
			BorderSizePixel = 0,
			ZIndex = 12,
			Parent = frame,
		})
		Theme.bind(bar, "BackgroundColor3", "accent")
		local labelFrame = text(frame, {
			Text = label,
			TextSize = 10,
			Position = UDim2.fromOffset(8, 0),
			Size = UDim2.new(1, -8, 1, 0),
			TextXAlignment = Enum.TextXAlignment.Right,
			ZIndex = 12,
		})
		labelFrame.AutomaticSize = Enum.AutomaticSize.None
		labelFrame.Size = UDim2.new(1, -14, 1, 0)
		rows[id] = { frame = frame, label = labelFrame, bar = bar }
		return rows[id]
	end

	function HUD.removeRow(id)
		local row = rows[id]
		if row then
			row.frame:Destroy()
			rows[id] = nil
		end
	end

	function HUD.refresh()
		if not gui then
			return
		end
		applyScale()
		local hudOn = store.get("visuals.hud.enabled", true)
		watermark.Visible = hudOn and store.get("visuals.hud.watermark", true)
		arrayFrame.Visible = hudOn and store.get("visuals.hud.arraylist", true)
		local showRage = store.get("visuals.hud.rage", true)
		local showBarrage = store.get("visuals.hud.barrage", true)
		local showFarm = store.get("visuals.hud.farm", false)
		HUD.setStatus("rage", showRage and (statuses.rage or "rage  0%") or nil)
		HUD.setStatus("barrage", showBarrage and (statuses.barrage or "barrage  idle") or nil)
		HUD.setStatus("farm", showFarm and (statuses.farm or "farm  off") or nil)
	end

	function HUD.registrySync(entries)
		local wanted = {}
		for _, entry in ipairs(entries) do
			wanted[entry.id] = true
			HUD.addRow(entry.id, entry.title)
		end
		for statusId in pairs(statuses) do
			wanted[statusId] = true
		end
		for id in pairs(rows) do
			if not wanted[id] then
				HUD.removeRow(id)
			end
		end
		HUD.refresh()
	end

	function HUD.gui()
		return gui
	end

	return HUD
end
