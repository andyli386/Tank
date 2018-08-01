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

    self:Set(3, 8, "grass")
    self:Set(5, 8, "steel")
    self:Set(7, 8, "brick")
    self:Set(9, 8, "water")
    self:Set(11, 8, "road")

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

--给定一个坐标和矩形，看是否碰到坐标下的方块
function Map:collideWithBlock(r, x, y)
    local block = self:Get(x, y)

    --超出范围
    if block == nil then
        return nil
    end

    --这个方块可以过去
    if block.damping < 1 then
        return nil
    end

    if cc.exports.RectInterset(r, block:GetRect()) ~= nil then
        return block
    end

    return nil
end

function Map:Collide(posx, posy, ex)

    --将坦克坐标转换成矩形
    local objRect = cc.exports.NewRect(posx, posy, ex)
    for x = 0, cc.exports.MapWidth - 1 do
        for y = 0, cc.exports.MapHeight - 1 do
            local b = self:collideWithBlock(objRect, x, y)
            if b ~= nil then
                return b
            end
        end
    end

    return nil
end

function Map:Save(filename)
    local f = assert(io.open(filename, "w"))
    f:write("return {\n")
    for x = 0, MapWidth - 1 do
        for y = 0, MapHeight - 1 do
            local block = self:Get(x, y)
            f:write(string.format("{x = %d, y = %d, type = '%s'}, \n", x, y, block.type))
        end
    end
    f:write("}\n")
    f:close()
    print(filename .. " saved")
end

function Map:Load(filename)
    local t = dofile(filename)
    if t == nil then
        return
    end

    for _, block in ipairs(t) do
        self:Set(block.x, block.y, block.type)
    end

    print(filename .. " load")
end

function Map:Hit(posx, posy)
    local x, y = cc.exports.Pos2Grid(posx, posy)
    local block = self:Get(x, y)

    if block == nill then
        return nil, true
    end

    if block.breakable then
        return block
    end

    return nil
end

return Map
