return function(ctx)
	local YBA = ctx.require("features.yba")
	local Store = ctx.store
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")

	local Protection = {}
	local lastSafe = nil
	local savedSpeed = nil
	local clock = 0
	local lastReturn = 0

	local function on(path, fallback)
		return Store.get(path, fallback)
	end

	local function safePosition()
		local root = YBA.root()
		if root and root.Position.Magnitude > 5 and root.Position.Y > -20 then
			return root.CFrame
		end
		return nil
	end

	local function restore(cframe)
		local root = YBA.root()
		if root and cframe then
			root.CFrame = cframe
		end
	end

	local function antiVoid()
		local root = YBA.root()
		if not root then
			return
		end
		if root.Position.Y < on("protection.anti_void.threshold", -50) then
			if clock - lastReturn > 1 then
				lastReturn = clock
				restore(lastSafe or CFrame.new(0, 20, 0))
			end
		end
	end

	local function antiGer()
		local root = YBA.root()
		if not root then
			return
		end
		if root.Position.Magnitude < 3 and lastSafe then
			restore(lastSafe)
		end
	end

	local function antiStun()
		local character = YBA.char()
		local humanoid = YBA.humanoid()
		if not character or not humanoid then
			return
		end
		if humanoid.PlatformStand then
			humanoid.PlatformStand = false
		end
		for _, state in ipairs({ Enum.HumanoidStateType.FallingDown, Enum.HumanoidStateType.Ragdoll, Enum.HumanoidStateType.PlatformStanding }) do
			if humanoid:GetState() == state then
				humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
			end
		end
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BallSocketConstraint") and part.Enabled then
				part.Enabled = false
			end
		end
	end

	local function antiSlow()
		local humanoid = YBA.humanoid()
		if not humanoid then
			return
		end
		if savedSpeed == nil then
			savedSpeed = humanoid.WalkSpeed
		end
		local floor = on("protection.anti_slow.minimum", 16)
		if humanoid.WalkSpeed < floor then
			humanoid.WalkSpeed = math.max(savedSpeed, floor)
		end
	end

	local function antiTimeStop()
		local camera = workspace.CurrentCamera
		local humanoid = YBA.humanoid()
		if not camera or not humanoid then
			return
		end
		if camera.CameraSubject ~= humanoid then
			local subject = camera.CameraSubject
			if subject and subject:IsA("Humanoid") then
				local model = subject.Parent
				if not Players:GetPlayerFromCharacter(model) then
					camera.CameraSubject = humanoid
				end
			else
				camera.CameraSubject = humanoid
			end
		end
		if humanoid.WalkSpeed < 1 and on("protection.anti_slow.enabled", false) then
			humanoid.WalkSpeed = 16
		end
	end

	local function antiTimeErase()
		local character = YBA.char()
		if not character then
			return
		end
		local humanoid = YBA.humanoid()
		if humanoid and humanoid.Health > 0 and character.Parent == workspace then
			if character:GetAttribute("TimeErased") then
				character:SetAttribute("TimeErased", nil)
			end
		end
	end

	local function tick(dt)
		clock = clock + dt
		local safe = safePosition()
		if safe then
			lastSafe = safe
		end
		if on("protection.anti_void.enabled", true) then
			antiVoid()
		end
		if on("protection.anti_ger.enabled", false) then
			antiGer()
		end
		if on("protection.anti_stun.enabled", false) then
			antiStun()
		end
		if on("protection.anti_slow.enabled", false) then
			antiSlow()
		end
		if on("protection.anti_ts.enabled", false) then
			antiTimeStop()
		end
		if on("protection.anti_erase.enabled", false) then
			antiTimeErase()
		end
	end

	function Protection.init(store)
		Store = store
		RunService.Heartbeat:Connect(tick)
	end

	return Protection
end
