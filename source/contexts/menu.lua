local pd <const> = playdate
local gfx <const> = playdate.graphics

import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "player"

class('Menu').extends()

local function drawSmallBoldText(text, x, y)
    local styledText = "*" .. text .. "*"
    local width, height = gfx.getTextSize(styledText)
    local image = gfx.image.new(width, height, gfx.kColorClear)
    gfx.pushContext(image)
        gfx.setColor(gfx.kColorBlack)
        gfx.drawText(styledText, 0, 0)
    gfx.popContext()
    image:drawScaled(x, y, 0.8)
end

function Menu:init()
end

function Menu:setup()
    local health, maxHealth = player:getHealthValues()
    local bullets = player:getRevolver():getBullets()
    local loaded = 0
    for _, bullet in ipairs(bullets) do
        if bullet.loaded and not bullet.emptyCasing then
            loaded += 1
        end
    end

    self.menuImg = gfx.image.new(400, 240, gfx.kColorWhite)
    gfx.pushContext(self.menuImg)
        gfx.setColor(gfx.kColorBlack)
        local cowboyIcon = gfx.image.new("sprites/temp-cowboy")
        cowboyIcon:drawScaled(20, 20, 0.5)
        local heartIcon = gfx.image.new("sprites/heart")
        local bulletIcon = gfx.image.new("sprites/menu_bullet-export")
        local keyIcon = gfx.image.new("sprites/menu_key-export")
        heartIcon:draw(8, 12)
        bulletIcon:draw(8, 36)
        keyIcon:draw(8, 60)
        drawSmallBoldText(health .. " / " .. maxHealth, 30, 14)
        drawSmallBoldText(loaded .. " / " .. #bullets, 30, 38)
        drawSmallBoldText(tostring(player.inventory.key or 0), 30, 62)
    gfx.popContext()
    pd.setMenuImage(self.menuImg)
end

function Menu:update()

end

function Menu:tearDown()
    print("menu closed!")
end
