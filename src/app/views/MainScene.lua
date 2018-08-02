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

local function createStaticButton(node, imageName, x, y, pressed, released)
    local button = ccui.Button:create()
    button:loadTextureNormal(imageName, ccui.TextureResType.plistType)

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(pressed, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(released, cc.Handler.EVENT_TOUCH_ENDED)
    local eventDispatcher = button:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, button)

    button:move(x, y)
    button:addTo(node)

    --listen:registerScriptHandler(touchMoved,cc.Handler.EVENT_TOUCH_MOVED)
    --listen:registerScriptHandler(touchCanceled,cc.Handler.EVENT_TOUCH_CANCELLED)
 
    --节点添加的先后顺序为优先级的添加监听器方式，节点越上层，优先级越高
    --eventDispatcher:addEventListenerWithSceneGraphPriority(listen,layer)
    --void EventDispatcher::addEventListenerWithFixedPriority(EventListener* listener, int fixedPriority)
    --固定优先级的添加监听器方式,fixedPriority>0, 数值越小，优先级越高
    --eventDispatcher:addEventListenerWithFixedPriority(listener, node)

end

--function MainScene:onCreate()
function MainScene:ctor()
    -- add background image
    --display.newSprite("HelloWorld.png")
    --    :move(display.center)
    --    :addTo(self)
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
    local size = cc.Director:getInstance():getWinSize()

    self.tank = PlayerTank.new(self, "tank_green", self.map, "player")
    self.tank:SetPos(7, 4)


    self:ProcessInput()

    --local spriteFrameCache = cc.SpriteFrameCache:getInstance()
    local up_dir = "up.png"
    createStaticButton(self, up_dir, display.cx/4, display.cy/2+30, function()
        if self.tank ~= nil then
            self.tank:MoveBegin("up")
            --print("up MoveBegin")
            return true
        end
    end, function() 
        if self.tank ~= nil then
            self.tank:MoveEnd("up")
            --print("up MoveEnd")
            return true
        end
    end)

    local down_dir = "down.png"
    createStaticButton(self, down_dir, display.cx/4, display.cy/2-93, function()
        if self.tank ~= nil then
            self.tank:MoveBegin("down")
            --print("down MoveBegin")
            return true
        end
    end, function() 
        if self.tank ~= nil then
            self.tank:MoveEnd("down")
            --print("down MoveEnd")
            return true
        end
    end)

    local left_dir = "left.png"
    createStaticButton(self, left_dir, display.cx/4-60, display.cy/2-33, function()
        if self.tank ~= nil then
            self.tank:MoveBegin("left")
            --print("left MoveBegin")
            return true
        end
    end, function() 
        if self.tank ~= nil then
            self.tank:MoveEnd("left")
            --print("left MoveEnd")
            return true
        end
    end)

    local right_dir = "right.png"
    createStaticButton(self, right_dir, display.cx/4+60, display.cy/2-33, function()
        if self.tank ~= nil then
            self.tank:MoveBegin("right")
            --print("right MoveBegin")
            return true
        end
    end, function() 
        if self.tank ~= nil then
            self.tank:MoveEnd("right")
            --print("right MoveEnd")
            return true
        end
    end)

    local increase = "increase.png"
    createStaticButton(self, increase, display.cx/4+730, display.cy/2+5, function()
        if self.tank ~= nil then
            self.tank:Fire()
            --print("fire")
            return true
        end
    end, function() 
        if self.tank ~= nil then
            --print("fire end")
            return true
        end
    end)

    local decrease = "decrease.png"
    createStaticButton(self, decrease, display.cx/4+700, display.cy/2-32, function()
        if self.tank ~= nil then
            self.factory:SpawnRandom()
            --print("SpawnRandom")
            return true
        end
    end, function() 
        if self.tank ~= nil then
            --print("SpawnRandom end")
            return true
        end
    end)
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
