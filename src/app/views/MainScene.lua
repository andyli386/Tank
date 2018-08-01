require("app.Common")
require("app.Camp")
local Factory = require("app.Factory")
local Map = require("app.Map")
local Tank = require("app.Tank")
local PlayerTank = require("app.PlayerTank")

local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()
    -- add background image
    --display.newSprite("HelloWorld.png")
    --    :move(display.center)
    --    :addTo(self)
    local spriteFrameCache = cc.SpriteFrameCache:getInstance()
    spriteFrameCache:addSpriteFrames("res/tex.plist")

    cc.exports.Camp_SetHostile("player", "enemy", true)
    cc.exports.Camp_SetHostile("enemy", "player", true)

    cc.exports.Camp_SetHostile("player.bullet", "enemy", true)
    cc.exports.Camp_SetHostile("enemy.bullet", "player", true)

    cc.exports.Camp_SetHostile("player.bullet", "enemy.bullet", true)
    cc.exports.Camp_SetHostile("player.bullet", "enemy.bullet", true)

    self.map = Map.new(self)

    self.factory = Factory.new(self, self.map)
    local size = cc.Director:getInstance():getWinSize()

    self.tank = PlayerTank.new(self, "tank_green", self.map, "player")
    self.tank:SetPos(7, 4)


    -- add HelloWorld label
    --cc.Label:createWithSystemFont("Hello World", "Arial", 40)
    --    :move(display.cx, display.cy + 200)
    --    :addTo(self)

    self:ProcessInput()
end

function MainScene:ProcessInput()
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(function(keyCode, event)
        if self.tank ~= nil then
            --w
            if keyCode == 146 then
                self.tank:MoveBegin("up")
            --s
            elseif keyCode == 142 then
                self.tank:MoveBegin("down")
            --a
            elseif keyCode == 124 then
                self.tank:MoveBegin("left")
            --d
            elseif keyCode == 127 then
                self.tank:MoveBegin("right")
            end
        end
    end, cc.Handler.EVENT_KEYBOARD_PRESSED)

    listener:registerScriptHandler(function(keyCode, event)
        if self.tank ~= nil then
            --w
            if keyCode == 146 then
                self.tank:MoveEnd("up")
                --s
            elseif keyCode == 142 then
                self.tank:MoveEnd("down")
                --a
            elseif keyCode == 124 then
                self.tank:MoveEnd("left")
                --d
            elseif keyCode == 127 then
                self.tank:MoveEnd("right")
                --j
            elseif keyCode == 133 then
                self.tank:Fire()
            elseif keyCode == 134 then
                self.factory:SpawnRandom()
            end
        end
    end, cc.Handler.EVENT_KEYBOARD_RELEASED)

    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

return MainScene
