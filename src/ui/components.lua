return function(ctx)
	local Util = ctx.require("core.util")
	local Theme = ctx.require("ui.theme")
	local Icons = ctx.require("core.icons")

	local Components = {}
	local api = nil

	function Components.init(context)
		api = context
	end

	function Components.icon(parent, name, size, role, order)
		local image = Util.create("ImageLabel", {
			BackgroundTransparency = 1,
			Image = Icons.get(name),
			ImageTransparency = Icons.get(name) == "" and 1 or 0,
			Size = UDim2.fromOffset(size, size),
			LayoutOrder = order or 0,
			Parent = parent,
		})
		image.Name = "Icon"
		Theme.bind(image, "ImageColor3", role or "icon")
		return image
	end

	function Components.text(parent, props)
		local cfg = {
			BackgroundTransparency = 1,
			Font = Util.Fonts.body,
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			Text = "",
			Size = UDim2.new(1, 0, 0, 14),
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

	function Components.pill(parent, text)
		local holder = Util.create("Frame", {
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.fromOffset(0, 15),
			BackgroundColor3 = Theme.color("panel3"),
			BackgroundTransparency = 0.15,
			LayoutOrder = 90,
			Parent = parent,
		})
		Util.corner(5)
		Theme.bind(holder, "BackgroundColor3", "panel3")
		local stroke = Util.stroke(Theme.color("border"), 1, 0.25)
		stroke.Parent = holder
		Theme.bind(stroke, "Color", "border")
		Util.create("UIPadding", {
			PaddingLeft = UDim.new(0, 5),
			PaddingRight = UDim.new(0, 5),
			Parent = holder,
		})
		local label = Components.text(holder, {
			Text = text or "None",
			TextSize = 9,
			Font = Util.Fonts.medium,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 1, 0),
			TextXAlignment = Enum.TextXAlignment.Center,
			__role = "muted",
		})
		return holder, label
	end

	function Components.toggle(parent, value, onChange)
		local button = Util.create("TextButton", {
			Text = "",
			AutoButtonColor = false,
			Size = UDim2.fromOffset(30, 16),
			BackgroundColor3 = value and Theme.color("accent") or Theme.color("track"),
			LayoutOrder = 100,
			Parent = parent,
		})
		Util.corner(8)
		Theme.bind(button, "BackgroundColor3", value and "accent" or "track")

		local knob = Util.create("Frame", {
			Size = UDim2.fromOffset(12, 12),
			Position = UDim2.fromOffset(value and 16 or 2, 2),
			BackgroundColor3 = Color3.fromRGB(245, 246, 250),
			Parent = button,
		})
		Util.corner(6)

		local state = value and true or false
		local function render(animated)
			if not button.Parent then
				return
			end
			local target = state and 16 or 2
			local color = state and Theme.color("accent") or Theme.color("track")
			if animated ~= false then
				Util.tween(knob, 0.18, { Position = UDim2.fromOffset(target, 2) }, Enum.EasingStyle.Quint)
				Util.tween(button, 0.18, { BackgroundColor3 = color })
			else
				knob.Position = UDim2.fromOffset(target, 2)
				button.BackgroundColor3 = color
			end
		end

		button.MouseButton1Click:Connect(function()
			state = not state
			render(true)
			if onChange then
				onChange(state)
			end
		end)

		Theme.onChanged(function()
			render(true)
		end)

		return {
			frame = button,
			set = function(next_)
				state = next_ and true or false
				render(true)
			end,
			get = function()
				return state
			end,
		}
	end

	local function fieldHolder(parent, order)
		local holder = Util.create("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = order or 1,
			Parent = parent,
		})
		Util.list({ Padding = UDim.new(0, 5), Parent = holder })
		return holder
	end

	function Components.small(parent, text)
		local label = Components.text(parent, {
			Text = text,
			TextSize = 10,
			TextWrapped = true,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			__role = "muted",
		})
		return label
	end

	function Components.label(parent, text, role)
		return Components.text(parent, {
			Text = text,
			TextSize = 11,
			Font = Util.Fonts.medium,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextWrapped = true,
			Size = UDim2.new(1, 0, 0, 0),
			__role = role or "text",
		})
	end

	function Components.button(parent, opts)
		local button = Util.create("TextButton", {
			Text = "",
			AutoButtonColor = false,
			Size = UDim2.new(1, 0, 0, 24),
			BackgroundColor3 = Theme.color("panel3"),
			LayoutOrder = opts.order or 10,
			Parent = parent,
		})
		Util.corner(7)
		local stroke = Util.stroke(Theme.color("border"), 1, 0.2)
		stroke.Parent = button
		Theme.bind(button, "BackgroundColor3", "panel3")
		Theme.bind(stroke, "Color", "border")

		if opts.icon then
			local image = Components.icon(button, opts.icon, 14, "icon")
			image.Position = UDim2.fromOffset(8, 6)
		end
		local label = Components.text(button, {
			Text = opts.text or "Button",
			TextSize = 11,
			Font = Util.Fonts.medium,
			Position = UDim2.fromOffset(opts.icon and 26 or 10, 0),
			Size = UDim2.new(1, -34, 1, 0),
		})
		if opts.role == "accent" then
			Theme.bind(label, "TextColor3", "accent")
		end

		button.MouseEnter:Connect(function()
			Util.tween(button, 0.15, { BackgroundColor3 = Theme.color("accentSoft") })
		end)
		button.MouseLeave:Connect(function()
			Util.tween(button, 0.15, { BackgroundColor3 = Theme.color("panel3") })
		end)
		button.MouseButton1Click:Connect(function()
			if opts.onClick then
				opts.onClick(label)
			end
		end)
		return button, label
	end

	function Components.openMenu(anchor, options, current, onPick)
		local overlay = api.overlay
		if api.closeMenus then
			api.closeMenus()
		end
		local origin = overlay.AbsolutePosition
		local position = anchor.AbsolutePosition
		local height = #options * 22 + 8
		local menu = Util.create("Frame", {
			Position = UDim2.fromOffset(position.X - origin.X, position.Y - origin.Y + anchor.AbsoluteSize.Y + 4),
			Size = UDim2.fromOffset(anchor.AbsoluteSize.X, 0),
			BackgroundColor3 = Theme.color("panel"),
			ClipsDescendants = true,
			ZIndex = 250,
			Parent = overlay,
		})
		Util.corner(9)
		local stroke = Util.stroke(Theme.color("border"), 1)
		stroke.Parent = menu
		Util.create("UIPadding", {
			PaddingTop = UDim.new(0, 4),
			PaddingBottom = UDim.new(0, 4),
			Parent = menu,
		})
		local list = Util.list({ Padding = UDim.new(0, 1), Parent = menu })

		for index, option in ipairs(options) do
			local isCurrent = option == current
			local row = Util.create("TextButton", {
				Text = "",
				AutoButtonColor = false,
				LayoutOrder = index,
				Size = UDim2.new(1, 0, 0, 21),
				BackgroundColor3 = isCurrent and Theme.color("accentSoft") or Theme.color("panel"),
				BackgroundTransparency = isCurrent and 0 or 1,
				ZIndex = 251,
				Parent = menu,
			})
			Util.corner(6)
			local rowIcon = Components.icon(row, "chevron-down", 12, isCurrent and "accent" or "icon")
			rowIcon.Position = UDim2.fromOffset(8, 5)
			local text = Components.text(row, {
				Text = option,
				TextSize = 10,
				Font = isCurrent and Util.Fonts.medium or Util.Fonts.body,
				Position = UDim2.fromOffset(24, 0),
				Size = UDim2.new(1, -30, 1, 0),
				ZIndex = 251,
				__role = isCurrent and "accent" or "muted",
			})
			row.MouseEnter:Connect(function()
				row.BackgroundTransparency = 0
				row.BackgroundColor3 = Theme.color("accentSoft")
				text.TextColor3 = Theme.color("accent")
			end)
			row.MouseLeave:Connect(function()
				if not isCurrent then
					row.BackgroundTransparency = 1
					text.TextColor3 = Theme.color("muted")
				end
			end)
			row.MouseButton1Click:Connect(function()
				if onPick then
					onPick(option)
				end
				if api.closeMenus then
					api.closeMenus()
				end
			end)
		end

		menu.Size = UDim2.fromOffset(anchor.AbsoluteSize.X, 0)
		Util.tween(menu, 0.14, { Size = UDim2.fromOffset(anchor.AbsoluteSize.X, height) })
		api.registerMenu(menu)
		return menu
	end

	function Components.select(parent, spec)
		local holder = fieldHolder(parent, spec.order)
		if spec.label then
			Components.text(holder, {
				Text = spec.label,
				TextSize = 11,
				Font = Util.Fonts.medium,
				Size = UDim2.new(1, 0, 0, 13),
			})
		end
		local button = Util.create("TextButton", {
			Text = "",
			AutoButtonColor = false,
			Size = UDim2.new(1, 0, 0, 24),
			BackgroundColor3 = Theme.color("panel2"),
			LayoutOrder = 2,
			Parent = holder,
		})
		Util.corner(7)
		local stroke = Util.stroke(Theme.color("border"), 1, 0.15)
		stroke.Parent = button
		Theme.bind(button, "BackgroundColor3", "panel2")
		Theme.bind(stroke, "Color", "border")

		local icon = Components.icon(button, spec.icon or "list-filter", 14, "icon")
		icon.Position = UDim2.fromOffset(8, 6)
		local value = Components.text(button, {
			Text = tostring(spec.value or (spec.options and spec.options[1]) or "None"),
			TextSize = 10,
			Font = Util.Fonts.medium,
			Position = UDim2.fromOffset(26, 0),
			Size = UDim2.new(1, -44, 1, 0),
			TextTruncate = Enum.TextTruncate.AtEnd,
		})
		local chevron = Components.icon(button, "chevron-down", 12, "icon")
		chevron.AnchorPoint = Vector2.new(1, 0.5)
		chevron.Position = UDim2.new(1, -8, 0.5, 0)

		button.MouseEnter:Connect(function()
			Util.tween(stroke, 0.15, { Transparency = 0, Color = Theme.color("accent2") })
		end)
		button.MouseLeave:Connect(function()
			Util.tween(stroke, 0.15, { Transparency = 0.15, Color = Theme.color("border") })
		end)
		button.MouseButton1Click:Connect(function()
			Components.openMenu(button, spec.options, value.Text, function(picked)
				value.Text = picked
				if spec.onChange then
					spec.onChange(picked)
				end
			end)
		end)
		return holder
	end

	function Components.multi(parent, spec)
		local holder = fieldHolder(parent, spec.order)
		if spec.label then
			Components.text(holder, {
				Text = spec.label,
				TextSize = 11,
				Font = Util.Fonts.medium,
				Size = UDim2.new(1, 0, 0, 13),
			})
		end
		local button = Util.create("TextButton", {
			Text = "",
			AutoButtonColor = false,
			Size = UDim2.new(1, 0, 0, 24),
			BackgroundColor3 = Theme.color("panel2"),
			LayoutOrder = 2,
			Parent = holder,
		})
		Util.corner(7)
		local stroke = Util.stroke(Theme.color("border"), 1, 0.15)
		stroke.Parent = button
		Theme.bind(button, "BackgroundColor3", "panel2")
		Theme.bind(stroke, "Color", "border")
		local icon = Components.icon(button, spec.icon or "layers", 14, "icon")
		icon.Position = UDim2.fromOffset(8, 6)
		local label = Components.text(button, {
			Text = spec.summary or "Edit list",
			TextSize = 10,
			Font = Util.Fonts.medium,
			Position = UDim2.fromOffset(26, 0),
			Size = UDim2.new(1, -44, 1, 0),
			TextTruncate = Enum.TextTruncate.AtEnd,
		})
		local chevron = Components.icon(button, "chevron-down", 12, "icon")
		chevron.AnchorPoint = Vector2.new(1, 0.5)
		chevron.Position = UDim2.new(1, -8, 0.5, 0)

		local selected = {}
		for _, item in ipairs(spec.value or {}) do
			selected[item] = true
		end
		local function summary()
			local count = 0
			for _ in pairs(selected) do
				count = count + 1
			end
			label.Text = count == 0 and "None selected" or (count .. " selected")
		end
		summary()

		button.MouseButton1Click:Connect(function()
			local overlay = api.overlay
			if api.closeMenus then
				api.closeMenus()
			end
			local origin = overlay.AbsolutePosition
			local position = button.AbsolutePosition
			local height = math.min(#spec.options * 22 + 8, 180)
			local menu = Util.create("Frame", {
				Position = UDim2.fromOffset(position.X - origin.X, position.Y - origin.Y + button.AbsoluteSize.Y + 4),
				Size = UDim2.fromOffset(button.AbsoluteSize.X, 0),
				BackgroundColor3 = Theme.color("panel"),
				ClipsDescendants = true,
				ZIndex = 250,
				Parent = overlay,
			})
			Util.corner(9)
			local menuStroke = Util.stroke(Theme.color("border"), 1)
			menuStroke.Parent = menu
			Util.create("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), Parent = menu })
			Util.list({ Padding = UDim.new(0, 1), Parent = menu })
			for index, option in ipairs(spec.options) do
				local row = Util.create("TextButton", {
					Text = "",
					AutoButtonColor = false,
					LayoutOrder = index,
					Size = UDim2.new(1, 0, 0, 21),
					BackgroundColor3 = Theme.color("panel"),
					BackgroundTransparency = 1,
					ZIndex = 251,
					Parent = menu,
				})
				Util.corner(6)
				local box = Util.create("Frame", {
					Size = UDim2.fromOffset(12, 12),
					Position = UDim2.fromOffset(8, 4),
					BackgroundColor3 = selected[option] and Theme.color("accent") or Theme.color("track"),
					ZIndex = 251,
					Parent = row,
				})
				Util.corner(3)
				local check = Components.icon(row, "check", 10, "bg")
				check.Position = UDim2.fromOffset(9, 5)
				check.ImageTransparency = selected[option] and 0 or 1
				check.ZIndex = 252
				local text = Components.text(row, {
					Text = option,
					TextSize = 10,
					Position = UDim2.fromOffset(26, 0),
					Size = UDim2.new(1, -32, 1, 0),
					ZIndex = 251,
					__role = "muted",
				})
				row.MouseButton1Click:Connect(function()
					selected[option] = not selected[option] or nil
					box.BackgroundColor3 = selected[option] and Theme.color("accent") or Theme.color("track")
					check.ImageTransparency = selected[option] and 0 or 1
					text.TextColor3 = selected[option] and Theme.color("text") or Theme.color("muted")
					summary()
					if spec.onChange then
						local list = {}
						for key in pairs(selected) do
							table.insert(list, key)
						end
						spec.onChange(list)
					end
				end)
			end
			menu.Size = UDim2.fromOffset(button.AbsoluteSize.X, 0)
			Util.tween(menu, 0.14, { Size = UDim2.fromOffset(button.AbsoluteSize.X, height) })
			api.registerMenu(menu)
		end)
		return holder
	end

	function Components.slider(parent, spec)
		local holder = fieldHolder(parent, spec.order)
		local min = spec.min or 0
		local max = spec.max or 100
		local value = spec.value or min
		local suffix = spec.suffix or ""
		local decimals = spec.decimals or 0

		local row = Util.create("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 14),
			LayoutOrder = 1,
			Parent = holder,
		})
		Components.text(row, {
			Text = spec.label or "Value",
			TextSize = 11,
			Size = UDim2.new(1, -50, 1, 0),
			Font = Util.Fonts.medium,
		})
		local valueLabel = Components.text(row, {
			Text = string.format("%s%s", tostring(Util.round(value, decimals)), suffix),
			TextSize = 10,
			Size = UDim2.new(0, 50, 1, 0),
			TextXAlignment = Enum.TextXAlignment.Right,
			__role = "muted",
		})

		local trackArea = Util.create("TextButton", {
			Text = "",
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 14),
			LayoutOrder = 2,
			Parent = holder,
		})
		local track = Util.create("Frame", {
			Size = UDim2.new(1, 0, 0, 3),
			Position = UDim2.new(0, 0, 0.5, -1.5),
			BackgroundColor3 = Theme.color("track"),
			Parent = trackArea,
		})
		Util.corner(2)
		Theme.bind(track, "BackgroundColor3", "track")
		local fill = Util.create("Frame", {
			Size = UDim2.new(0, 0, 1, 0),
			BackgroundColor3 = Theme.color("accent"),
			Parent = track,
		})
		Util.corner(2)
		Theme.bind(fill, "BackgroundColor3", "accent")
		local knob = Util.create("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(10, 10),
			Position = UDim2.new(0, 0, 0.5, 0),
			BackgroundColor3 = Theme.color("accent"),
			Parent = track,
		})
		Util.corner(5)
		Theme.bind(knob, "BackgroundColor3", "accent")
		local knobStroke = Util.stroke(Theme.color("bg"), 2)
		knobStroke.Parent = knob
		Theme.bind(knobStroke, "Color", "bg")

		local function render(animate)
			local alpha = (value - min) / (max - min)
			local target = UDim2.new(alpha, 0, 1, 0)
			if animate == false then
				fill.Size = target
				knob.Position = UDim2.new(alpha, 0, 0.5, 0)
			else
				Util.tween(fill, 0.12, { Size = target })
				Util.tween(knob, 0.12, { Position = UDim2.new(alpha, 0, 0.5, 0) })
			end
			valueLabel.Text = string.format("%s%s", tostring(Util.round(value, decimals)), suffix)
		end
		render(false)

		local dragging = false
		local function setFromX(x)
			local alpha = Util.clamp((x - trackArea.AbsolutePosition.X) / trackArea.AbsoluteSize.X, 0, 1)
			local raw = min + (max - min) * alpha
			if decimals == 0 then
				raw = math.floor(raw + 0.5)
			else
				raw = Util.round(raw, decimals)
			end
			if raw ~= value then
				value = raw
				render(true)
				if spec.onChange then
					spec.onChange(value)
				end
			end
		end

		trackArea.MouseButton1Down:Connect(function(x)
			dragging = true
			setFromX(x)
		end)
		trackArea.MouseEnter:Connect(function()
			Util.tween(knob, 0.15, { Size = UDim2.fromOffset(12, 12) })
		end)
		trackArea.MouseLeave:Connect(function()
			if not dragging then
				Util.tween(knob, 0.15, { Size = UDim2.fromOffset(10, 10) })
			end
		end)
		local input = game:GetService("UserInputService")
		input.InputChanged:Connect(function(inputObject)
			if dragging and inputObject.UserInputType == Enum.UserInputType.MouseMovement then
				setFromX(inputObject.Position.X)
			end
		end)
		input.InputEnded:Connect(function(inputObject)
			if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = false
				Util.tween(knob, 0.15, { Size = UDim2.fromOffset(10, 10) })
			end
		end)

		if spec.hint then
			Components.small(holder, spec.hint)
		end
		return holder
	end

	function Components.checkbox(parent, spec)
		local holder = fieldHolder(parent, spec.order)
		local row = Util.create("TextButton", {
			Text = "",
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 1,
			Parent = holder,
		})
		local left = Util.create("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -24, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Parent = row,
		})
		Util.list({ Padding = UDim.new(0, 2), Parent = left })
		Components.text(left, {
			Text = spec.label or "Option",
			TextSize = 11,
			Font = Util.Fonts.medium,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 13),
			TextWrapped = true,
		})
		if spec.hint then
			Components.small(left, spec.hint)
		end

		local checked = spec.value and true or false
		local box = Util.create("Frame", {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, 0, 0, 0),
			Size = UDim2.fromOffset(14, 14),
			BackgroundColor3 = checked and Theme.color("accent") or Theme.color("panel3"),
			Parent = row,
		})
		Util.corner(4)
		local boxStroke = Util.stroke(Theme.color("border"), 1, 0.1)
		boxStroke.Parent = box
		Theme.bind(boxStroke, "Color", checked and "accent" or "border")
		local check = Components.icon(box, "check", 11, "bg")
		check.Position = UDim2.fromOffset(2, 2)
		check.ImageTransparency = checked and 0 or 1
		Theme.bind(check, "ImageColor3", "bg")

		row.MouseButton1Click:Connect(function()
			checked = not checked
			box.BackgroundColor3 = checked and Theme.color("accent") or Theme.color("panel3")
			boxStroke.Color = checked and Theme.color("accent") or Theme.color("border")
			check.ImageTransparency = checked and 0 or 1
			if spec.onChange then
				spec.onChange(checked)
			end
		end)
		return holder
	end

	function Components.keybind(parent, spec)
		local holder = fieldHolder(parent, spec.order)
		local row = Util.create("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 20),
			LayoutOrder = 1,
			Parent = holder,
		})
		Components.text(row, {
			Text = spec.label or "Keybind",
			TextSize = 11,
			Font = Util.Fonts.medium,
			Size = UDim2.new(1, -64, 1, 0),
		})
		local button = Util.create("TextButton", {
			Text = "",
			AutoButtonColor = false,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			Size = UDim2.fromOffset(60, 20),
			BackgroundColor3 = Theme.color("panel2"),
			Parent = row,
		})
		Util.corner(6)
		local stroke = Util.stroke(Theme.color("border"), 1, 0.2)
		stroke.Parent = button
		Theme.bind(button, "BackgroundColor3", "panel2")
		Theme.bind(stroke, "Color", "border")
		local keyLabel = Components.text(button, {
			Text = spec.value or "None",
			TextSize = 10,
			Font = Util.Fonts.medium,
			Size = UDim2.fromScale(1, 1),
			TextXAlignment = Enum.TextXAlignment.Center,
			__role = "muted",
		})

		local listening = false
		local input = game:GetService("UserInputService")
		button.MouseButton1Click:Connect(function()
			listening = not listening
			keyLabel.Text = listening and "Press..." or keyLabel.Text
			if listening then
				Theme.bind(keyLabel, "TextColor3", "accent")
				keyLabel.TextColor3 = Theme.color("accent")
			end
		end)
		input.InputBegan:Connect(function(inputObject, processed)
			if not listening or processed then
				return
			end
			if inputObject.UserInputType ~= Enum.UserInputType.Keyboard then
				return
			end
			if inputObject.KeyCode == Enum.KeyCode.Escape then
				listening = false
				keyLabel.Text = "None"
				keyLabel.TextColor3 = Theme.color("muted")
				if spec.onChange then
					spec.onChange(nil)
				end
				return
			end
			local name = inputObject.KeyCode.Name
			keyLabel.Text = name
			keyLabel.TextColor3 = Theme.color("muted")
			listening = false
			if spec.onChange then
				spec.onChange(name)
			end
		end)
		return holder
	end

	function Components.divider(parent, order)
		return Util.create("Frame", {
			BackgroundColor3 = Theme.color("border"),
			BackgroundTransparency = 0.35,
			Size = UDim2.new(1, 0, 0, 1),
			LayoutOrder = order or 5,
			Parent = parent,
		})
	end

	function Components.card(parent, spec, order)
		local card = Util.create("Frame", {
			Name = spec.id or "Card",
			BackgroundColor3 = Theme.color("panel"),
			BackgroundTransparency = 0,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = order or 1,
			Parent = parent,
		})
		Util.corner(13)
		Util.gradient(Theme.color("panel2"), Theme.color("panel"), 145).Parent = card
		local stroke = Util.stroke(Theme.color("borderSoft"), 1)
		stroke.Parent = card
		Theme.bind(stroke, "Color", "borderSoft")
		Util.create("UIPadding", {
			PaddingTop = UDim.new(0, 11),
			PaddingBottom = UDim.new(0, 11),
			PaddingLeft = UDim.new(0, 11),
			PaddingRight = UDim.new(0, 11),
			Parent = card,
		})
		local layout = Util.list({ Padding = UDim.new(0, 8), Parent = card })

		local head = Util.create("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 16),
			LayoutOrder = 0,
			Parent = card,
		})
		local headIcon = Components.icon(head, spec.icon or "box", 16, "icon")
		headIcon.Position = UDim2.fromOffset(0, 1)

		local title = Components.text(head, {
			Text = spec.title or "Card",
			TextSize = 12,
			Font = Util.Fonts.medium,
			Position = UDim2.fromOffset(20, 0),
			Size = UDim2.new(1, -80, 1, 0),
			TextTruncate = Enum.TextTruncate.AtEnd,
		})

		if spec.star ~= false then
			local star = Components.icon(head, "star", 11, "icon")
			star.AnchorPoint = Vector2.new(1, 0.5)
			star.Position = UDim2.new(1, spec.toggle and -40 or -4, 0.5, 0)
			star.ImageTransparency = 0.45
		end

		if spec.pill then
			local pillFrame = Components.pill(head, spec.pill)
			pillFrame.AnchorPoint = Vector2.new(1, 0.5)
			pillFrame.Position = UDim2.new(1, spec.toggle and -46 or -18, 0.5, 0)
		end

		local toggler = nil
		if spec.toggle then
			toggler = Components.toggle(head, spec.value, function(state)
				if spec.onToggle then
					spec.onToggle(state)
				end
			end)
			toggler.frame.AnchorPoint = Vector2.new(1, 0.5)
			toggler.frame.Position = UDim2.new(1, 0, 0.5, 0)
		end

		if spec.desc then
			local desc = Components.text(card, {
				Text = spec.desc,
				TextSize = 10,
				TextWrapped = true,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0),
				LayoutOrder = 1,
				__role = "muted",
			})
			desc.TextTransparency = 0.15
		end

		local hasFields = spec.fields and #spec.fields > 0
		if hasFields then
			Util.create("Frame", {
				BackgroundColor3 = Theme.color("border"),
				BackgroundTransparency = 0.4,
				Size = UDim2.new(1, 0, 0, 1),
				LayoutOrder = 2,
				Parent = card,
			})
		end

		card.MouseEnter:Connect(function()
			Util.tween(stroke, 0.15, { Color = Theme.color("border"), Transparency = 0 })
		end)
		card.MouseLeave:Connect(function()
			Util.tween(stroke, 0.15, { Color = Theme.color("borderSoft") })
		end)

		if hasFields then
			for index, field in ipairs(spec.fields) do
				field.order = index + 10
				if field.type == "select" then
					Components.select(card, field)
				elseif field.type == "multi" then
					Components.multi(card, field)
				elseif field.type == "slider" then
					Components.slider(card, field)
				elseif field.type == "checkbox" then
					Components.checkbox(card, field)
				elseif field.type == "keybind" then
					Components.keybind(card, field)
				elseif field.type == "button" then
					Components.button(card, field)
				elseif field.type == "divider" then
					Components.divider(card, field.order)
				elseif field.type == "text" then
					Components.label(card, field.label, field.role)
				elseif field.type == "hint" then
					Components.small(card, field.label)
				end
			end
		end

		return { frame = card, setToggle = toggler and toggler.set or nil, title = title, layout = layout }
	end

	return Components
end
