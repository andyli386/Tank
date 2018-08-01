local campMap = {}
local relation = {}

local function Camp_Add(camp, obj)
    if camp == nil then
        return
    end

    local campList = campMap[camp]
    if campList == nil then
        campList = {}
        campMap[camp] = campList
    end

    campList[obj] = obj
    obj.camp = camp
end

local function Camp_SetHostile(camp1, camp2, fight)
    relation[camp1 .. "|" .. camp2] = fight

end

local function Camp_IsHostile(camp1, camp2)
    return relation[camp1 .. "|" .. camp2]
end

local function Camp_Remove(obj)
    if obj.camp == nil then
        return
    end

    local campList = campMap[obj.camp]

    if campList == nil then
        return
    end

    campList[obj] = nil
    obj.camp = nil

end

local function Camp_IterateHostile(myCamp, callback)
    for camp, campList in pairs(campMap) do
        if Camp_IsHostile(myCamp, camp) then
            for _, obj in pairs(campList) do
                local result = callback(obj)
                if result then
                    return result
                end
            end
        end
    end

end

local function Camp_IterateAll(callback)
    for camp, campList in pairs(campMap) do
        for _, obj in pairs(campList) do
            local result = callback(obj)
            if result then
                return result
            end
        end
    end

end

cc.exports.Camp_IsHostile = Camp_IsHostile
cc.exports.Camp_SetHostile = Camp_SetHostile
cc.exports.Camp_Add = Camp_Add
cc.exports.Camp_Remove = Camp_Remove
cc.exports.Camp_IterateHostile = Camp_IterateHostile
cc.exports.Camp_IterateAll = Camp_IterateAll
