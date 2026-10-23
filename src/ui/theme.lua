return function(ctx)
	local Util = ctx.require("core.util")

	local Theme = {}
	local current = "violet"
	local bindings = {}
	local listeners = {}

	Theme.palettes = {
		violet = {
			label = "Violet",
			accent = "#8a79e8",
			accent2 = "#6e5bd4",
			accentSoft = "#181622",
			bg = "#0b0d10",
			panel = "#111317",
			panel2 = "#15171c",
			panel3 = "#191b22",
			border = "#1c1f25",
			borderSoft = "#171a20",
			text = "#d8d9df",
			muted = "#777b87",
			track = "#242631",
		},
		midnight = {
			label = "Midnight",
			accent = "#5b8def",
			accent2 = "#3f6fd4",
			accentSoft = "#121a28",
			bg = "#080b10",
			panel = "#0e1219",
			panel2 = "#12171f",
			panel3 = "#161c26",
			border = "#1a212c",
			borderSoft = "#151b24",
			text = "#d5dbe6",
			muted = "#6f7a8c",
			track = "#1f2733",
		},
		crimson = {
			label = "Crimson",
			accent = "#e8697a",
			accent2 = "#c74b5d",
			accentSoft = "#261317",
			bg = "#0d090b",
			panel = "#141013",
			panel2 = "#181316",
			panel3 = "#1d171b",
			border = "#241b20",
			borderSoft = "#1d1519",
			text = "#e2d5d9",
			muted = "#8b7178",
			track = "#2b2026",
		},
		emerald = {
			label = "Emerald",
			accent = "#4fd1a5",
			accent2 = "#31a883",
			accentSoft = "#0f211c",
			bg = "#080c0b",
			panel = "#0f1413",
			panel2 = "#131918",
			panel3 = "#171f1d",
			border = "#1b2523",
			borderSoft = "#151d1b",
			text = "#d3e0dc",
			muted = "#6d857f",
			track = "#1e2a27",
		},
		amber = {
			label = "Amber",
			accent = "#e8b45d",
			accent2 = "#c4903c",
			accentSoft = "#231b0f",
			bg = "#0c0a07",
			panel = "#131110",
			panel2 = "#171514",
			panel3 = "#1c1917",
			border = "#252019",
			borderSoft = "#1e1a15",
			text = "#e2d9c9",
			muted = "#8b7f68",
			track = "#2a241c",
		},
		gold = {
			label = "JoJo Gold",
			accent = "#d9b64e",
			accent2 = "#a8862f",
			accentSoft = "#1f1a0d",
			bg = "#0a0908",
			panel = "#121009",
			panel2 = "#16130c",
			panel3 = "#1b1710",
			border = "#241f14",
			borderSoft = "#1d1810",
			text = "#e6dcc2",
			muted = "#8c7f5f",
			track = "#292318",
		},
		mono = {
			label = "Mono",
			accent = "#cfd2dc",
			accent2 = "#9a9dab",
			accentSoft = "#1a1c21",
			bg = "#0a0b0d",
			panel = "#101215",
			panel2 = "#14161a",
			panel3 = "#181b1f",
			border = "#20232a",
			borderSoft = "#1a1d23",
			text = "#dcdee4",
			muted = "#787c88",
			track = "#22252b",
		},
	}

	local function palette()
		return Theme.palettes[current]
	end

	for _, entry in pairs(Theme.palettes) do
		entry.icon = entry.icon or "#f6f7fb"
	end

	function Theme.get()
		return current
	end

	function Theme.palette()
		return palette()
	end

	function Theme.color(role)
		local hex = palette()[role] or palette().accent
		return Color3.fromHex(hex)
	end

	function Theme.bind(inst, prop, role)
		local binding = { inst = inst, prop = prop, role = role }
		table.insert(bindings, binding)
		inst[prop] = Theme.color(role)
		return binding
	end

	function Theme.apply(name, animated)
		if not Theme.palettes[name] then
			return
		end
		current = name
		for index = #bindings, 1, -1 do
			local binding = bindings[index]
			if binding.inst.Parent == nil then
				table.remove(bindings, index)
			else
				local target = Theme.color(binding.role)
				if animated == false then
					binding.inst[binding.prop] = target
				else
					Util.tween(binding.inst, 0.22, { [binding.prop] = target })
				end
			end
		end
		for _, fn in ipairs(listeners) do
			task.spawn(fn, current)
		end
	end

	function Theme.onChanged(fn)
		table.insert(listeners, fn)
	end

	return Theme
end
