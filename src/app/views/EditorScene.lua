require("app.Common")
require("app.Camp")

local TankCursor = require("app.TankCursor")
local Map = require("app.Map")

local EditorScene = class("EditorScene", function()
    return display.newScene("EditorScene")
end)

function EditorScene:ctor()
    local spriteFrameCache = cc.SpriteFrameCache:getInstance()
    spriteFrameCache:addSpriteFrames("res/tex1.plist")

    self.map = Map.new(self)
    self.tank = TankCursor.new(self, "tank_green", self.map)
    self.tank:PlaceCursor(MapWidth/2, MapHeight/2)

    self:ProcessInput()

end

local editorFileName = "editor.lua"
function EditorScene:ProcessInput()
    local listener = cc.EventListenerKeyboard:create()

    listener:registerScriptHandler(function(keyCode, event)
        if self.tank ~= nil then
            --w
            if keyCode == 146 then
                self.tank:MoveCursor(0, 1)
                --s
            elseif keyCode == 142 then
                self.tank:MoveCursor(0, -1)
                --a
            elseif keyCode == 124 then
                self.tank:MoveCursor(-1, 0)
                --d
            elseif keyCode == 127 then
                self.tank:MoveCursor(1, 0)
                --j
            elseif keyCode == 133 then
                self.tank:SwitchBlock(1)
            elseif keyCode == 134 then
                self.tank:SwitchBlock(-1)
                --f3
            elseif keyCode == 49 then
                self.map:Load(editorFileName)
                --f4
            elseif keyCode == 50 then
                self.map:Save(editorFileName)
            end
        end
    end, cc.Handler.EVENT_KEYBOARD_RELEASED)

    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

return EditorScene
