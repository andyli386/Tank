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

    local size = cc.Director:getInstance():getWinSize()

    self.tank = PlayerTank.new(self, "tank_green")
    self.tank.sp:setPosition(size.width/2, size.height/2)

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
            end
        end
    end, cc.Handler.EVENT_KEYBOARD_RELEASED)

    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

return MainScene
