require("app.Common")
require("app.Camp")

local PlayerTank = require("app.PlayerTank")
local Map = require("app.Map")

local TitleScene = class("TitleScene", cc.load("mvc").ViewBase)

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
