return function(ctx)
	local TweenService = game:GetService("TweenService")

	local U = {}

	local FONTS = {
		body = Enum.Font.Gotham,
		medium = Enum.Font.GothamMedium,
		bold = Enum.Font.GothamBold,
		mono = Enum.Font.Code,
	}
	U.Fonts = FONTS

	function U.hex(str, alpha)
		local c = Color3.fromHex(str)
		if alpha then
			return Color3.new(c.R, c.G, c.B)
		end
		return c
	end

	function U.create(class, props, children)
		local inst = Instance.new(class)
		local parent = nil
		if props then
			for key, value in pairs(props) do
				if key == "Parent" then
					parent = value
				else
					inst[key] = value
				end
			end
		end
		if children then
			for _, child in ipairs(children) do
				child.Parent = inst
			end
		end
		if parent then
			inst.Parent = parent
		end
		return inst
	end

	function U.tween(inst, seconds, goals, style, dir)
		local info = TweenInfo.new(
			seconds or 0.18,
			style or Enum.EasingStyle.Quad,
			dir or Enum.EasingDirection.Out
		)
		local tw = TweenService:Create(inst, info, goals)
		tw:Play()
		return tw
	end

	function U.corner(radius)
		return U.create("UICorner", { CornerRadius = UDim.new(0, radius or 8) })
	end

	function U.stroke(color, thickness, transparency)
		return U.create("UIStroke", {
			Color = color or Color3.fromRGB(28, 31, 37),
			Thickness = thickness or 1,
			Transparency = transparency or 0,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		})
	end

	function U.padding(px, top)
		return U.create("UIPadding", {
			PaddingTop = UDim.new(0, top or px),
			PaddingBottom = UDim.new(0, px),
			PaddingLeft = UDim.new(0, px),
			PaddingRight = UDim.new(0, px),
		})
	end

	function U.list(props)
		local cfg = { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }
		if props then
			for key, value in pairs(props) do
				cfg[key] = value
			end
		end
		return U.create("UIListLayout", cfg)
	end

	function U.hlist(props)
		local cfg = {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, 6),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		}
		if props then
			for key, value in pairs(props) do
				cfg[key] = value
			end
		end
		return U.create("UIListLayout", cfg)
	end

	function U.gradient(a, b, rotation)
		return U.create("UIGradient", {
			Color = ColorSequence.new(a, b),
			Rotation = rotation or 55,
		})
	end

	function U.round(num, decimals)
		local mult = 10 ^ (decimals or 0)
		return math.floor(num * mult + 0.5) / mult
	end

	function U.clamp(value, min, max)
		if value < min then
			return min
		end
		if value > max then
			return max
		end
		return value
	end

	function U.lerp(a, b, t)
		return a + (b - a) * t
	end

	function U.deepCopy(tbl)
		if type(tbl) ~= "table" then
			return tbl
		end
		local out = {}
		for key, value in pairs(tbl) do
			out[key] = U.deepCopy(value)
		end
		return out
	end

	function U.merge(target, source)
		for key, value in pairs(source) do
			if type(value) == "table" and type(target[key]) == "table" then
				U.merge(target[key], value)
			else
				target[key] = value
			end
		end
		return target
	end

	function U.formatNumber(value)
		if value >= 1e6 then
			return string.format("%.1fM", value / 1e6)
		end
		if value >= 1e3 then
			return string.format("%.1fk", value / 1e3)
		end
		return tostring(math.floor(value))
	end

	function U.now()
		return os.clock()
	end

	return U
end
