require("app.Map")
local Object = require("app.Object")
local SpriteAnim = require("app.SpriteAnim")

local Bullet = class("Bullet", Object)

local function getDeltaByDir(dir, speed)

    if dir == "left" then
        return -speed, 0
    elseif dir == "right" then
        return speed, 0
    elseif dir == "up" then
        return  0, speed
    elseif dir == "down" then
        return 0, -speed
    end
    return 0, 0
end


function Bullet:ctor(node, map, type, obj, dir)
    Bullet.super.ctor(self, node)

    self.dx, self.dy = getDeltaByDir(dir, 200)
    self.map = map

    self.sp:setPositionX(obj.sp:getPositionX())
    self.sp:setPositionY(obj.sp:getPositionY())

    self.spAnim = SpriteAnim.new(self.sp)

    self.spAnim:Define(nil, "bullet", 2, 0.1)
    self.spAnim:Define(nil, "explode", 3, 0.1, true)

    self.spAnim:SetFrame("bullet", type)
end

function Bullet:Update()
    self:UpdatePosition(function(nextPosX, nextPosY)
        local hit
        local block, out = self.map:Hit(nextPosX, nextPosY)

        if block or out then
            hit = "explode"

            if block and block.breakable then
                if(block.needAP and self.type == 1) or not block.needAP then
                    block:Break()
                end
            end
        end

        if hit then
            self:Stop()
            if hit == "explode" then
                self:Explode()
            end
        end

        return false
    end)
end

function Bullet:Explode()
    self.spAnim:Play("explode", function()
        self:Destory()
    end)
end

return Bullet
