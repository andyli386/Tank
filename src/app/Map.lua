require("app.Common")

local Map = class("Map")

local Block = require("app.Block")

function Map:ctor(node)
    self.map = {}
    self.node = node

    for x = 0, cc.exports.MapWidth - 1 do
        for y = 0, cc.exports.MapHeight - 1 do
            if x == 0 or x == cc.exports.MapWidth - 1 or y == 0 or y == cc.exports.MapHeight - 1 then
                self:Set(x, y, "steel")
            else
                self:Set(x, y, "mud")
            end
        end
    end
end

function Map:Get(x, y)
    if x < 0 or y < 0 then
        return nil
    end

    if x >= cc.exports.MapWidth or y >= cc.exports.MapHeight then
        return nil
    end

    return self.map[x*cc.exports.MapHeight + y]
end

function Map:Set(x, y, type)
    local block = self.map[x*cc.exports.MapHeight + y]
    if block == nil then
        block = Block.new(self.node)
    end
    block:SetPos(x, y)
    self.map[x*cc.exports.MapHeight + y] = block
    block:Reset(type)
    block.x = x
    block.y = y
end

return Map
