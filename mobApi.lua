Mob = {
	name = "",
	buttonName = "",
	dropsWanted = {},
}

function Mob:new(name, buttonName, redstoneIntegrator, drops)
	local temp = {}
	setmetatable(temp, self)
	self.__index = self

	temp.name = name
	temp.buttonName = buttonName
  temp.redstoneIntegrator = redstoneIntegrator
	temp.dropsWanted = drops

	return temp
end

Drop = {
	idName = "",
	inventorySlot = 0,
	quantity = 0,
}

function Drop:new(idName, inventorySlot, quantity)
	local temp = {}
	setmetatable(temp, self)
	self.__index = self

	temp.idName = idName
	temp.inventorySlot = inventorySlot
	temp.quantity = quantity

	return temp
end
