return function(ctx)
	local YBA = ctx.require("features.yba")
	local Store = ctx.store
	local RunService = game:GetService("RunService")
	local UserInputService = game:GetService("UserInputService")

	local Movement = {}
	local clock = 0
	local lastDash = 0
	local bodyVelocity = nil
	local bodyGyro = nil
	local waypoints = {}
	local previousSpeed = nil
	local previousJump = nil

	local function on(path, fallback)
		return Store.get(path, fallback)
	end

	local function setSpeed(value)
		local humanoid = YBA.humanoid()
		if humanoid then
			humanoid.WalkSpeed = value
		end
	end

	local function flyStep(dt)
		local root = YBA.root()
		local humanoid = YBA.humanoid()
		if not root or not humanoid then
			return
		end
		local speed = on("movement.fly.speed", 70)
		local vertical = on("movement.fly.vertical", 50)
		local camera = workspace.CurrentCamera
		if not camera then
			return
		end
		local move = Vector3.new()
		local state = UserInputService:GetKeysPressed()
		for _, key in ipairs(state) do
			if key.KeyCode == Enum.KeyCode.W then
				move = move + camera.CFrame.LookVector
			elseif key.KeyCode == Enum.KeyCode.S then
				move = move - camera.CFrame.LookVector
			elseif key.KeyCode == Enum.KeyCode.A then
				move = move - camera.CFrame.RightVector
			elseif key.KeyCode == Enum.KeyCode.D then
				move = move + camera.CFrame.RightVector
			elseif key.KeyCode == Enum.KeyCode.Space then
				move = move + Vector3.new(0, vertical / speed, 0)
			elseif key.KeyCode == Enum.KeyCode.LeftControl then
				move = move - Vector3.new(0, vertical / speed, 0)
			end
		end
		if move.Magnitude > 0 then
			move = move.Unit
		end
		root.CFrame = root.CFrame + move * speed * dt
		root.Velocity = Vector3.new(0, 0, 0)
	end

	local function startFly()
		local root = YBA.root()
		if not root then
			return
		end
		bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
		bodyVelocity.Velocity = Vector3.new(0, 0, 0)
		bodyVelocity.Parent = root
		bodyGyro = Instance.new("BodyGyro")
		bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
		bodyGyro.P = 3000
		bodyGyro.Parent = root
	end

	local function stopFly()
		if bodyVelocity then
			bodyVelocity:Destroy()
			bodyVelocity = nil
		end
		if bodyGyro then
			bodyGyro:Destroy()
			bodyGyro = nil
		end
	end

	local function noclipStep()
		local character = YBA.char()
		if not character then
			return
		end
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end

	local function infiniteJump()
		local humanoid = YBA.humanoid()
		if not humanoid then
			return
		end
		if humanoid:GetState() == Enum.HumanoidStateType.Freefall or humanoid:GetState() == Enum.HumanoidStateType.Jumping then
			humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end

	local function autoDash()
		local root = YBA.root()
		local humanoid = YBA.humanoid()
		if not root or not humanoid then
			return
		end
		local direction = humanoid.MoveDirection
		if direction.Magnitude > 0.1 then
			local velocity = Instance.new("BodyVelocity")
			velocity.MaxForce = Vector3.new(1e5, 0, 1e5)
			velocity.Velocity = direction * on("movement.dash.power", 90)
			velocity.Parent = root
			task.delay(0.15, function()
				velocity:Destroy()
			end)
		end
	end

	local function applySpeed()
		local humanoid = YBA.humanoid()
		if not humanoid then
			return
		end
		if on("movement.speed.enabled", false) then
			if previousSpeed == nil then
				previousSpeed = humanoid.WalkSpeed
			end
			if on("movement.speed.mode", "WalkSpeed") == "HipHeight" then
				humanoid.HipHeight = on("movement.speed.speed", 80) / 40
			else
				humanoid.WalkSpeed = on("movement.speed.speed", 60)
			end
		elseif previousSpeed then
			humanoid.WalkSpeed = previousSpeed
			previousSpeed = nil
		end
	end

	local function applyJump()
		local humanoid = YBA.humanoid()
		if not humanoid then
			return
		end
		if on("movement.jump.enabled", false) then
			if previousJump == nil then
				previousJump = humanoid.JumpPower
			end
			humanoid.UseJumpPower = true
			humanoid.JumpPower = on("movement.jump.power", 90)
			if on("movement.jump.infinite", true) and clock - (ctx.lastJump or 0) > 0.12 then
				ctx.lastJump = clock
				infiniteJump()
			end
		elseif previousJump then
			humanoid.JumpPower = previousJump
			previousJump = nil
		end
	end

	local function tick(dt)
		clock = clock + dt
		applySpeed()
		applyJump()
		if on("movement.fly.enabled", false) then
			if not bodyVelocity then
				startFly()
			end
			flyStep(dt)
		elseif bodyVelocity then
			stopFly()
		end
		if on("movement.noclip.enabled", false) then
			noclipStep()
		end
		if on("movement.dash.enabled", false) and clock - lastDash > on("movement.dash.cooldown", 0.6) then
			lastDash = clock
			autoDash()
		end
	end

	local function teleport(position)
		local root = YBA.root()
		if root then
			root.CFrame = CFrame.new(position)
		end
	end

	function Movement.saveWaypoint(name)
		local root = YBA.root()
		if not root or not name then
			return
		end
		waypoints[name] = root.Position
		Store.set("movement.waypoints.list", waypoints)
	end

	function Movement.teleportToWaypoint(name)
		local position = waypoints[name]
		if position then
			teleport(position)
		end
	end

	function Movement.deleteWaypoint(name)
		waypoints[name] = nil
		Store.set("movement.waypoints.list", waypoints)
	end

	function Movement.teleportToPlayer(playerName)
		for _, other in ipairs(game:GetService("Players"):GetPlayers()) do
			if other.Name == playerName and other.Character then
				local root = YBA.rootOf(other.Character)
				if root then
					teleport(root.Position + Vector3.new(0, 3, 0))
				end
				return
			end
		end
	end

	function Movement.teleportToCursor()
		local mouse = YBA.player:GetMouse()
		if mouse and mouse.Hit then
			teleport(mouse.Hit.Position + Vector3.new(0, 3, 0))
		end
	end

	function Movement.init(store)
		Store = store
		local saved = Store.get("movement.waypoints.list", {})
		if type(saved) == "table" then
			waypoints = saved
		end
		RunService.Heartbeat:Connect(tick)
	end

	Movement.waypoints = function()
		return waypoints
	end
	Movement.teleport = teleport
	Movement.stopFly = stopFly

	return Movement
end
