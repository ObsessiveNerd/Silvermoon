local pd <const> = playdate
local gfx <const> = playdate.graphics

import "CoreLibs/graphics"
import "CoreLibs/sprites"

class('UIStack').extends()

function UIStack:init()
    self.stack = {}
end

function UIStack:push(uiElement)
    table.insert(self.stack, uiElement)
end

function UIStack:pop()
    if #self.stack > 0 then
        self.stack[#self.stack]:remove() -- Remove the top element from the display
        table.remove(self.stack, #self.stack)
    end
end

function UIStack:update()
    if #self.stack > 0 then
        local topElement = self.stack[#self.stack]
        topElement:handleInput()
    end
end

function UIStack:hasElements()
    return #self.stack > 0
end