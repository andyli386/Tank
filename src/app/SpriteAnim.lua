local SpriteAnim = class("SpriteAnim")

function SpriteAnim:ctor(sp)
    --动画表
    self.anim = {}
    self.sp = sp
end

local function setFrame(sp, def, index)
    if sp == nil then
        return
    end
    print("setFrame")

    local spriteFrameCache = cc.SpriteFrameCache:getInstance()

    local final
    --带动画名的动画帧
    if def.name ~= nil then
        final = string.format("%s_%s%d.png", def.spname, def.name, index)
    else
        --不带动画名的动画帧
        final = string.format("%s%d.png", def.spname, index)
    end
    print("def.spname:",def.spname)

    local frame = spriteFrameCache:getSpriteFrame(final)

    if frame == nil then
        print("sprite frame not found ,", name)
        return
    end

    sp:setSpriteFrame(frame)
end

function SpriteAnim:Define(name, spname, frameCount, interval,  once)
    local spriteFrameCache = cc.SpriteFrameCache:getInstance()
    local def = {
        ["curFrame"] = 0,
        ["running"] = false,
        ["frameCount"] = frameCount,
        ["spname"] = spname,
        ["name"] = name,
        ["once"] = once,
        ["interval"] = interval,
        ["advanceFrame"] = function(defSelf)
            defSelf.curFrame = defSelf.frameCount + 1
            if defSelf.curFrame >= defSelf.frameCount then
                defSelf.curFrame = 0
                return false
            end
            return true
        end,
    }

    --不带动作
    if name == nil then
        self.anim[spname] = def
    else
    --带动作
        self.anim[name] = def
    end
end

function SpriteAnim:SetFrame(name, index)
    local def = self.anim[name]

    if def == nil then
        return
    end

    setFrame(self.sp, def, index)
end

function SpriteAnim:Play(name, callback)
    local def = self.anim[name]
    if def == nil then
        return
    end

    if def.shid == nil then
        def.shid = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
            if def.running then
                if def:advanceFrame() then
                    setFrame(self.sp, def, def.curFrame)
                elseif def.once then
                    def.running = false
                    cc.Director:getInstance():getScheduler():unscheduleScriptFunc(def.shid)
                    def.shid = nil

                    if callback ~= nil then
                        callback()
                    end
                end
            end

        end, def.interval, false)
    end
    def.running = true
end

function SpriteAnim:Stop(name)
    local def = self.anim[name]
    if def == nil then
        return 
    end

    def.running = false
end

function SpriteAnim:Destory()
    for name, def in pairs(self.anim) do
        if def.shid then
            cc.Director:getInstance():getScheduler():unschedulerScriptFunc(def.shid)
        end
    end

    self.sp = nil
end

return SpriteAnim
