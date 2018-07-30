local Tank = require("app.Tank")
--local socket = require "socket"

local PlayerTank = class("PlayerTank", Tank)

function PlayerTank:ctor(node, name, map)
    PlayerTank.super.ctor(self, node, name, map)
    self.dirTable = {}
end

function PlayerTank:MoveBegin(dir)
    self.dirTable[dir] = socket.gettime()
    self:updateDir()
end


function PlayerTank:MoveEnd(dir)
    self.dirTable[dir] = 0
    self:updateDir()
end

function PlayerTank:updateDir()
    local maxTime = 0
    local maxDir
    for k, d in pairs(self.dirTable) do
        if d > maxTime then
            maxTime = d
            maxDir = k
        end
    end

    self:SetDir(maxDir)
end

return PlayerTank
