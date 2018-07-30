local Object = class("Object")

function Object:ctor(node)
    self.sp = cc.Sprite:create()
    self.node = node
    self.node:addChild(self.sp)
end

function Object:Alive()
    return self.sp ~= nil
end

function Object:Destory()
    self.node:removeChild(self.sp)
    self.sp = nil
end

return Object
