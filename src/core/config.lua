return function(ctx)
	local HttpService = game:GetService("HttpService")

	local Config = {}
	local memory = {}
	local folder = nil

	local function join(...)
		return table.concat({ ... }, "/")
	end

	function Config.init()
		local workspaceDir = type(getworkspace) == "function" and getworkspace() or "."
		folder = join(workspaceDir, "ybassft", "configs")
		if type(makefolder) == "function" then
			pcall(makefolder, folder)
		end
	end

	local function pathOf(name)
		return join(folder or "ybassft/configs", name .. ".json")
	end

	function Config.save(name, data)
		local ok, encoded = pcall(function()
			return HttpService:JSONEncode(data)
		end)
		if not ok then
			return false, "encode failed"
		end
		memory[name] = encoded
		if type(writefile) == "function" then
			local written = pcall(writefile, pathOf(name), encoded)
			if not written then
				return false, "write failed"
			end
		end
		return true
	end

	function Config.load(name)
		local raw = nil
		if type(isfile) == "function" and type(readfile) == "function" then
			local ok, content = pcall(function()
				if isfile(pathOf(name)) then
					return readfile(pathOf(name))
				end
				return nil
			end)
			if ok then
				raw = content
			end
		end
		raw = raw or memory[name]
		if not raw then
			return nil, "not found"
		end
		local ok, decoded = pcall(function()
			return HttpService:JSONDecode(raw)
		end)
		if not ok then
			return nil, "decode failed"
		end
		return decoded
	end

	function Config.delete(name)
		memory[name] = nil
		if type(isfile) == "function" and type(delfile) == "function" then
			pcall(function()
				if isfile(pathOf(name)) then
					delfile(pathOf(name))
				end
			end)
		end
		return true
	end

	function Config.list()
		local found = {}
		if type(listfiles) == "function" and folder then
			local ok, files = pcall(listfiles, folder)
			if ok then
				for _, file in ipairs(files) do
					local name = string.match(file, "([^/\\]+)%.json$")
					if name then
						found[name] = true
					end
				end
			end
		end
		for name in pairs(memory) do
			found[name] = true
		end
		local out = {}
		for name in pairs(found) do
			table.insert(out, name)
		end
		table.sort(out)
		return out
	end

	return Config
end
