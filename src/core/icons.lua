return function(ctx)
	local Icons = {}
	local cache = {}
	local names = {}
	local folder = nil

	local function join(...)
		local parts = { ... }
		return table.concat(parts, "/")
	end

	local function ensureFolder(path)
		if type(makefolder) ~= "function" then
			return false
		end
		local current = ""
		for part in string.gmatch(path, "[^/]+") do
			if current == "" then
				current = part
			else
				current = join(current, part)
			end
			local exists = type(isfolder) == "function" and isfolder(current)
			if not exists then
				makefolder(current)
			end
		end
		return true
	end

	function Icons.setup(base, assetBase)
		Icons.base = base
		Icons.assetBase = assetBase
		local workspaceDir = type(getworkspace) == "function" and getworkspace() or "."
		folder = join(workspaceDir, "ybassft", "assets", "icons")
		if type(makefolder) == "function" then
			pcall(ensureFolder, join(workspaceDir, "ybassft", "assets", "icons"))
		end
	end

	function Icons.known(name)
		return names[name] == true
	end

	local function resolve(name)
		if cache[name] ~= nil then
			return cache[name]
		end
		if type(getcustomasset) ~= "function" then
			cache[name] = ""
			return ""
		end
		local path = join(folder, name .. ".png")
		local ok, asset = pcall(function()
			if type(isfile) == "function" and isfile(path) then
				return getcustomasset(path)
			end
			if type(writefile) ~= "function" or type(game.HttpGet) ~= "function" then
				return nil
			end
			local body = game:HttpGet(join(Icons.assetBase, name .. ".png"))
			if type(body) ~= "string" or #body < 64 then
				return nil
			end
			writefile(path, body)
			return getcustomasset(path)
		end)
		if not ok or not asset or asset == "" then
			cache[name] = ""
			return ""
		end
		names[name] = true
		cache[name] = asset
		return asset
	end

	function Icons.get(name)
		if not name then
			return ""
		end
		return resolve(tostring(name))
	end

	return Icons
end
