return function(ctx)
	local Util = ctx.require("core.util")
	local Theme = ctx.require("ui.theme")
	local Components = ctx.require("ui.components")

	local Notify = {}
	local holder = nil
	local active = {}

	function Notify.init(parent)
		holder = Util.create("Frame", {
			Name = "Notifications",
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.new(1, -14, 1, -14),
			Size = UDim2.fromOffset(220, 300),
			BackgroundTransparency = 1,
			ZIndex = 400,
			Parent = parent,
		})
		Util.create("UIListLayout", {
			Padding = UDim.new(0, 6),
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			Parent = holder,
		})
	end

	local counter = 0

	function Notify.push(opts)
		if not holder then
			return
		end
		counter = counter + 1
		local data = type(opts) == "table" and opts or { title = tostring(opts) }
		local card = Util.create("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = Theme.color("panel"),
			BackgroundTransparency = 1,
			LayoutOrder = counter,
			ClipsDescendants = true,
			ZIndex = 401,
			Parent = holder,
		})
		Util.corner(10)
		local stroke = Util.stroke(Theme.color("border"), 1, 1)
		stroke.Parent = card
		Util.create("UIPadding", {
			PaddingTop = UDim.new(0, 9),
			PaddingBottom = UDim.new(0, 9),
			PaddingLeft = UDim.new(0, 9),
			PaddingRight = UDim.new(0, 9),
			Parent = card,
		})
		Util.list({ Padding = UDim.new(0, 2), Parent = card })

		local accent = Util.create("Frame", {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, -9, 0.5, 0),
			Size = UDim2.fromOffset(2, 26),
			BackgroundColor3 = Theme.color("accent"),
			BorderSizePixel = 0,
			ZIndex = 403,
			Parent = card,
		})
		Util.corner(2)

		local head = Util.create("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 13),
			LayoutOrder = 1,
			ZIndex = 402,
			Parent = card,
		})
		Components.icon(head, data.icon or "bell", 13, "accent")
		local title = Components.text(head, {
			Text = data.title or "Notification",
			TextSize = 11,
			Font = Util.Fonts.medium,
			Position = UDim2.fromOffset(17, 0),
			Size = UDim2.new(1, -17, 1, 0),
			ZIndex = 402,
		})
		title.TextTruncate = Enum.TextTruncate.AtEnd

		if data.body then
			local body = Components.text(card, {
				Text = data.body,
				TextSize = 10,
				TextWrapped = true,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0),
				LayoutOrder = 2,
				ZIndex = 402,
				__role = "muted",
			})
			body.TextTransparency = 0.1
		end

		table.insert(active, card)
		task.spawn(function()
			Util.tween(card, 0.2, { BackgroundTransparency = 0 })
			Util.tween(stroke, 0.2, { Transparency = 0 })
			Util.tween(accent, 0.2, { Size = UDim2.fromOffset(2, 26) })
			task.wait(data.duration or 3.2)
			Util.tween(card, 0.22, { BackgroundTransparency = 1 })
			Util.tween(stroke, 0.22, { Transparency = 1 })
			task.wait(0.25)
			for index = #active, 1, -1 do
				if active[index] == card then
					table.remove(active, index)
				end
			end
			card:Destroy()
		end)

		return card
	end

	return Notify
end
