local once = true

local modules = {}
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
		local module = modules[name]
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
		modules[object.Name] = object
	end
end

for _, module in next, modules do
	try(module)
end

_G.require = nil
--script:Destroy()

return nil
