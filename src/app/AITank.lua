local Tank = require("app.Tank")
local AITank = class("AITank", Tank)

function AITank:ctor(node, name, map, camp)
    AITank.super.ctor(self, node, name, map, camp)

    self.OnCollide = function(obj)
        if iskindof(obj, "bullet") then
            return
        end

        self:Redirect()
    end

    self.wait = 0
    self.lastRedirect = 0
    self:Redirect()
end

function AITank:Update()
    AITank.super.Update(self)
    if math.random(1, 100) < 2 then
        self:Fire()
    end

    if self.wait > 0 then
        local now = socket.gettime()
        if now - self.waitTimeStamp > self.wait then
            self.wait = 0
        end
    end
end

local dirTable = {"left","right","up","down",}
function AITank:Redirect()
    local now = socket.gettime()
    local dir
    if now - self.lastRedirect > 0.5 then
        dir = dirTable[math.random(1, #dirTable)]
    end

    self:SetDir(dir)

    if dir == nil then
        self.wait = math.random(1, 2)
        self.waitTimeStamp = socket.gettime()
    end

    self.lastRedirect = now

end

return AITank
