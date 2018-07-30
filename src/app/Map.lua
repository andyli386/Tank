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

    for x = 0, cc.exports.MapWidth - 1 do
        for y = 0, cc.exports.MapHeight - 1 do
            print(x, y, self:Get(x, y).type)
        end
    end

    --self:Set(1, 8, "steel")
    self:Set(3, 8, "grass")
    self:Set(5, 8, "mud")
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
    --print("Map:Set:", x, y, type)
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
    --print(r:tostring(), block:GetRect():tostring(), block.x, block.y)
    --print("Map:collideWithBlock,", block.type)

    --超出范围
    if block == nil then
        --print("block == nil, return ")
        return nil
    end

    --这个方块可以过去
    if block.damping < 1 then
        --print("block.damping < 1, return")
        return nil
    end

    if cc.exports.RectInterset(r, block:GetRect()) ~= nil then

        print(block["hp"],
        block["needAP"],
        block["damping"],
        block["breakable"], block.type)
        --print("return:", block)
        return block
    end

    return nil
end

function Map:Collide(posx, posy, ex)
    local objRect = cc.exports.NewRect(posx, posy, ex)
    for z = 0, cc.exports.MapWidth - 1 do
        print("Map:Collide", cc.exports.MapWidth, z)
        for y = 0, cc.exports.MapHeight - 1 do
            --print("Map:Collide", cc.exports.MapWidth, cc.exports.MapHeight, z, y)
            local b = self:collideWithBlock(objRect, z, y)
            if b ~= nil then
                return b
            end
        end
    end

    return nil
end

return Map
