return function(ctx)
	local Players = game:GetService("Players")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local RunService = game:GetService("RunService")
	local VirtualInputManager = game:GetService("VirtualInputManager")
	local VirtualUser = game:GetService("VirtualUser")
	local UserInputService = game:GetService("UserInputService")

	local YBA = {}
	local player = Players.LocalPlayer

	local standNames = {
		"Star Platinum", "The World", "Killer Queen", "Crazy Diamond", "Gold Experience",
		"King Crimson", "Whitesnake", "C-Moon", "Made in Heaven", "Tusk", "D4C",
		"Soft & Wet", "Gold Experience Requiem", "Star Platinum: The World",
		"The World Over Heaven", "Killer Queen: Bites the Dust", "Silver Chariot",
		"Hierophant Green", "Magician's Red", "The Fool", "Hermit Purple", "Aerosmith",
		"Purple Haze", "Moody Blues", "Sticky Fingers", "Sex Pistols", "Echoes",
		"Stone Free", "Weather Report", "Diver Down", "White Album", "Beach Boy",
		"Man in the Mirror", "Justice", "Hanged Man", "Emperor", "Anubis",
		"Red Hot Chili Pepper", "Harvest", "Cream", "Vanilla Ice", "Scary Monsters",
		"Tusk ACT1", "Tusk ACT2", "Tusk ACT3", "Tusk ACT4", "Dirty Deeds Done Dirt Cheap",
		"King Nothing", "Wonder of U",
	}

	local function hasStandName(name)
		local lower = string.lower(name)
		for _, standName in ipairs(standNames) do
			if string.find(lower, string.lower(standName), 1, true) then
				return true
			end
		end
		return false
	end

	local function humanoidOf(model)
		if not model then
			return nil
		end
		if model:IsA("Humanoid") then
			return model
		end
		return model:FindFirstChildOfClass("Humanoid")
	end

	local function rootOf(model)
		if not model then
			return nil
		end
		if model:IsA("BasePart") then
			return model
		end
		return model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
	end

	YBA.player = player

	function YBA.char()
		return player.Character
	end

	function YBA.humanoid()
		return humanoidOf(player.Character)
	end

	function YBA.root()
		return rootOf(player.Character)
	end

	function YBA.alive(model)
		local humanoid = humanoidOf(model)
		return humanoid ~= nil and humanoid.Health > 0
	end

	function YBA.health(model)
		local humanoid = humanoidOf(model)
		return humanoid and humanoid.Health or 0
	end

	function YBA.maxHealth(model)
		local humanoid = humanoidOf(model)
		return humanoid and humanoid.MaxHealth or 100
	end

	function YBA.distance(a, b)
		local ra, rb = rootOf(a), rootOf(b)
		if not ra or not rb then
			return math.huge
		end
		return (ra.Position - rb.Position).Magnitude
	end

	function YBA.stand()
		local character = player.Character
		if not character then
			return nil
		end
		local direct = character:FindFirstChild("Stand")
		if direct and humanoidOf(direct) then
			return direct
		end
		local myRoot = rootOf(character)
		for _, model in ipairs(workspace:GetChildren()) do
			if model ~= character then
				local humanoid = humanoidOf(model)
				if humanoid and humanoid.Health > 0 then
					local owner = model:GetAttribute("Owner") or model:GetAttribute("Player") or model:GetAttribute("User")
					if owner == player or owner == player.Name then
						return model
					end
					if hasStandName(model.Name) and myRoot then
						local root = rootOf(model)
						if root and (root.Position - myRoot.Position).Magnitude < 60 then
							return model
						end
					end
				end
			end
		end
		return nil
	end

	function YBA.standRoot()
		return rootOf(YBA.stand())
	end

	function YBA.targets(opts)
		opts = opts or {}
		local list = {}
		local includePlayers = opts.players ~= false
		local includeNpcs = opts.npcs == true
		local maxDistance = opts.range or 5000
		if includePlayers then
			for _, other in ipairs(Players:GetPlayers()) do
				if other ~= player and other.Character and YBA.alive(other.Character) then
					local distance = YBA.distance(player.Character, other.Character)
					if distance <= maxDistance then
						table.insert(list, {
							model = other.Character,
							name = other.Name,
							player = other,
							distance = distance,
							health = YBA.health(other.Character),
						})
					end
				end
			end
		end
		if includeNpcs then
			for _, model in ipairs(workspace:GetChildren()) do
				local humanoid = humanoidOf(model)
				if humanoid and humanoid.Health > 0 and not Players:GetPlayerFromCharacter(model) and model ~= player.Character then
					if model ~= YBA.stand() then
						local distance = YBA.distance(player.Character, model)
						if distance <= maxDistance then
							table.insert(list, {
								model = model,
								name = model.Name,
								distance = distance,
								health = humanoid.Health,
								healthMax = humanoid.MaxHealth,
							})
						end
					end
				end
			end
		end
		table.sort(list, function(a, b)
			return a.distance < b.distance
		end)
		return list
	end

	function YBA.bestTarget(opts)
		opts = opts or {}
		local list = YBA.targets(opts)
		if #list == 0 then
			return nil
		end
		local mode = opts.mode or "Nearest"
		if mode == "Lowest health" then
			local best = list[1]
			for _, entry in ipairs(list) do
				if entry.health < best.health then
					best = entry
				end
			end
			return best
		end
		if mode == "Highest health" then
			local best = list[1]
			for _, entry in ipairs(list) do
				if entry.health > best.health then
					best = entry
				end
			end
			return best
		end
		return list[1]
	end

	function YBA.items()
		local folder = workspace:FindFirstChild("Item_Spawns")
		folder = folder and folder:FindFirstChild("Items")
		if not folder then
			return {}
		end
		local list = {}
		for _, model in ipairs(folder:GetChildren()) do
			local root = rootOf(model)
			if root then
				local name = model.Name
				local detector = model:FindFirstChildWhichIsA("ClickDetector", true)
				if detector and detector.Name ~= "ClickDetector" then
					name = detector.Name
				end
				table.insert(list, { model = model, name = name, root = root, distance = YBA.distance(player.Character, model) })
			end
		end
		table.sort(list, function(a, b)
			return a.distance < b.distance
		end)
		return list
	end

	function YBA.click()
		VirtualUser:CaptureController()
		VirtualUser:Button1Down(Vector2.new(0.5, 0.5))
		VirtualUser:Button1Up(Vector2.new(0.5, 0.5))
	end

	local keys = {
		["1"] = Enum.KeyCode.One,
		["2"] = Enum.KeyCode.Two,
		["3"] = Enum.KeyCode.Three,
		["4"] = Enum.KeyCode.Four,
		["5"] = Enum.KeyCode.Five,
		["6"] = Enum.KeyCode.Six,
		Q = Enum.KeyCode.Q,
		E = Enum.KeyCode.E,
		R = Enum.KeyCode.R,
		F = Enum.KeyCode.F,
		C = Enum.KeyCode.C,
		Z = Enum.KeyCode.Z,
		X = Enum.KeyCode.X,
		V = Enum.KeyCode.V,
		B = Enum.KeyCode.B,
		G = Enum.KeyCode.G,
	}

	function YBA.key(name)
		local code = keys[tostring(name)]
		if not code then
			return false
		end
		VirtualInputManager:SendKeyEvent(true, code, false, game)
		task.wait(0.03)
		VirtualInputManager:SendKeyEvent(false, code, false, game)
		return true
	end

	function YBA.keyCode(name)
		local direct = Enum.KeyCode[name]
		return direct or keys[tostring(name)]
	end

	function YBA.teleportTo(part, position, offset)
		local target = part
		if not target then
			return false
		end
		local offsetVector = offset or Vector3.new(0, 0, 0)
		if target:IsA("BasePart") then
			target.CFrame = CFrame.new(position + offsetVector)
		else
			target:PivotTo(CFrame.new(position + offsetVector))
		end
		return true
	end

	function YBA.face(target)
		local stand = YBA.standRoot()
		local root = rootOf(target)
		if stand and root then
			local look = CFrame.lookAt(stand.Position, Vector3.new(root.Position.X, stand.Position.Y, root.Position.Z))
			stand.CFrame = look
		end
	end

	function YBA.firePrompt(model, name)
		local prompt = model:FindFirstChildWhichIsA("ProximityPrompt", true)
		if not prompt then
			return false
		end
		if name and not string.find(string.lower(prompt.ObjectText .. " " .. prompt.ActionText), string.lower(name), 1, true) then
			return false
		end
		fireproximityprompt(prompt)
		return true
	end

	function YBA.remotes()
		if not YBA._remotes then
			local list = {}
			for _, item in ipairs(ReplicatedStorage:GetDescendants()) do
				if item:IsA("RemoteEvent") or item:IsA("RemoteFunction") then
					list[item.Name] = item
				end
			end
			YBA._remotes = list
		end
		return YBA._remotes
	end

	function YBA.remote(name)
		local list = YBA.remotes()
		if list[name] then
			return list[name]
		end
		for key, item in pairs(list) do
			if string.find(string.lower(key), string.lower(name), 1, true) then
				return item
			end
		end
		return nil
	end

	function YBA.standName()
		local stand = YBA.stand()
		if not stand then
			return nil
		end
		local value = stand:GetAttribute("StandName") or stand:GetAttribute("Name")
		if type(value) == "string" and value ~= "" then
			return value
		end
		return stand.Name
	end

	function YBA.walkSpeed(value)
		local humanoid = YBA.humanoid()
		if humanoid then
			humanoid.WalkSpeed = value
		end
	end

	function YBA.jumpPower(value)
		local humanoid = YBA.humanoid()
		if humanoid then
			humanoid.UseJumpPower = true
			humanoid.JumpPower = value
		end
	end

	YBA.standNames = standNames
	YBA.hasStandName = hasStandName
	YBA.rootOf = rootOf
	YBA.humanoidOf = humanoidOf
	YBA.runService = RunService
	YBA.uis = UserInputService

	function YBA.set(list)
		local out = {}
		if type(list) ~= "table" then
			return out
		end
		for key, value in pairs(list) do
			if type(key) == "number" then
				out[value] = true
			elseif value then
				out[key] = true
			end
		end
		return out
	end

	return YBA
end
