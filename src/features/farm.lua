return function(ctx)
	local YBA = ctx.require("features.yba")
	local Store = ctx.store
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")

	local Farm = {}
	local clock = 0
	local lastAttack = 0
	local lastSell = 0
	local lastBuy = 0
	local lastRoll = 0
	local lastCollect = 0
	local lastQuest = 0
	local lastCycle = 0
	local kills = 0
	local cycles = 0
	local moneyStart = nil
	local moneyTime = nil
	local currentTarget = nil
	local rollStage = "arrow"

	local function on(path, fallback)
		return Store.get(path, fallback)
	end

	local function money()
		local stats = YBA.player:FindFirstChild("leaderstats")
		if not stats then
			return nil
		end
		for _, key in ipairs({ "Cash", "Money", "Yen", "Coins" }) do
			local value = stats:FindFirstChild(key)
			if value then
				return value.Value
			end
		end
		return nil
	end

	local function moneyPerHour()
		local now = os.clock()
		local value = money()
		if value == nil then
			return 0
		end
		if moneyStart == nil then
			moneyStart = value
			moneyTime = now
			return 0
		end
		local hours = (now - moneyTime) / 3600
		if hours < 0.001 then
			return 0
		end
		return math.floor((value - moneyStart) / hours)
	end

	local function findMerchant()
		for _, model in ipairs(workspace:GetChildren()) do
			local lower = string.lower(model.Name)
			if string.find(lower, "merchant", 1, true) or string.find(lower, "shop", 1, true) or string.find(lower, "vendor", 1, true) then
				return model
			end
		end
		return nil
	end

	local function skipDialogue()
		if not on("farm.dialogue.enabled", true) then
			return
		end
		local remote = YBA.remote("Dialogue")
		if remote and remote:IsA("RemoteEvent") then
			pcall(function()
				remote:FireServer("Continue")
			end)
		end
		local gui = YBA.player:FindFirstChild("PlayerGui")
		if gui then
			for _, element in ipairs(gui:GetDescendants()) do
				if element:IsA("TextButton") and element.Visible then
					local text = string.lower(element.Text)
					if text == "continue" or text == "next" or text == "ok" or text == "accept" then
						pcall(function()
							element:Activate()
						end)
					end
				end
			end
		end
	end

	local function farmTarget()
		if on("farm.autofarm.tp", true) then
			local best = YBA.bestTarget({
				players = false,
				npcs = true,
				range = on("farm.autofarm.radius", 900),
				mode = on("farm.autofarm.priority", "Nearest"),
			})
			if best then
				currentTarget = best.model
			end
		end
		if not currentTarget or not currentTarget.Parent or not YBA.alive(currentTarget) then
			currentTarget = nil
			cycles = cycles + 1
			lastCycle = os.clock()
			return
		end
		local standRoot = YBA.standRoot()
		local targetRoot = YBA.rootOf(currentTarget)
		if not standRoot or not targetRoot then
			return
		end
		if on("farm.autofarm.tp", true) then
			standRoot.CFrame = CFrame.new(targetRoot.Position + Vector3.new(0, 0, 3), targetRoot.Position)
		end
		YBA.face(currentTarget)
		local attack = on("farm.autofarm.attack", "M1")
		if attack == "M1" or attack == "Mixed" then
			YBA.click()
		end
		if attack == "Abilities" or attack == "Mixed" then
			YBA.key("Q")
			task.wait(0.05)
			YBA.key("E")
		end
		if YBA.health(currentTarget) <= 0 then
			kills = kills + 1
			currentTarget = nil
		end
	end

	local function itemByName(name)
		for _, entry in ipairs(YBA.items()) do
			if string.find(string.lower(entry.name), string.lower(name), 1, true) then
				return entry
			end
		end
		return nil
	end

	local function autoCollect()
		local wanted = YBA.set(on("farm.collect.items", { "Roka", "Arrow", "Diary" }))
		local maxDistance = on("farm.collect.max_distance", 400)
		for _, entry in ipairs(YBA.items()) do
			if entry.distance <= maxDistance then
				local match = false
				for name, enabled in pairs(wanted) do
					if enabled and string.find(string.lower(entry.name), string.lower(name), 1, true) then
						match = true
					end
				end
				if match then
					local root = YBA.root()
					if root and on("farm.collect.tp", true) then
						root.CFrame = CFrame.new(entry.root.Position + Vector3.new(0, 3, 0))
					end
					local prompt = entry.model:FindFirstChildWhichIsA("ProximityPrompt", true)
					if prompt then
						pcall(function()
							fireproximityprompt(prompt)
						end)
					end
					local detector = entry.model:FindFirstChildWhichIsA("ClickDetector", true)
					if detector then
						pcall(function()
							fireclickdetector(detector)
						end)
					end
					return
				end
			end
		end
	end

	local function autoSell()
		local merchant = findMerchant()
		if not merchant then
			return
		end
		local root = YBA.root()
		local merchantRoot = YBA.rootOf(merchant)
		if root and merchantRoot then
			root.CFrame = CFrame.new(merchantRoot.Position + Vector3.new(0, 3, 4))
		end
		YBA.firePrompt(merchant)
		skipDialogue()
		local remote = YBA.remote("Sell")
		if remote and remote:IsA("RemoteEvent") then
			pcall(function()
				remote:FireServer("All")
			end)
		end
	end

	local function autoBuy()
		local merchant = findMerchant()
		if not merchant then
			return
		end
		local wanted = YBA.set(on("farm.buy.items", { "Lucky Arrow", "Roka" }))
		local root = YBA.root()
		local merchantRoot = YBA.rootOf(merchant)
		if root and merchantRoot then
			root.CFrame = CFrame.new(merchantRoot.Position + Vector3.new(0, 3, 4))
		end
		YBA.firePrompt(merchant)
		skipDialogue()
		local remote = YBA.remote("Buy")
		if remote and remote:IsA("RemoteEvent") then
			for name, enabled in pairs(wanted) do
				if enabled then
					pcall(function()
						remote:FireServer(name)
					end)
				end
			end
		end
	end

	local function findTool(pattern)
		local backpack = YBA.player:FindFirstChild("Backpack")
		local character = YBA.char()
		for _, container in ipairs({ backpack, character }) do
			if container then
				for _, tool in ipairs(container:GetChildren()) do
					if tool:IsA("Tool") and string.find(string.lower(tool.Name), string.lower(pattern), 1, true) then
						return tool
					end
				end
			end
		end
		return nil
	end

	local function autoRoll()
		local whitelist = YBA.set(on("farm.roll.whitelist", {}))
		local stopOnRare = on("farm.roll.stop_rare", true)
		local currentStand = YBA.standName() or ""
		local keep = false
		for name, enabled in pairs(whitelist) do
			if enabled and string.find(string.lower(currentStand), string.lower(name), 1, true) then
				keep = true
			end
		end
		if keep and stopOnRare then
			Store.set("farm.roll.enabled", false)
			return
		end
		if rollStage == "arrow" then
			local arrow = findTool("arrow")
			if arrow then
				pcall(function()
					arrow:Activate()
				end)
				rollStage = "check"
				task.wait(on("farm.roll.delay", 2))
			end
		else
			local roka = findTool("roka")
			if roka then
				pcall(function()
					roka:Activate()
				end)
			end
			rollStage = "arrow"
		end
	end

	local function autoQuest()
		for _, model in ipairs(workspace:GetChildren()) do
			local lower = string.lower(model.Name)
			if string.find(lower, "quest", 1, true) or string.find(lower, "npc", 1, true) then
				local root = YBA.root()
				local npcRoot = YBA.rootOf(model)
				if root and npcRoot and YBA.distance(YBA.player.Character, model) > 12 then
					root.CFrame = CFrame.new(npcRoot.Position + Vector3.new(0, 3, 4))
				end
				YBA.firePrompt(model)
				skipDialogue()
				return
			end
		end
	end

	local function updateHud()
		if ctx.HUD then
			ctx.HUD.setStatus("farm", string.format("%d kills · %s/h", kills, moneyPerHour()))
			ctx.HUD.setStatus("target", currentTarget and currentTarget.Name or "no target")
		end
	end

	local function tick(dt)
		clock = clock + dt
		if on("farm.autofarm.enabled", false) then
			if clock - lastAttack >= on("farm.autofarm.delay", 0.2) then
				lastAttack = clock
				farmTarget()
			end
		end
		if on("farm.collect.enabled", false) and clock - lastCollect >= on("farm.collect.delay", 0.8) then
			lastCollect = clock
			autoCollect()
		end
		if on("farm.sell.enabled", false) and clock - lastSell >= on("farm.sell.interval", 20) then
			lastSell = clock
			autoSell()
		end
		if on("farm.buy.enabled", false) and clock - lastBuy >= on("farm.buy.interval", 10) then
			lastBuy = clock
			autoBuy()
		end
		if on("farm.roll.enabled", false) and clock - lastRoll >= on("farm.roll.delay", 2) then
			lastRoll = clock
			autoRoll()
		end
		if on("farm.quest.enabled", false) and clock - lastQuest >= on("farm.quest.delay", 3) then
			lastQuest = clock
			autoQuest()
		end
		if clock % 1 < 0.05 then
			updateHud()
		end
	end

	function Farm.stats()
		return {
			kills = kills,
			cycles = cycles,
			moneyPerHour = moneyPerHour(),
			lastCycle = lastCycle > 0 and (os.clock() - lastCycle) or 0,
		}
	end

	function Farm.resetStats()
		kills = 0
		cycles = 0
		moneyStart = money()
		moneyTime = os.clock()
	end

	function Farm.init(store)
		Store = store
		moneyStart = money()
		moneyTime = os.clock()
		RunService.Heartbeat:Connect(tick)
		if ctx.onKey then
			ctx.onKey("farm.autofarm.farm_key", function()
				Store.set("farm.autofarm.enabled", not Store.get("farm.autofarm.enabled", false))
			end)
			ctx.onKey("farm.roll.roll_key", function()
				Store.set("farm.roll.enabled", not Store.get("farm.roll.enabled", false))
			end)
		end
	end

	return Farm
end
