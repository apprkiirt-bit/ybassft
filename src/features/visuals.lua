return function(ctx)
	local YBA = ctx.require("features.yba")
	local Store = ctx.store
	local RunService = game:GetService("RunService")
	local Lighting = game:GetService("Lighting")
	local UserInputService = game:GetService("UserInputService")

	local Visuals = {}
	local drawings = {}
	local highlights = {}
	local clock = 0
	local hasDrawing = Drawing ~= nil
	local lastClick = 0

	local function on(path, fallback)
		return Store.get(path, fallback)
	end

	local function newDrawing(kind)
		if not hasDrawing then
			return nil
		end
		local ok, object = pcall(function()
			return Drawing.new(kind)
		end)
		if ok then
			return object
		end
		return nil
	end

	local function clearDrawings()
		for _, object in pairs(drawings) do
			for _, part in pairs(object) do
				pcall(function()
					part:Remove()
				end)
			end
		end
		drawings = {}
	end

	local function objectFor(id)
		if not drawings[id] then
			drawings[id] = {
				box = newDrawing("Square"),
				name = newDrawing("Text"),
				distance = newDrawing("Text"),
				health = newDrawing("Square"),
				healthBack = newDrawing("Square"),
				tracer = newDrawing("Line"),
			}
		end
		return drawings[id]
	end

	local function hide(object)
		if not object then
			return
		end
		object.Visible = false
	end

	local function screenPoint(position)
		local camera = workspace.CurrentCamera
		if not camera then
			return nil, false
		end
		local point, onScreen = camera:WorldToViewportPoint(position)
		return Vector2.new(point.X, point.Y), onScreen and point.Z > 0
	end

	local function drawPlayer(entry)
		local model = entry.model
		local root = YBA.rootOf(model)
		if not root then
			return false
		end
		local head = model:FindFirstChild("Head")
		local top = (head and head.Position or root.Position) + Vector3.new(0, 1, 0)
		local bottom = root.Position - Vector3.new(0, 2.6, 0)
		local topPoint, topVisible = screenPoint(top)
		local bottomPoint, bottomVisible = screenPoint(bottom)
		if not topPoint or not bottomPoint or not topVisible or not bottomVisible then
			return false
		end
		local objects = objectFor(model)
		local height = math.abs(bottomPoint.Y - topPoint.Y)
		local width = height * 0.55
		local left = topPoint.X - width / 2
		local topY = topPoint.Y

		if on("visuals.players.box", true) then
			objects.box.Visible = true
			objects.box.Color = Color3.fromRGB(138, 121, 232)
			objects.box.Thickness = 1
			objects.box.From = Vector2.new(left, topY)
			objects.box.To = Vector2.new(left + width, topY + height)
		else
			hide(objects.box)
		end

		if on("visuals.players.name", true) then
			objects.name.Visible = true
			objects.name.Text = entry.name
			objects.name.Color = Color3.fromRGB(255, 255, 255)
			objects.name.Size = 13
			objects.name.Center = true
			objects.name.Outline = true
			objects.name.Position = Vector2.new(topPoint.X, topY - 15)
		else
			hide(objects.name)
		end

		if on("visuals.players.distance", true) then
			objects.distance.Visible = true
			objects.distance.Text = math.floor(entry.distance) .. "m"
			objects.distance.Color = Color3.fromRGB(190, 190, 200)
			objects.distance.Size = 12
			objects.distance.Center = true
			objects.distance.Outline = true
			objects.distance.Position = Vector2.new(topPoint.X, topY + height + 2)
		else
			hide(objects.distance)
		end

		if on("visuals.players.health", true) then
			local humanoid = YBA.humanoidOf(model)
			local ratio = humanoid and math.clamp(humanoid.Health / math.max(humanoid.MaxHealth, 1), 0, 1) or 0
			objects.healthBack.Visible = true
			objects.healthBack.Color = Color3.fromRGB(30, 32, 40)
			objects.healthBack.Thickness = 1
			objects.healthBack.Filled = true
			objects.healthBack.From = Vector2.new(left - 5, topY)
			objects.healthBack.To = Vector2.new(left - 2, topY + height)
			objects.health.Visible = true
			objects.health.Color = Color3.fromRGB(90, 220, 140)
			objects.health.Thickness = 1
			objects.health.Filled = true
			objects.health.From = Vector2.new(left - 5, topY + height * (1 - ratio))
			objects.health.To = Vector2.new(left - 2, topY + height)
		else
			hide(objects.health)
			hide(objects.healthBack)
		end

		if on("visuals.players.tracers", false) then
			local camera = workspace.CurrentCamera
			objects.tracer.Visible = true
			objects.tracer.Color = Color3.fromRGB(138, 121, 232)
			objects.tracer.Thickness = 1
			objects.tracer.Transparency = 0.4
			objects.tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
			objects.tracer.To = Vector2.new(topPoint.X, topY + height / 2)
		else
			hide(objects.tracer)
		end

		if on("visuals.players.chams", false) then
			if not highlights[model] then
				local highlight = Instance.new("Highlight")
				highlight.FillColor = Color3.fromRGB(138, 121, 232)
				highlight.OutlineColor = Color3.fromRGB(160, 145, 240)
				highlight.FillTransparency = 0.6
				highlight.Parent = model
				highlights[model] = highlight
			end
		elseif highlights[model] then
			highlights[model]:Destroy()
			highlights[model] = nil
		end

		return true
	end

	local function drawItem(entry)
		local point, visible = screenPoint(entry.root.Position)
		if not point or not visible then
			return
		end
		local objects = objectFor(entry.model)
		objects.name.Visible = true
		objects.name.Text = entry.name
		objects.name.Color = Color3.fromRGB(232, 180, 93)
		objects.name.Size = 12
		objects.name.Center = true
		objects.name.Outline = true
		objects.name.Position = point
		objects.distance.Visible = true
		objects.distance.Text = math.floor(entry.distance) .. "m"
		objects.distance.Color = Color3.fromRGB(180, 170, 150)
		objects.distance.Size = 11
		objects.distance.Center = true
		objects.distance.Outline = true
		objects.distance.Position = point + Vector2.new(0, 12)
		hide(objects.box)
		hide(objects.health)
		hide(objects.healthBack)
		hide(objects.tracer)
	end

	local function visualTick()
		if not hasDrawing then
			return
		end
		if on("visuals.players.enabled", false) then
			local maxDistance = on("visuals.players.max_distance", 500)
			for _, other in ipairs(game:GetService("Players"):GetPlayers()) do
				if other ~= YBA.player and other.Character and YBA.alive(other.Character) then
					local distance = YBA.distance(YBA.player.Character, other.Character)
					if distance <= maxDistance then
						drawPlayer({ model = other.Character, name = other.Name, distance = distance })
					end
				end
			end
		end
		if on("visuals.items.enabled", false) then
			local maxDistance = on("visuals.items.max_distance", 400)
			for _, entry in ipairs(YBA.items()) do
				if entry.distance <= maxDistance then
					drawItem(entry)
				end
			end
		end
	end

	local removalPatterns = {
		MIH = { "made in heaven", "mih", "reset", "universe reset" },
		KQ = { "killer queen", "bites the dust", "sheer heart", "explosion", "detonate" },
	}

	local function shouldRemove(name, set)
		local lower = string.lower(name)
		for _, pattern in ipairs(removalPatterns[set] or {}) do
			if string.find(lower, pattern, 1, true) then
				return true
			end
		end
		return false
	end

	local function stripEffects(object)
		for _, descendant in ipairs(object:GetDescendants()) do
			if descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Trail") or descendant:IsA("Explosion") then
				pcall(function()
					descendant.Enabled = false
				end)
			end
			if descendant:IsA("Decal") or descendant:IsA("Texture") then
				pcall(function()
					descendant.Transparency = 1
				end)
			end
		end
	end

	local function installRemovalHooks()
		workspace.DescendantAdded:Connect(function(object)
			if on("visuals.remove_mih.enabled", false) and shouldRemove(object.Name, "MIH") then
				pcall(function()
					object:Destroy()
				end)
			end
			if on("visuals.remove_kq.enabled", false) and shouldRemove(object.Name, "KQ") then
				pcall(function()
					if object:IsA("Explosion") or object:IsA("ParticleEmitter") or object:IsA("Beam") then
						object.Enabled = false
					elseif object:IsA("Model") then
						stripEffects(object)
					end
				end)
			end
			if on("visuals.low_gfx.enabled", false) and (object:IsA("ParticleEmitter") or object:IsA("Beam") or object:IsA("Trail")) then
				local parent = object:FindFirstAncestorOfClass("Model")
				if not parent or not game:GetService("Players"):GetPlayerFromCharacter(parent) then
					pcall(function()
						object.Enabled = false
					end)
				end
			end
		end)
	end

	local function applyLowGfx()
		if on("visuals.low_gfx.enabled", false) then
			Lighting.GlobalShadows = false
			Lighting.FogEnd = 100000
			for _, effect in ipairs(Lighting:GetChildren()) do
				if effect:IsA("PostEffect") or effect:IsA("BloomEffect") or effect:IsA("SunRaysEffect") then
					if not effect:GetAttribute("ybassft_saved") then
						effect:SetAttribute("ybassft_saved", effect.Enabled)
					end
					effect.Enabled = false
				end
			end
		else
			Lighting.GlobalShadows = true
			for _, effect in ipairs(Lighting:GetChildren()) do
				local saved = effect:GetAttribute("ybassft_saved")
				if saved ~= nil then
					effect.Enabled = saved
					effect:SetAttribute("ybassft_saved", nil)
				end
			end
		end
	end

	local function applyCamera()
		local camera = workspace.CurrentCamera
		if not camera then
			return
		end
		if on("visuals.camera.fov", 70) ~= 70 then
			camera.FieldOfView = on("visuals.camera.fov", 70)
		end
		YBA.player.CameraMaxZoomDistance = on("visuals.camera.zoom", 128)
	end

	local freecamState = nil

	local function freecamStep()
		local camera = workspace.CurrentCamera
		local humanoid = YBA.humanoid()
		if not camera or not humanoid then
			return
		end
		if on("visuals.camera.freecam", false) then
			if not freecamState then
				freecamState = { cframe = camera.CFrame, subject = camera.CameraSubject }
				camera.CameraType = Enum.CameraType.Scriptable
			end
			local speed = 40
			local move = Vector3.new()
			for _, key in ipairs(game:GetService("UserInputService"):GetKeysPressed()) do
				if key.KeyCode == Enum.KeyCode.W then
					move = move + camera.CFrame.LookVector
				elseif key.KeyCode == Enum.KeyCode.S then
					move = move - camera.CFrame.LookVector
				elseif key.KeyCode == Enum.KeyCode.A then
					move = move - camera.CFrame.RightVector
				elseif key.KeyCode == Enum.KeyCode.D then
					move = move + camera.CFrame.RightVector
				elseif key.KeyCode == Enum.KeyCode.Space then
					move = move + Vector3.new(0, 1, 0)
				elseif key.KeyCode == Enum.KeyCode.LeftControl then
					move = move - Vector3.new(0, 1, 0)
				end
			end
			if move.Magnitude > 0 then
				move = move.Unit
			end
			local delta = game:GetService("UserInputService"):GetMouseDelta()
			local yaw = math.rad(-delta.X * 0.15)
			local pitch = math.rad(-delta.Y * 0.15)
			local current = camera.CFrame
			local rotated = current * CFrame.Angles(0, yaw, 0) * CFrame.Angles(pitch, 0, 0)
			camera.CFrame = CFrame.new(current.Position + move * speed * 0.016) * rotated.Rotation
		elseif freecamState then
			camera.CameraType = Enum.CameraType.Custom
			camera.CameraSubject = freecamState.subject or humanoid
			freecamState = nil
		end
	end

	function Visuals.init(store)
		Store = store
		installRemovalHooks()
		RunService.RenderStepped:Connect(function()
			clock = clock + 1
			if clock % 2 == 0 then
				visualTick()
			end
		end)
		RunService.Heartbeat:Connect(function()
			applyLowGfx()
			applyCamera()
			freecamStep()
		end)
		UserInputService.InputBegan:Connect(function(input, processed)
			if processed then
				return
			end
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
				return
			end
			if not on("visuals.players.enabled", false) then
				return
			end
			if not on("combat.target.esp_click", false) then
				return
			end
			local mouse = YBA.player:GetMouse()
			local best, bestDistance = nil, 40
			for _, other in ipairs(game:GetService("Players"):GetPlayers()) do
				if other ~= YBA.player and other.Character then
					local root = YBA.rootOf(other.Character)
					local point, visible = screenPoint(root and root.Position or Vector3.zero)
					if root and point and visible then
						local delta = (Vector2.new(mouse.X, mouse.Y) - point).Magnitude
						if delta < bestDistance then
							best, bestDistance = other.Character, delta
						end
					end
				end
			end
			if best then
				ctx.Target = { model = best, name = best.Name }
				if ctx.Combat and ctx.Combat.setTarget then
					ctx.Combat.setTarget(best)
				end
			end
		end)
	end

	function Visuals.clear()
		clearDrawings()
		for model, highlight in pairs(highlights) do
			highlight:Destroy()
		end
		highlights = {}
	end

	return Visuals
end
