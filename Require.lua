local modules = {}
local threads = {}

local function dewit(module)
	if not threads[module.Name] then
		coroutine.resume(coroutine.create(function()
			threads[module.Name] = require(module)
		end))
	end
end

function _G.require(name)
	local module = modules[name]
	if module then
		print("load module: "..name)
		dewit(module)
		return threads[name]
	else
		print("no module: "..name)
	end
end

for _, object in next, script:GetDescendants() do
	if object:IsA("ModuleScript") then
		modules[object.Name] = object
	end
end

for _, module in next, modules do
	dewit(module)
end

script:Destroy()

return nil