require("app.Common")
require("app.Camp")

local PlayerTank = require("app.PlayerTank")
local Map = require("app.Map")

local TitleScene = class("TitleScene", cc.load("mvc").ViewBase)

local function createStaticButton(node, imageName, x, y, pressed)
    local button = ccui.Button:create()
    button:loadTextureNormal(imageName .. ".png", ccui.TextureResType.plistType)

    button:move(x, y)
    button:addTo(node)
    button:addTouchEventListener(pressed)

end

function TitleScene:createDirectionButtons()
    local direcRelate = {
        up = { display.cx/4, display.cy/2+30,},
        down = { display.cx/4, display.cy/2-93 },
        left = { display.cx/4-60, display.cy/2-33 },
        right = { display.cx/4+60, display.cy/2-33},
    }

    for key, value in pairs(direcRelate) do
        createStaticButton(self, key, value[1], value[2], function(sender, eventType)
            if eventType ==  ccui.TouchEventType.began then
                if self.tank ~= nil and key == "left" then
                    self.tank:SetPos(4, 1)
                    return true
                elseif self.tank ~= nil and key == "right" then
                    self.tank:SetPos(11, 1)
                    return true
                end
            end
        end)
    end
end

function TitleScene:createOtherButtons()
    local otherRelate = {
        increase = {display.cx/4+780, display.cy/2+5,},
        decrease = { display.cx/4+750, display.cy/2-32,},
    }

    for key, value in pairs(otherRelate) do
        createStaticButton(self, key, value[1], value[2], function(sender, eventType)
            if eventType ==  ccui.TouchEventType.began then
                local sceneName
                local x, _ = self.tank:GetPos()
                if x == 4 then
                    sceneName = "app.views.MainScene"
                else
                    sceneName = "app.views.EditorScene"
                end

                local sceneLayer = require(sceneName)
                local scene = sceneLayer.create()
                display.runScene(scene, "fade", 0.6)
            end
        end)
    end
end

function TitleScene:createHandleButton()
    self:createDirectionButtons()
    self:createOtherButtons()
end

function TitleScene:onCreate()
    local spriteFrameCache = cc.SpriteFrameCache:getInstance()
    spriteFrameCache:addSpriteFrames("res/tex1.plist")

    self.map = Map.new(self)
    self.map:Load("title.lua")
    self.tank = PlayerTank.new(self, "tank_green", self.map)
    --self.tank:PlaceCursor(MapWidth/2, MapHeight/2)
    self.tank:SetPos(4, 1)
--
    self:ProcessInput()
    self:createHandleButton()

end

function TitleScene:ProcessInput()
    local listener = cc.EventListenerKeyboard:create()

    listener:registerScriptHandler(function(keyCode, event)
        if self.tank ~= nil then
                --a
            if keyCode == 124 then
                self.tank:SetPos(4, 1)
                --d
            elseif keyCode == 127 then
                self.tank:SetPos(11, 1)
                --j
            elseif keyCode == 133 then
                local sceneName
                local x, _ = self.tank:GetPos()
                if x == 4 then
                    sceneName = "app.views.MainScene"
                else
                    sceneName = "app.views.EditorScene"
                end

                local sceneLayer = require(sceneName)
                local scene = sceneLayer.create()
                display.runScene(scene, "fade", 0.6)

            end
        end
    end, cc.Handler.EVENT_KEYBOARD_RELEASED)

    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

function TitleScene:onExit()
    self.tank:Destory()
end

return TitleScene
