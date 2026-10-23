return function(ctx)
	local Signal = {}
	Signal.__index = Signal

	local Connection = {}
	Connection.__index = Connection

	function Connection.new(signal, fn)
		return setmetatable({ signal = signal, fn = fn, connected = true }, Connection)
	end

	function Connection:Disconnect()
		if not self.connected then
			return
		end
		self.connected = false
		local list = self.signal.listeners
		for index = #list, 1, -1 do
			if list[index] == self then
				table.remove(list, index)
			end
		end
	end

	function Connection:Get()
		return self.connected
	end

	function Signal.new()
		return setmetatable({ listeners = {} }, Signal)
	end

	function Signal:Connect(fn)
		local connection = Connection.new(self, fn)
		table.insert(self.listeners, connection)
		return connection
	end

	function Signal:Once(fn)
		local connection
		connection = self:Connect(function(...)
			connection:Disconnect()
			fn(...)
		end)
		return connection
	end

	function Signal:Fire(...)
		local snapshot = table.clone and table.clone(self.listeners) or self.listeners
		for _, connection in ipairs(snapshot) do
			task.spawn(connection.fn, ...)
		end
	end

	function Signal:DisconnectAll()
		for _, connection in ipairs(self.listeners) do
			connection.connected = false
		end
		table.clear(self.listeners)
	end

	return Signal
end
