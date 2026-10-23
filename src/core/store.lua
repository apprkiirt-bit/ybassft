return function(ctx)
	local Signal = ctx.require("core.signal")

	local Store = {}
	local state = {}
	local changed = Signal.new()
	local anyChanged = Signal.new()

	Store.Changed = changed
	Store.AnyChanged = anyChanged

	local function copy(value)
		if type(value) ~= "table" then
			return value
		end
		local out = {}
		for key, item in pairs(value) do
			out[key] = copy(item)
		end
		return out
	end

	local function navigate(create, path)
		local node = state
		local key = nil
		for part in string.gmatch(path, "[^%.]+") do
			if key then
				if node[key] == nil then
					if not create then
						return nil, nil
					end
					node[key] = {}
				end
				node = node[key]
				if type(node) ~= "table" then
					return nil, nil
				end
			end
			key = part
		end
		return node, key
	end

	function Store.get(path, fallback)
		local node, key = navigate(false, path)
		if node == nil or key == nil then
			return fallback
		end
		local value = node[key]
		if value == nil then
			return fallback
		end
		return value
	end

	function Store.set(path, value)
		local node, key = navigate(true, path)
		if node[key] == value then
			return value
		end
		node[key] = value
		changed:Fire(path, value)
		anyChanged:Fire(path, value)
		return value
	end

	function Store.toggle(path)
		Store.set(path, not Store.get(path, false))
		return Store.get(path, false)
	end

	function Store.on(path, fn)
		return changed:Connect(function(changedPath, value)
			if changedPath == path then
				fn(value)
			end
		end)
	end

	function Store.snapshot()
		return copy(state)
	end

	function Store.loadDefaults(defaults)
		local function fill(node, defaultsNode)
			for key, value in pairs(defaultsNode) do
				if type(value) == "table" and type(node[key]) == "table" then
					fill(node[key], value)
				elseif node[key] == nil then
					node[key] = copy(value)
				end
			end
		end
		fill(state, defaults)
	end

	function Store.setRaw(tbl)
		state = tbl or {}
	end

	function Store.raw()
		return state
	end

	return Store
end
