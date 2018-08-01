local Tank = require("app.Tank")

local TankCursor = class("TankCursor", Tank)

function TankCursor:ctor(node, name, map)
    TankCursor.super.ctor(self, node, name, map)

    self.x = 0
    self.y = 0
    self.brush = "mud"

    local blink = cc.Blink:create(1, 2)
    local a = cc.RepeatForever:create(blink)
    self.sp:runAction(a)

end

function TankCursor:PlaceCursor(x, y)
    self.x = GetIntPart(x)
    self.y = GetIntPart(y)

    self.SetPos(self.x, self.y)
end

function TankCursor:MoveCursor(deltaX, deltaY)
    local x = self.x + deltaX
    local y = self.y + deltaY

    if x > MapWidth -1 then
        x = MapWidth - 1
    end

    if y > MapHeight -1 then
        y = MapHeight - 1
    end

    if x < 0 then
        x = 0
    end

    if y < 0 then
        y = 0
    end

    self:PlaceCursor(x, y)
end

local switchOrder = {
    "mud",
    "road",
    "water",
    "grass",
    "brick",
    "steel",
}

local function getNextType(type, dir)
    local blockIndex = -1
    for index, typename in ipairs(switchOrder) do
        if typename == type then
            blockIndex = index
        end
    end

    if blockIndex == -1 then
        return type
    end

    if dir >= 1 then
        blockIndex = blockIndex + 1
        if blockIndex > #switchOrder then
            blockIndex = 1
        end
    else
        blockIndex = blockIndex - 1
        if blockIndex < 1 then
            blockIndex = #switchOrder
        end
    end

    return switchOrder[blockIndex]
end

function TankCursor:SwitchBlock(dir)
    local block = self.map:Get(self.x, self.y)
    if block == nil then
        return
    end

    if block.type == self.brush then
        self.brush = getNextType(self.brush, dir)
    end
    block:Reset(self.brush)
end

return TankCursor
