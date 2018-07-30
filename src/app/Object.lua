local Object = class("Object")

function Object:ctor(node)
    self.sp = cc.Sprite:create()
    self.node = node
    self.node:addChild(self.sp)

    if self.Update ~= nil then
        self.updateFuncID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
                self:Update()
            end, 0, false)
    end
end

function Object:Alive()
    return self.sp ~= nil
end

function Object:UpdatePosition(callback)
    local delta = cc.Director:getInstance():getDeltaTime()

    local nextPosX = self.sp:getPositionX() + self.dx * delta
    local nextPosY = self.sp:getPositionY() + self.dy * delta

    if callback(nextPosX, nextPosY) then
        return
    end

    if self.dx ~= 0 then
        self.sp:setPositionX(nextPosX)
    end
    if self.dy ~= 0 then
        self.sp:setPositionY(nextPosY)
    end

end

function Object:Destory()
    if self.updateFuncID() then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.updateFuncID)
    end

    self.node:removeChild(self.sp)
    self.sp = nil
end

return Object
