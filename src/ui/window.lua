return function(ctx)
	local Util = ctx.require("core.util")
	local Theme = ctx.require("ui.theme")
	local Components = ctx.require("ui.components")
	local Icons = ctx.require("core.icons")

	local Window = {}
	local store = nil
	local root = nil
	local topbar = nil
	local navFrame = nil
	local toolsFrame = nil
	local overlay = nil
	local content = nil
	local body = nil
	local cards = {}
	local tabs = {}
	local actions = {}
	local activeTab = nil
	local built = {}
	local menus = {}
	local isOpen = true
	local maximized = false
	local previousSize = nil
	local searchFrame = nil
	local searchBox = nil
	local query = ""
	local tabButtons = {}

	local TITLE_BAR_HEIGHT = 46

	local function closeMenus()
		for _, menu in ipairs(menus) do
			if menu.Parent then
				menu:Destroy()
			end
		end
		table.clear(menus)
	end

	local function registerMenu(menu)
		table.insert(menus, menu)
	end

	local function columnCount()
		local width = root and root.AbsoluteSize.X or 720
		if width < 520 then
			return 1
		elseif width < 700 then
			return 2
		end
		return 3
	end

	function Window.setTab(id)
		activeTab = id
		for tabId, button in pairs(tabButtons) do
			local active = tabId == id
			Util.tween(button.icon, 0.15, { ImageColor3 = active and Theme.color("accent") or Theme.color("icon") })
			button.background.BackgroundTransparency = active and 0 or 1
			button.underline.Visible = active
		end
		Window.build()
	end

	local function bindCard(spec)
		if spec.toggle then
			spec.value = store.get(spec.path .. ".enabled", true)
			spec.onToggle = function(state)
				store.set(spec.path .. ".enabled", state)
			end
		end
		for _, field in ipairs(spec.fields or {}) do
			local path = spec.path .. "." .. field.id
			if field.type == "select" then
				field.value = store.get(path, field.value)
				field.onChange = function(option)
					store.set(path, option)
				end
			elseif field.type == "multi" then
				local current = store.get(path, {})
				if type(current) == "table" then
					local list = {}
					for key, value in pairs(current) do
						if type(key) == "number" then
							table.insert(list, value)
						elseif value then
							table.insert(list, key)
						end
					end
					field.value = list
				else
					field.value = {}
				end
				field.onChange = function(list)
					store.set(path, list)
				end
			elseif field.type == "slider" then
				field.value = store.get(path, field.value or field.min or 0)
				field.onChange = function(value)
					store.set(path, value)
				end
			elseif field.type == "checkbox" then
				field.value = store.get(path, field.value)
				field.onChange = function(value)
					store.set(path, value)
				end
			elseif field.type == "keybind" then
				field.value = store.get(path, field.value)
				field.onChange = function(value)
					store.set(path, value)
				end
			elseif field.type == "button" then
				field.onClick = function()
					local handler = field.action and actions[field.action]
					if handler then
						handler()
					end
				end
			end
		end
	end

	local function buildTab(id)
		local tab = nil
		for _, item in ipairs(tabs) do
			if item.id == id then
				tab = item
			end
		end
		if not tab then
			return
		end
		for _, child in ipairs(content:GetChildren()) do
			if child:IsA("ScrollingFrame") then
				child:Destroy()
			end
		end
		closeMenus()

		local columns = columnCount()
		local frames = {}
		for index = 1, columns do
			local column = Util.create("ScrollingFrame", {
				Name = "Column" .. index,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1 / columns, -8, 1, 0),
				Position = UDim2.new((index - 1) / columns, 0, 0, 0),
				CanvasSize = UDim2.new(0, 0, 0, 0),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollBarThickness = 0,
				ScrollBarImageColor3 = Theme.color("border"),
				ScrollBarImageTransparency = 0.3,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				Parent = content,
			})
			Util.create("UIListLayout", {
				Padding = UDim.new(0, 9),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = column,
			})
			Util.create("UIPadding", { PaddingRight = UDim.new(0, 4), Parent = column })
			table.insert(frames, column)
		end

		for index, cardSpec in ipairs(tab.cards) do
			local column = frames[((index - 1) % columns) + 1]
			bindCard(cardSpec)
			local card = Components.card(column, cardSpec, index)
			table.insert(cards, card)
		end
	end

	function Window.build()
		cards = {}
		buildTab(activeTab)
		if query ~= "" then
			Window.filter(query)
		end
	end

	function Window.filter(text)
		query = string.lower(text or "")
		for _, card in ipairs(cards) do
			local name = string.lower(card.title.Text)
			card.frame.Visible = query == "" or string.find(name, query, 1, true) ~= nil
		end
	end

	local function createTrafficLights(parent)
		local holder = Util.create("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(52, 14),
			Position = UDim2.new(0, 12, 0.5, -7),
			Parent = parent,
		})
		Util.hlist({ Padding = UDim.new(0, 7), Parent = holder })

		local function dot(color, symbol, onClick, tooltip)
			local button = Util.create("TextButton", {
				Text = "",
				AutoButtonColor = false,
				Size = UDim2.fromOffset(12, 12),
				BackgroundColor3 = color,
				LayoutOrder = 1,
				Parent = holder,
			})
			Util.corner(6)
			local glyphHolder = Util.create("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				Parent = button,
			})
			if symbol == "close" then
				for _, rotation in ipairs({ 45, -45 }) do
					local line = Util.create("Frame", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.fromOffset(6, 1),
						Rotation = rotation,
						BackgroundColor3 = Color3.fromRGB(70, 20, 20),
						Parent = glyphHolder,
					})
					line.Name = "Glyph"
				end
			elseif symbol == "min" then
				Util.create("Frame", {
					Name = "Glyph",
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(6, 1),
					BackgroundColor3 = Color3.fromRGB(90, 70, 20),
					Parent = glyphHolder,
				})
			else
				Util.create("Frame", {
					Name = "Glyph",
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(5, 5),
					BackgroundColor3 = Color3.fromRGB(25, 80, 35),
					Parent = glyphHolder,
				})
			end
			glyphHolder.Visible = false
			button.MouseEnter:Connect(function()
				glyphHolder.Visible = true
			end)
			button.MouseLeave:Connect(function()
				glyphHolder.Visible = false
			end)
			button.MouseButton1Click:Connect(function()
				onClick()
			end)
			button.Name = tooltip or symbol
			return button
		end

		dot(Color3.fromRGB(255, 95, 87), "close", function()
			Window.close()
		end, "Close")
		dot(Color3.fromRGB(254, 188, 46), "min", function()
			Window.minimize()
		end, "Minimize")
	end

	local function createNav(parent)
		navFrame = Util.create("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.fromOffset(0, 34),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundColor3 = Theme.color("panel"),
			BackgroundTransparency = 0.2,
			Parent = parent,
		})
		Util.corner(11)
		local stroke = Util.stroke(Theme.color("borderSoft"), 1, 0.2)
		stroke.Parent = navFrame
		Theme.bind(stroke, "Color", "borderSoft")
		Util.create("UIPadding", {
			PaddingLeft = UDim.new(0, 6),
			PaddingRight = UDim.new(0, 6),
			Parent = navFrame,
		})
		Util.hlist({ Padding = UDim.new(0, 3), Parent = navFrame })

		for index, tab in ipairs(tabs) do
			local button = Util.create("TextButton", {
				Text = "",
				AutoButtonColor = false,
				Size = UDim2.fromOffset(30, 28),
				BackgroundColor3 = Theme.color("accentSoft"),
				BackgroundTransparency = 1,
				LayoutOrder = index,
				Parent = navFrame,
			})
			Util.corner(8)
			local icon = Components.icon(button, tab.icon or "box", 18, "icon")
			icon.AnchorPoint = Vector2.new(0.5, 0.5)
			icon.Position = UDim2.fromScale(0.5, 0.5)
			local underline = Util.create("Frame", {
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.new(0.5, 0, 1, -3),
				Size = UDim2.fromOffset(12, 2),
				BackgroundColor3 = Theme.color("accent"),
				Visible = false,
				Parent = button,
			})
			Util.corner(1)
			Theme.bind(underline, "BackgroundColor3", "accent")

			button.MouseEnter:Connect(function()
				if activeTab ~= tab.id then
					Util.tween(button, 0.12, { BackgroundTransparency = 0.4 })
				end
			end)
			button.MouseLeave:Connect(function()
				if activeTab ~= tab.id then
					Util.tween(button, 0.12, { BackgroundTransparency = 1 })
				end
			end)
			button.MouseButton1Click:Connect(function()
				Window.setTab(tab.id)
			end)

			tabButtons[tab.id] = { background = button, icon = icon, underline = underline }
		end
	end

	local function createTools(parent)
		toolsFrame = Util.create("Frame", {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -12, 0.5, 0),
			Size = UDim2.fromOffset(0, 28),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			Parent = parent,
		})
		Util.hlist({ Padding = UDim.new(0, 2), Parent = toolsFrame })

		local function toolButton(icon, tooltip, onClick, order)
			local button = Util.create("TextButton", {
				Text = "",
				AutoButtonColor = false,
				Size = UDim2.fromOffset(26, 26),
				BackgroundTransparency = 1,
				LayoutOrder = order,
				Parent = toolsFrame,
			})
			Util.corner(7)
			local image = Components.icon(button, icon, 18, "icon")
			image.AnchorPoint = Vector2.new(0.5, 0.5)
			image.Position = UDim2.fromScale(0.5, 0.5)
			button.Name = tooltip
			button.MouseEnter:Connect(function()
				Util.tween(button, 0.12, { BackgroundTransparency = 0 })
				button.BackgroundColor3 = Theme.color("panel3")
				image.ImageColor3 = Theme.color("text")
			end)
			button.MouseLeave:Connect(function()
				Util.tween(button, 0.12, { BackgroundTransparency = 1 })
				image.ImageColor3 = Theme.color("icon")
			end)
			button.MouseButton1Click:Connect(function()
				onClick(button, image)
			end)
			return button, image
		end

		toolButton("sparkles", "Effects", function(button)
			local state = not store.get("settings.effects", true)
			store.set("settings.effects", state)
			button.BackgroundTransparency = state and 1 or 0
		end, 1)

		toolButton("search", "Search", function(button, image)
			Window.toggleSearch()
		end, 2)

		toolButton("palette", "Theme", function(button)
			Window.openThemes(button)
		end, 3)

		toolButton("settings", "Settings", function()
			Window.setTab("files")
		end, 4)
	end

	function Window.openThemes(anchor)
		closeMenus()
		local origin = overlay.AbsolutePosition
		local position = anchor.AbsolutePosition
		local entries = {}
		for id, palette in pairs(Theme.palettes) do
			table.insert(entries, { id = id, label = palette.label, accent = palette.accent })
		end
		table.sort(entries, function(a, b)
			return a.label < b.label
		end)
		local height = #entries * 24 + 10
		local menu = Util.create("Frame", {
			Position = UDim2.fromOffset(position.X - origin.X - 120, position.Y - origin.Y + 30),
			Size = UDim2.fromOffset(150, 0),
			BackgroundColor3 = Theme.color("panel"),
			ClipsDescendants = true,
			ZIndex = 260,
			Parent = overlay,
		})
		Util.corner(10)
		local stroke = Util.stroke(Theme.color("border"), 1)
		stroke.Parent = menu
		Util.create("UIPadding", {
			PaddingTop = UDim.new(0, 5),
			PaddingBottom = UDim.new(0, 5),
			PaddingLeft = UDim.new(0, 6),
			PaddingRight = UDim.new(0, 6),
			Parent = menu,
		})
		Util.list({ Padding = UDim.new(0, 2), Parent = menu })
		for index, entry in ipairs(entries) do
			local row = Util.create("TextButton", {
				Text = "",
				AutoButtonColor = false,
				Size = UDim2.new(1, 0, 0, 22),
				BackgroundTransparency = entry.id == Theme.get() and 0 or 1,
				BackgroundColor3 = Theme.color("accentSoft"),
				LayoutOrder = index,
				ZIndex = 261,
				Parent = menu,
			})
			Util.corner(6)
			local swatch = Util.create("Frame", {
				Size = UDim2.fromOffset(10, 10),
				Position = UDim2.fromOffset(2, 6),
				BackgroundColor3 = Color3.fromHex(entry.accent),
				ZIndex = 262,
				Parent = row,
			})
			Util.corner(5)
			local label = Components.text(row, {
				Text = entry.label,
				TextSize = 10,
				Font = entry.id == Theme.get() and Util.Fonts.medium or Util.Fonts.body,
				Position = UDim2.fromOffset(20, 0),
				Size = UDim2.new(1, -24, 1, 0),
				ZIndex = 261,
			})
			row.MouseButton1Click:Connect(function()
				Theme.apply(entry.id)
				store.set("settings.theme", entry.id)
				closeMenus()
			end)
			row.MouseEnter:Connect(function()
				row.BackgroundTransparency = 0
			end)
			row.MouseLeave:Connect(function()
				if entry.id ~= Theme.get() then
					row.BackgroundTransparency = 1
				end
			end)
		end
		menu.Size = UDim2.fromOffset(150, 0)
		Util.tween(menu, 0.15, { Size = UDim2.fromOffset(150, height) })
		registerMenu(menu)
	end

	function Window.toggleSearch()
		if searchFrame then
			Util.tween(searchFrame, 0.15, { Size = UDim2.fromOffset(0, 24), BackgroundTransparency = 1 })
			task.delay(0.16, function()
				searchFrame.Visible = false
			end)
			searchFrame = nil
			Window.filter("")
			return
		end
		searchFrame = Util.create("Frame", {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 150, 0.5, 0),
			Size = UDim2.fromOffset(0, 24),
			BackgroundColor3 = Theme.color("panel2"),
			Parent = topbar,
		})
		Util.corner(7)
		Util.stroke(Theme.color("border"), 1, 0.1).Parent = searchFrame
		local icon = Components.icon(searchFrame, "search", 15, "icon")
		icon.Position = UDim2.fromOffset(7, 6)
		searchBox = Util.create("TextBox", {
			Text = "",
			PlaceholderText = "search features",
			PlaceholderColor3 = Theme.color("muted"),
			BackgroundTransparency = 1,
			TextColor3 = Theme.color("text"),
			Font = Util.Fonts.body,
			TextSize = 10,
			TextXAlignment = Enum.TextXAlignment.Left,
			Position = UDim2.fromOffset(24, 0),
			Size = UDim2.new(1, -30, 1, 0),
			ClearTextOnFocus = false,
			Parent = searchFrame,
		})
		searchBox:GetPropertyChangedSignal("Text"):Connect(function()
			Window.filter(searchBox.Text)
		end)
		Util.tween(searchFrame, 0.18, { Size = UDim2.fromOffset(160, 24) })
	end

	function Window.minimize()
		if not isOpen then
			return
		end
		isOpen = false
		minimized = true
		Util.tween(root, 0.2, {
			Size = UDim2.fromOffset(root.AbsoluteSize.X, TITLE_BAR_HEIGHT),
		}, Enum.EasingStyle.Quint)
		body.Visible = false
	end

	function Window.maximize()
		maximized = not maximized
		if maximized then
			previousSize = root.Size
			Util.tween(root, 0.22, {
				Size = UDim2.fromOffset(math.min(1000, workspace.CurrentCamera.ViewportSize.X - 60), math.min(640, workspace.CurrentCamera.ViewportSize.Y - 80)),
				Position = UDim2.fromScale(0.5, 0.5),
			}, Enum.EasingStyle.Quint)
		else
			Util.tween(root, 0.22, {
				Size = previousSize or UDim2.fromOffset(720, 490),
				Position = UDim2.fromScale(0.5, 0.5),
			}, Enum.EasingStyle.Quint)
		end
		task.delay(0.24, function()
			Window.build()
		end)
	end

	function Window.open()
		if isOpen then
			return
		end
		isOpen = true
		body.Visible = true
		Util.tween(root, 0.24, { Size = UDim2.fromOffset(720, 490) }, Enum.EasingStyle.Quint)
	end

	function Window.close()
		if not root then
			return
		end
		Util.tween(root, 0.18, {
			Size = UDim2.fromOffset(root.AbsoluteSize.X * 0.94, root.AbsoluteSize.Y * 0.94),
			BackgroundTransparency = 1,
		}, Enum.EasingStyle.Quint)
		task.delay(0.19, function()
			root.Visible = false
			root.Size = UDim2.fromOffset(720, 490)
			root.BackgroundTransparency = 0
			isOpen = false
		end)
	end

	function Window.toggleOpen()
		if not root.Visible or not isOpen then
			root.Visible = true
			isOpen = true
			root.BackgroundTransparency = root.BackgroundTransparency
			body.Visible = true
			if minimized then
				minimized = false
				Util.tween(root, 0.22, { Size = UDim2.fromOffset(720, 490) }, Enum.EasingStyle.Quint)
			end
			Util.tween(root, 0.22, { BackgroundTransparency = 0 }, Enum.EasingStyle.Quint)
		else
			Window.close()
		end
	end

	function Window.init(parent, tabsRef, storeRef, actionsRef)
		store = storeRef
		tabs = tabsRef
		actions = actionsRef or {}

		root = Util.create("Frame", {
			Name = "ybassft",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(720, 490),
			BackgroundColor3 = Theme.color("bg"),
			BackgroundTransparency = 1,
			ClipsDescendants = false,
			ZIndex = 50,
			Parent = parent,
		})
		Util.corner(16)
		Util.stroke(Theme.color("border"), 1, 0.15).Parent = root
		local shadow = Util.create("ImageLabel", {
			Image = "rbxasset://textures/ui/Shell/Shadows/Shadow.png",
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(10, 10, 90, 90),
			BackgroundTransparency = 1,
			ImageTransparency = 0.5,
			ImageColor3 = Color3.new(0, 0, 0),
			Size = UDim2.new(1, 40, 1, 40),
			Position = UDim2.fromOffset(-20, -12),
			ZIndex = 49,
			Parent = root,
		})
		shadow.Name = "Shadow"

		local uiScale = Util.create("UIScale", { Scale = 1, Parent = root })

		topbar = Util.create("Frame", {
			Name = "Topbar",
			Size = UDim2.new(1, -16, 0, 42),
			Position = UDim2.fromOffset(8, 6),
			BackgroundColor3 = Theme.color("panel"),
			ClipsDescendants = false,
			ZIndex = 51,
			Parent = root,
		})
		Util.corner(12)
		local barStroke = Util.stroke(Theme.color("borderSoft"), 1, 0.2)
		barStroke.Parent = topbar

		createTrafficLights(topbar)
		createNav(topbar)
		createTools(topbar)

		body = Util.create("Frame", {
			Name = "Body",
			Size = UDim2.new(1, -16, 1, -58),
			Position = UDim2.fromOffset(8, 52),
			BackgroundTransparency = 1,
			ZIndex = 51,
			Parent = root,
		})

		content = Util.create("Frame", {
			Name = "Content",
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Parent = body,
		})

		overlay = Util.create("Frame", {
			Name = "Overlay",
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ZIndex = 200,
			ClipsDescendants = false,
			Parent = body,
		})

		local grip = Util.create("TextButton", {
			Text = "",
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.new(1, -4, 1, -4),
			Size = UDim2.fromOffset(16, 16),
			ZIndex = 54,
			Parent = root,
		})
		local gripIcon = Util.create("ImageLabel", {
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/Shell/ScrollBar/ScrollBarVerticalThumb.png",
			ImageTransparency = 0.5,
			Size = UDim2.fromOffset(10, 10),
			Position = UDim2.fromOffset(3, 3),
			ZIndex = 54,
			Parent = grip,
		})
		gripIcon.Rotation = -45

		local resizing = false
		local startSize, startPos, startMouse = nil, nil, nil
		grip.MouseButton1Down:Connect(function()
			resizing = true
			startSize = root.AbsoluteSize
			startPos = root.AbsolutePosition
			startMouse = game:GetService("UserInputService"):GetMouseLocation()
		end)
		game:GetService("UserInputService").InputChanged:Connect(function(input)
			if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
				local mouse = game:GetService("UserInputService"):GetMouseLocation()
				local delta = mouse - startMouse
				local desired = Vector2.new(
					Util.clamp(startSize.X + delta.X, 420, workspace.CurrentCamera.ViewportSize.X - 40),
					Util.clamp(startSize.Y + delta.Y, 300, workspace.CurrentCamera.ViewportSize.Y - 40)
				)
				root.Size = UDim2.fromOffset(desired.X, desired.Y)
			end
		end)
		game:GetService("UserInputService").InputEnded:Connect(function(input)
			if resizing and input.UserInputType == Enum.UserInputType.MouseButton1 then
				resizing = false
				Window.build()
			end
		end)

		local dragging = false
		local dragStart = nil
		topbar.MouseButton1Down:Connect(function()
			dragging = true
			dragStart = {
				mouse = game:GetService("UserInputService"):GetMouseLocation(),
				pos = root.AbsolutePosition,
			}
		end)
		game:GetService("UserInputService").InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				local mouse = game:GetService("UserInputService"):GetMouseLocation()
				local delta = mouse - dragStart.mouse
				local size = root.AbsoluteSize
				local viewport = workspace.CurrentCamera.ViewportSize
				local x = Util.clamp(dragStart.pos.X + delta.X, -size.X * 0.5, viewport.X - size.X * 0.5)
				local y = Util.clamp(dragStart.pos.Y + delta.Y, 0, viewport.Y - 44)
				root.Position = UDim2.fromOffset(x + size.X * 0.5, y)
			end
		end)
		game:GetService("UserInputService").InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = false
			end
		end)

		root.Size = UDim2.fromOffset(0, 0)
		root.Visible = true
		root.BackgroundTransparency = 1
		Util.tween(root, 0.26, {
			Size = UDim2.fromOffset(720, 490),
			BackgroundTransparency = 0,
		}, Enum.EasingStyle.Quint)

		Components.init({
			overlay = overlay,
			closeMenus = closeMenus,
			registerMenu = registerMenu,
			store = store,
		})

		Window.setTab(tabs[1].id)
	end

	function Window.root()
		return root
	end

	function Window.scale()
		local uiScale = root and root:FindFirstChildOfClass("UIScale")
		return uiScale
	end

	return Window
end
