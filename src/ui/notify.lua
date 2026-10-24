return function(ctx)
	local Util = ctx.require("core.util")
	local Theme = ctx.require("ui.theme")
	local Components = ctx.require("ui.components")

	local Notify = {}
	local holder = nil
	local counter = 0

	function Notify.init(parent)
		holder = Util.create("Frame", {
			Name = "Notifications",
			AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.new(0.5, 0, 1, -16),
			Size = UDim2.fromOffset(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			ZIndex = 400,
			Parent = parent,
		})
		Util.list({
			Padding = UDim.new(0, 3),
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			Parent = holder,
		})
	end

	function Notify.push(opts)
		if not holder then
			return
		end
		counter = counter + 1
		local data = type(opts) == "table" and opts or { title = tostring(opts) }

		local pill = Util.create("Frame", {
			BackgroundColor3 = Theme.color("panel"),
			BackgroundTransparency = 0,
			Size = UDim2.fromOffset(0, 22),
			AutomaticSize = Enum.AutomaticSize.X,
			LayoutOrder = counter,
			ZIndex = 401,
			Parent = holder,
		})
		Util.corner(4)
		local stroke = Util.stroke(Theme.color("border"), 1, 0)
		stroke.Parent = pill
		Theme.bind(pill, "BackgroundColor3", "panel")
		Theme.bind(stroke, "Color", "border")
		Util.create("UIPadding", {
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 8),
			Parent = pill,
		})
		Util.hlist({ Padding = UDim.new(0, 7), Parent = pill })

		if data.toggle ~= nil then
			local track = Util.create("Frame", {
				BackgroundColor3 = Theme.color(data.toggle and "accent" or "track"),
				Size = UDim2.fromOffset(15, 8),
				LayoutOrder = 1,
				Parent = pill,
			})
			Util.corner(3)
			Util.create("Frame", {
				BackgroundColor3 = Theme.color(data.toggle and "bg" or "muted"),
				Size = UDim2.fromOffset(6, 6),
				Position = UDim2.fromOffset(data.toggle and 8 or 1, 1),
				Parent = track,
			})
		else
			Components.icon(pill, data.icon or "bell", 13, "icon", 1)
		end

		local label = Util.create("TextLabel", {
			BackgroundTransparency = 1,
			Text = data.title or "Notification",
			Font = Util.Fonts.medium,
			TextSize = 10,
			TextColor3 = Theme.color("icon"),
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 1, 0),
			LayoutOrder = 2,
			Parent = pill,
		})
		Theme.bind(label, "TextColor3", "icon")

		local scale = Util.create("UIScale", { Scale = 0.85, Parent = pill })
		pill.BackgroundTransparency = 1
		task.spawn(function()
			Util.tween(pill, 0.18, { BackgroundTransparency = 0 })
			Util.tween(scale, 0.22, { Scale = 1 })
			task.wait(data.duration or 2.2)
			Util.tween(pill, 0.2, { BackgroundTransparency = 1 })
			Util.tween(stroke, 0.2, { Transparency = 1 })
			Util.tween(label, 0.2, { TextTransparency = 1 })
			task.wait(0.22)
			pill:Destroy()
		end)

		local total = 0
		for _, child in ipairs(holder:GetChildren()) do
			if child:IsA("Frame") then
				total = total + 1
			end
		end
		if total > 4 then
			local oldest = nil
			for _, child in ipairs(holder:GetChildren()) do
				if child:IsA("Frame") and (oldest == nil or child.LayoutOrder < oldest.LayoutOrder) then
					oldest = child
				end
			end
			if oldest then
				oldest:Destroy()
			end
		end

		return pill
	end

	return Notify
end
