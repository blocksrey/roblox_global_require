local once = true

local fetched = {}
local threads = {}

local function try(module)
	if not threads[module.Name] then
		print("thread [create]: "..module.Name)
		coroutine.resume(coroutine.create(function()
			threads[module.Name] = require(module)
		end))
	end
end

function _G.require(name)
	if fetched[name] then
		print("require [twice]: "..name)
	else
		local module = script:FindFirstChild(name, true)
		if module then
			print("require [begin]: "..name)
			try(module)
			fetched[name] = once
			return threads[name]
		else
			print("require [invalid]: "..name)
		end
	end
end

for _, object in next, script:GetDescendants() do
	if object:IsA("ModuleScript") then
		try(object)
	end
end

return nil