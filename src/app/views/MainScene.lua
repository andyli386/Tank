require("app.Common")
require("app.Camp")
local Factory = require("app.Factory")
local Map = require("app.Map")
local Tank = require("app.Tank")
local PlayerTank = require("app.PlayerTank")

--local MainScene = class("MainScene", cc.load("mvc").ViewBase)
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

local function createStaticButton(node, imageName, x, y, pressed)
    local button = ccui.Button:create()
    button:loadTextureNormal(imageName .. ".png", ccui.TextureResType.plistType)

    button:move(x, y)
    button:addTo(node)
    button:addTouchEventListener(pressed)

end

function MainScene:createDirectionButtons()
    local direcRelate = {
        up = { display.cx/4, display.cy/2+30,},
        down = { display.cx/4, display.cy/2-93 },
        left = { display.cx/4-60, display.cy/2-33 },
        right = { display.cx/4+60, display.cy/2-33},
    }

    for key, value in pairs(direcRelate) do
        createStaticButton(self, key, value[1], value[2], function(sender, eventType)
            if eventType ==  ccui.TouchEventType.began then
                if self.tank ~= nil then
                    self.tank:MoveBegin(key)
                    print(key .. " MoveBegin")
                    return true
                end
            elseif eventType ==  ccui.TouchEventType.ended then
                if self.tank ~= nil then
                    self.tank:MoveEnd(key)
                    print(key .. " MoveEnd")
                    return true
                end
            end
        end)
    end
end

function MainScene:createOtherButtons()
    local otherRelate = {
        increase = {display.cx/4+780, display.cy/2+5,},
        decrease = { display.cx/4+750, display.cy/2-32,},
    }

    for key, value in pairs(otherRelate) do
        createStaticButton(self, key, value[1], value[2], function(sender, eventType)
            if eventType ==  ccui.TouchEventType.began then
                if key == "increase" then
                    self.factory:SpawnRandom()
                elseif key == "decrease" then
                    self.tank:Fire()
                end
            end
        end)
    end
end

function MainScene:createHandleButton()
    self:createDirectionButtons()
    self:createOtherButtons()
end

--function MainScene:onCreate()
function MainScene:ctor()
    local spriteFrameCache = cc.SpriteFrameCache:getInstance()
    spriteFrameCache:addSpriteFrames("res/tex1.plist")

    cc.exports.Camp_SetHostile("player", "enemy", true)
    cc.exports.Camp_SetHostile("enemy", "player", true)

    cc.exports.Camp_SetHostile("player.bullet", "enemy", true)
    cc.exports.Camp_SetHostile("enemy.bullet", "player", true)

    cc.exports.Camp_SetHostile("player.bullet", "enemy.bullet", true)
    cc.exports.Camp_SetHostile("player.bullet", "enemy.bullet", true)

    self.map = Map.new(self)

    self.factory = Factory.new(self, self.map)

    --local size = cc.Director:getInstance():getWinSize()
    self.tank = PlayerTank.new(self, "tank_green", self.map, "player")
    self.tank:SetPos(7, 4)

    self:ProcessInput()
    self:createHandleButton()
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
                --k
            elseif keyCode == 134 then
                self.factory:SpawnRandom()
            end
        end
    end, cc.Handler.EVENT_KEYBOARD_RELEASED)

    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

return MainScene
