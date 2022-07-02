os.loadAPI("test/buttonApi")
os.loadAPI("test/mobApi")

local drawerController = peripheral.wrap("functionalstorage:storage_controller_0")
local mobs = {}

function genFunction()
	local func = function(redstoneIntegrator, face) peripheral.call(redstoneIntegrator, "setOutput", face, not peripheral.call(redstoneIntegrator, "getOutput", face)) end
	return func
end

function checkItemLevels(storageController, mobs, t)
	for _, mob in ipairs(mobs) do
		local states = {}
		local temp
		for _, drop in ipairs(mob.dropsWanted) do
			local item = storageController.getItemDetail(item.inventorySlot)
			if item.count <= drop.quantity and not t:getActive(mob.buttonName) then
				table.insert(states, true)
			elseif item.count > drop.quantity and t:getActive(mob.buttonName) then
				table.insert(state, false)
			end
		end
		if not t:getActive(mob.buttonName) then
			temp = false
			for _, state in ipairs(states) do temp = temp or state end
			if temp then t:onClick(mob.buttonName, mob.redstoneIntegrator, "front") end
		else
			temp = true
			for _, state in ipairs(states) do temp = temp and state end
			if not temp then t:onClick(mob.button, mob.redstoneIntegrator, "front") end
		end
	end
end

table.insert(mobs,mobApi.Mob:new("Blaze", "Blaze", "redstoneIntegrator_6", { mobApi.Drop:new("minecraft:blaze_rod", 0, 3000) }))
table.insert(mobs,mobApi.Mob:new("Wither Skeleton",	"W Skel","redstoneIntegrator_7",{ mobApi.Drop:new("minecraft:wither_skeleton_skull", 0, 100) }))
table.insert(mobs, mobApi.Mob:new("Enderman", "Ender", "redstoneIntegrator_8", { mobApi.Drop:new("minecraft:ender_pearl", 0, 5000) }))
table.insert(mobs, mobApi.Mob:new("Phantom", "Phantom", "redstoneIntegrator_9",{ mobApi.Drop:new("minecraft:phantom_membrane", 0, 3000) }))

-- Find the slot the wanted items are in and store it
for slot, item in pairs(drawerController.list()) do
	for _, mob in ipairs(mobs) do
		for _, drop in ipairs(mob.dropsWanted) do
			if item.name == drop.name then
				drop.inventorySlot = slot
			end
		end
	end
end

for _, mob in ipairs(mobs) do
	peripheral.call(mob.redstoneIntegrator, "setOutput", "front", true)
end
for _, face in ipairs({ "bottom", "top", "left", "right", "front" }) do
	peripheral.call("redstoneIntegrator_14", "setOutput", face, false)
end

local t = buttonApi.new("top")

t:add(mobs[1].buttonName, genFunction(), 2, 2, 10, 4)
t:add(mobs[2].buttonName, genFunction(), 2, 6, 10, 8)
t:add(mobs[3].buttonName, genFunction(), 2, 10, 10, 12)
t:add(mobs[4].buttonName, genFunction(), 2, 14, 10, 16)
t:add("MSF", genFunction(), 32, 6, 38, 8)
t:add("Mash", genFunction(), 24, 2, 30, 4)
t:add("Fans", genFunction(), 32, 2, 38, 4)
t:add("ESpwn", genFunction(), 24, 14, 30, 16)
t:add("Light", genFunction(), 32, 14, 38, 16, true)

for _, button in ipairs(t) do
	local state = false
	if value[3] == "front" then
		state = true
	end
	peripheral.call(button[2], "setOutput", button[3], state)
end

t:draw()

--local timerID = os.startTimer(30)

while true do
	local event, p1 = t:handleEvents(os.pullEvent())
	if event == "button_click" then
		local found = false

		for _, mob in ipairs(mobs) do
			if mob.buttonName == p1 then
				found = true
				t:onClick(mob.buttonName, mob.redstoneIntegrator, "front")
				break
			end
		end

		if not found then
			if p1 == "MSF" then
				t:onClick(p1, "redstoneIntegrator_14", "bottom")
			elseif p1 == "Mash" then
				t:onClick(p1, "redstoneIntegrator_14", "top")
			elseif p1 == "Fans" then
				t:onClick(p1, "redstoneIntegrator_14", "left")
			elseif p1 == "ESpwn" then
				t:onClick(p1, "redstoneIntegrator_14", "right")
			elseif p1 == "Light" then
					t:onClick(p1, "redstoneIntegrator_14", "front")
			end
		end

		if event == "timer" then
			checkItemLevels(drawerController, itemsWanted, buttonTable, t)
		end
	end
end
