local Object = require("app.Object")
local SpriteAnim = require("app.SpriteAnim")
local Tank = class("Tank", Object)

function Tank:ctor(node, name)
    Tank.super.ctor(self, node)
    self.node = node

    self.dir = "up"
    self.spAnim = SpriteAnim.new(self.sp)
    --定义动画
    self.spAnim:Define("run", name, 8, 0.1)
    self.spAnim:SetFrame("run", 0)
    --local size = cc.Director:getInstance():getWinSize()
    --self.sp:setPosition(size.width/2, size.height/2)

    --local spriteFrameCache = cc.SpriteFrameCache:getInstance()
    --local frame = spriteFrameCache:getSpriteFrame("tank_green_run0.png")

    --self.sp:setSpriteFrame(frame)

end

function Tank:SetDir(dir)
    if dir == nil then
        self.spAnim:Stop("run")
        return
    elseif dir == "left" then
        self.sp:setRotation(-90)
        self.spAnim:Play("run")
    elseif dir == "right" then
        self.sp:setRotation(90)
        self.spAnim:Play("run")
    elseif dir == "up" then
        self.sp:setRotation(0)
        self.spAnim:Play("run")
    elseif dir == "down" then
        self.sp:setRotation(180)
        self.spAnim:Play("run")
    end
    self.dir = dir
end

function Tank:Destory()
    Tank.super.Destory(self)
end

return Tank
