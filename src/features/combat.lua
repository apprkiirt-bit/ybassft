return function(ctx)
	local YBA = ctx.require("features.yba")
	local Store = ctx.store
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")

	local Combat = {}
	local clock = 0
	local lastAttack = 0
	local lastClick = 0
	local lastMove = 0
	local lastPilot = 0
	local orbitAngle = 0
	local target = nil

	local abilityKeys = {
		["Barrage"] = "Q",
		["Heavy"] = "E",
		["Special"] = "R",
		["Ultimate"] = "F",
		["M1"] = "1",
		["Ability 1"] = "1",
		["Ability 2"] = "2",
		["Ability 3"] = "3",
		["Ability 4"] = "4",
	}

	local function on(path, fallback)
		return Store.get(path, fallback)
	end

	local function currentTarget()
		if ctx.Target and ctx.Target.model and ctx.Target.model.Parent and YBA.alive(ctx.Target.model) then
			return ctx.Target.model
		end
		local mode = on("combat.stand_attack.target", "Selected")
		if ctx.Target and ctx.Target.model then
			return ctx.Target.model
		end
		local best = YBA.bestTarget({
			players = true,
			npcs = on("combat.aura.targets", "Players") ~= "Players",
			range = math.max(on("combat.stand_attack.range", 18), on("combat.aura.range", 12)) + 40,
			mode = mode,
		})
		return best and best.model or nil
	end

	local function standPilot()
		local stand = YBA.stand()
		local humanoid = YBA.humanoid()
		if not stand or not humanoid then
			return
		end
		local standHumanoid = YBA.humanoidOf(stand)
		local standRoot = YBA.rootOf(stand)
		local root = YBA.root()
		local mode = on("combat.stand_pilot.mode", "Free")
		local distance = on("combat.stand_pilot.distance", 8)

		if not standHumanoid or not standRoot or not root then
			return
		end

		if standHumanoid.Health > 0 then
			if mode == "Orbit" then
				orbitAngle = orbitAngle + 0.03
				local offset = Vector3.new(math.cos(orbitAngle) * distance, 0, math.sin(orbitAngle) * distance)
				standRoot.CFrame = CFrame.new(root.Position + offset, root.Position)
			elseif mode == "Locked" then
				if (standRoot.Position - root.Position).Magnitude > distance + 4 then
					standRoot.CFrame = CFrame.new(root.Position + (humanoid.MoveDirection * distance))
				end
			else
				local offset = humanoid.MoveDirection * distance
				local wanted = root.Position + offset
				if (standRoot.Position - wanted).Magnitude > 0.5 then
					standRoot.CFrame = CFrame.new(wanted, root.Position)
				end
				standHumanoid:Move(humanoid.MoveDirection, false)
			end
			if humanoid:GetState() == Enum.HumanoidStateType.Jumping or humanoid:GetState() == Enum.HumanoidStateType.Freefall then
				standHumanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end

		local camera = workspace.CurrentCamera
		if camera and camera.CameraSubject ~= standHumanoid then
			camera.CameraSubject = standHumanoid
		end
	end

	local function pressKey(key)
		YBA.key(key)
		if key == "Q" then
			ctx.barrageUntil = os.clock() + 3
		end
	end

	local function standAttack()
		local model = currentTarget()
		if not model then
			return
		end
		local stand = YBA.stand()
		local root = YBA.rootOf(stand)
		local targetRoot = YBA.rootOf(model)
		if not root or not targetRoot then
			return
		end
		local range = on("combat.stand_attack.range", 18)
		local distance = (root.Position - targetRoot.Position).Magnitude
		if distance > range then
			root.CFrame = CFrame.new(targetRoot.Position + Vector3.new(0, 0, 4), targetRoot.Position)
		end
		local look = CFrame.lookAt(root.Position, Vector3.new(targetRoot.Position.X, root.Position.Y, targetRoot.Position.Z))
		root.CFrame = look

		local attack = on("combat.stand_attack.attack", "Mixed")
		if attack == "LMB" or attack == "Mixed" then
			YBA.click()
		end
		if attack == "Abilities" or attack == "Mixed" then
			local list = YBA.set(on("combat.stand_attack.abilities", {}))
			local pressed = false
			for name, enabled in pairs(list) do
				if enabled then
					local key = abilityKeys[name]
					if key then
						pressKey(key)
						pressed = true
						task.wait(0.05)
					end
				end
			end
			if not pressed then
				pressKey("Q")
			end
		end
	end

	local function attackAura()
		local mode = on("combat.aura.mode", "M1 only")
		local range = on("combat.aura.range", 12)
		local best = YBA.bestTarget({
			players = on("combat.aura.targets", "Both") ~= "NPC only",
			npcs = on("combat.aura.targets", "Both") ~= "Players only",
			range = range,
			mode = "Nearest",
		})
		if not best then
			return
		end
		YBA.face(best.model)
		if mode == "M1 only" or mode == "Mixed" then
			YBA.click()
		end
		if mode == "Abilities" or mode == "Mixed" then
			pressKey("Q")
		end
	end

	local function fastM1()
		YBA.click()
	end

	local function hitbox()
		local stand = YBA.stand()
		if not stand then
			return
		end
		local range = on("combat.hitbox.range", 20)
		for _, part in ipairs(stand:GetDescendants()) do
			if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
				if not part:GetAttribute("ybassft_hitbox") then
					part:SetAttribute("ybassft_hitbox", part.Size.Magnitude)
				end
				part.Size = Vector3.new(range / 4, range / 4, range / 4)
			end
		end
	end

	local function resetHitbox()
		local stand = YBA.stand()
		if not stand then
			return
		end
		for _, part in ipairs(stand:GetDescendants()) do
			local stored = part:GetAttribute("ybassft_hitbox")
			if stored then
				part:SetAttribute("ybassft_hitbox", nil)
			end
		end
	end

	local function movestack()
		local first = on("combat.movestack.ability_a", "Barrage")
		local second = on("combat.movestack.ability_b", "Heavy")
		local delay = on("combat.movestack.stack_delay", 0.04)
		local keyA = abilityKeys[first] or "Q"
		local keyB = abilityKeys[second] or "E"
		YBA.key(keyA)
		task.wait(delay)
		YBA.key(keyB)
	end

	local function rotation()
		local preset = on("combat.rotation.preset", "Barrage combo")
		local list = YBA.set(on("combat.rotation.steps", {}))
		local delay = on("combat.rotation.step_delay", 0.25)
		local steps = {}
		for name, enabled in pairs(list) do
			if enabled then
				table.insert(steps, abilityKeys[name] or "1")
			end
		end
		if #steps == 0 then
			if preset == "Heavy combo" then
				steps = { "E", "Q", "R" }
			else
				steps = { "Q", "E", "R", "F" }
			end
		end
		table.sort(steps)
		local model = currentTarget()
		if model then
			YBA.face(model)
		end
		for _, key in ipairs(steps) do
			YBA.key(key)
			task.wait(delay)
		end
	end

	local function tick(dt)
		clock = clock + dt
		if on("combat.stand_pilot.enabled", false) then
			if clock - lastPilot >= 0.03 then
				lastPilot = clock
				standPilot()
			end
		else
			local camera = workspace.CurrentCamera
			local humanoid = YBA.humanoid()
			if camera and humanoid and camera.CameraSubject ~= humanoid then
				camera.CameraSubject = humanoid
			end
		end
		if on("combat.stand_attack.enabled", false) then
			if clock - lastAttack >= on("combat.stand_attack.delay", 0.15) then
				lastAttack = clock
				standAttack()
			end
		end
		if on("combat.aura.enabled", false) then
			if clock - lastMove >= on("combat.aura.delay", 0.12) then
				lastMove = clock
				attackAura()
			end
		end
		if on("combat.fast_m1.enabled", false) then
			if clock - lastClick >= on("combat.fast_m1.click_delay", 0.06) then
				lastClick = clock
				fastM1()
			end
		end
		if on("combat.hitbox.enabled", false) then
			hitbox()
		elseif ctx.hitboxActive then
			resetHitbox()
		end
		ctx.hitboxActive = on("combat.hitbox.enabled", false)
		if on("combat.movestack.enabled", false) and on("combat.movestack.hold", true) then
			if clock - (ctx.lastStack or 0) >= on("combat.movestack.stack_delay", 0.04) + 0.3 then
				ctx.lastStack = clock
				movestack()
			end
		end
	end

	function Combat.trigger(id)
		if id == "combat.movestack" then
			movestack()
		elseif id == "combat.rotation" then
			rotation()
		end
	end

	function Combat.init(store)
		Store = store
		if ctx.onKey then
			ctx.onKey("combat.movestack.stack_key", function()
				movestack()
			end)
			ctx.onKey("combat.rotation.rotation_key", function()
				rotation()
			end)
			ctx.onKey("combat.stand_pilot.toggle_key", function()
				Store.set("combat.stand_pilot.enabled", not Store.get("combat.stand_pilot.enabled", false))
			end)
			ctx.onKey("combat.stand_attack.toggle_key", function()
				Store.set("combat.stand_attack.enabled", not Store.get("combat.stand_attack.enabled", false))
			end)
			ctx.onKey("combat.aura.aura_key", function()
				Store.set("combat.aura.enabled", not Store.get("combat.aura.enabled", false))
			end)
			ctx.onKey("combat.fast_m1.m1_key", function()
				Store.set("combat.fast_m1.enabled", not Store.get("combat.fast_m1.enabled", false))
			end)
		end
		RunService.Heartbeat:Connect(tick)
	end

	Combat.setTarget = function(model)
		target = model
		ctx.Target = { model = model, name = model and model.Name or nil }
	end

	return Combat
end
