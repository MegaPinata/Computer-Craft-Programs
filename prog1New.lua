os.loadAPI("buttonApi")
os.loadAPI("mobApi")

local drawerController = peripheral.wrap("functionalstorage:storage_controller_0")
local mobs = {}

function genFunction(redstoneIntegrator, face)
    return func = function() peripheral.call(redstoneIntegrator, "setOutput", face, not peripheral.call(redstoneIntegrator, "getOutput", face)) end
end

function checkItemLevels(storageController, mobs, t)
	for _, mob in ipairs(mobs) do
        for _, drop in ipairs(mob.dropsWanted) do
            local item = drawerController.getItemDetail(item.inventorySlot)
            if item.count <= drop.quantity and not t:getActive(mob.buttonName) then
                t:onClick(mob.buttonName)
            elseif item.count > drop.quantity and t:getActive(mob.buttonName) then
                t:onClick(mob.buttonName)
        end
    end
end

table.insert(mobs, Mob:new("Blaze", "Blaze", "redstoneIntegrator_6", {Drop:new("minecraft:blaze_rod", 0, 3000)}))
table.insert(mobs, Mob:new("Wither Skeleton", "W Skel", "redstoneIntegrator_7", {Drop:new("minecraft:wither_skeleton_skull", 0, 100)}))
table.insert(mobs, Mob:new("Enderman", "Ender", "redstoneIntegrator_8", {Drop:new("minecraft:ender_pearl", 0, 5000)}))
table.insert(mobs, Mob:new("Phantom", "Phantom", "redstoneIntegrator_9", {Drop:new("minecraft:phantom_membrane", 0, 3000 )}))

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
    peripheral.call(mob.redstoneIntegrator, "setOutput", "front", false)
end

for _, face in ipairs({"bottom","top","left","right","front"}) do
    peripheral.call("redstoneIntegrator_14", "setOutput", false)
end

for _, button in ipairs(buttonTable) do
    local state = false
	if value[3] == "front" then
        state = true
	end
    peripheral.call(button[2], "setOutput", button[3], state)
end

local t = buttonApi.new("top")

t:add(mobs[1].buttonName, genFunction(mob[1].redstoneIntegrator, "front"), 2, 2, 10, 4)
t:add(mobs[2].buttonName, genFunction(mob[2].redstoneIntegrator, "front"), 2, 6, 10, 8)
t:add(mobs[3].buttonName, genFunction(mob[3].redstoneIntegrator, "front"), 2, 10, 10, 12)
t:add(mobs[4].buttonName, genFunction(mob[4].redstoneIntegrator, "front"), 2, 14, 10, 16)
t:add("MSF", genFunction("redstoneIntegrator_14", "bottom"), 32, 6, 38, 8)
t:add("Mash", genFunction("redstoneIntegrator_14", "top"), 24, 2, 30, 4)
t:add("Fans", genFunction("redstoneIntegrator_14", "left"), 32, 2, 38, 4)
t:add("ESpwn", genFunction("redstoneIntegrator_14", "right"), 24, 14, 30, 16)
t:add("Light", genFunction("redstoneIntegrator_14", "front"), 32, 14, 38, 16)
t:draw()

local timerID = os.startTimer(30)

while true do
	local event, p1 = t:handleEvents(os.pullEvent())
	if event == "button_click" then
        t:onClick(p1)
	end

	if event == "timer" then
		checkItemLevels(drawerController, itemsWanted, buttonTable, t)
    end
end