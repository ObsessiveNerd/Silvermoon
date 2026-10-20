local pd <const> = playdate
local gfx <const> = playdate.graphics

import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "player"

class('FogOfWar').extends(gfx.sprite)

local BAYER_4X4 = {
    { 0,  8,  2, 10 },
    {12,  4, 14,  6 },
    { 3, 11,  1,  9 },
    {15,  7, 13,  5 },
}

function FogOfWar:init(map)
    self.map = map
    self.light = {}
    self:setCenter(0.5, 0.5)
    self:moveTo(0, 0)
    self:setSize(MAP_WIDTH * TILE_SIZE * ZOOM, MAP_HEIGHT * TILE_SIZE * ZOOM)
    self:setZIndex(1000)
    self:add()

    for x = 1, LIGHTING_WIDTH do
        self.light[x] = {}
        for y = 1, LIGHTING_HEIGHT do
            self.light[x][y] = 0
        end
    end
end

function FogOfWar:update()
    local playerX, playerY = player:getPosition()
    self:moveTo(playerX, playerY)
end

function FogOfWar:draw(x, y, width, height)
    local cellSize = (TILE_SIZE / 2) * ZOOM

    for lightX = 1, LIGHTING_WIDTH do
        for lightY = 1, LIGHTING_HEIGHT do
            local darkness = 3 - self.light[lightX][lightY]
            local drawX = x + (lightX - 1) * cellSize
            local drawY = y + (lightY - 1) * cellSize

            self:drawDitheredDarkness(drawX, drawY, cellSize, darkness)
        end
    end
end

function FogOfWar:clearMapLighting()
    for x = 1, LIGHTING_WIDTH do
        for y = 1, LIGHTING_HEIGHT do
            self.light[x][y] = 0
        end
    end
end

function FogOfWar:addLight(lightX, lightY, brightness)
    if not (self.light[lightX] and self.light[lightX][lightY]) then return end
    self.light[lightX][lightY] = math.min(3, self.light[lightX][lightY] + brightness)
end

function FogOfWar:drawDitheredDarkness(x, y, size, darkness)
    if darkness == 0 then return end

    gfx.setColor(gfx.kColorBlack)

    if darkness == 3 then
        gfx.fillRect(x, y, size, size)
        return
    end

    -- draw the specific dither pattern for the darkness level
    local threshold = 12 + self:getTwinkleOffset(x, y)

    for pixelY = 0, size - 1 do
        for pixelX = 0, size - 1 do
            local bayerX = (pixelX % 4) + 1
            local bayerY = (pixelY % 4) + 1
            if BAYER_4X4[bayerY][bayerX] < threshold then
                gfx.fillRect(x + pixelX, y + pixelY, 1, 1)
            end
        end
    end
end

function FogOfWar:getTwinkleOffset(x, y)
    local time = pd.getCurrentTimeMilliseconds() / 1000
    return ((math.sin(time + x + y) * 3)) % 3
end