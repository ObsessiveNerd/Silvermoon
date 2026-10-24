local pd <const> = playdate
local gfx <const> = playdate.graphics

import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "Corelibs/crank"

import "map"
import "shadowcasting"
import "enemies/enemy_factory"
import "ui/ui_stack"

class('World').extends()

function World:init()
    GLOBAL_MAP = Map()
end

function World:setup()
    GLOBAL_MAP:createMap()
    player:add()
end

function World:setup(levelId)
    GLOBAL_MAP:createMap(levelId)
    player:add()
end

function World:update()
    gfx.sprite.update()
    
    if GLOBAL_UISTACK:hasElements() then
        GLOBAL_UISTACK:update()
    else
        player:update()
    end
end

function World:tearDown()
    player:remove()
    GLOBAL_MAP:clearMap()
end