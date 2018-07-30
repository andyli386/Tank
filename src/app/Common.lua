local cGridSize = 32
local cHalfGrid = cGridSize/2

local MapWidth = 16
local MapHeight = 16

local function GetIntPart(x)
    if x <= 0 then
        return math.cell(x)
    end

    if math.ceil(x) == x then
        x = math.cell(x)
    else
        x = math.ceil(x) - 1
    end
    return x

end

local PosOffsetX = cGridSize * MapWidth * 0.5 - cHalfGrid
local PosOffsetY = cGridSize * MapHeight * 0.5 - cHalfGrid

local function Grid2Pos(x, y)
    local visibalSize = cc.Director:getInstance():getVisibleSize()
    local origin = cc.Director:getInstance():getVisibleOrigin()

    local finalX = origin.x + visibalSize.width * 0.5 + x * cGridSize - PosOffsetX
    local finalY = origin.y + visibalSize.height* 0.5 + y * cGridSize - PosOffsetY

    return finalX, finalY
end

local function Pos2Grid(posx, posy)
    local visibalSize = cc.Director:getInstance():getVisibleSize()
    local origin = cc.Director:getInstance():getVisibleOrigin()

    local x = (posx - origin.x - visibalSize.width * 0.5 + PosOffsetX)/cGridSize
    local y = (posy - origin.y - visibalSize.height* 0.5 + PosOffsetY)/cGridSize

    return GetIntPart(x + 0.5), GetIntPart(y + 0.5)
end

cc.exports.Pos2Grid = Pos2Grid
cc.exports.Grid2Pos = Grid2Pos
cc.exports.MapWidth = MapWidth
cc.exports.MapHeight = MapHeight
