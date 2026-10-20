import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('NpcChatBox').extends(gfx.sprite)

function NpcChatBox:init(text)
    self.background = gfx.image.new("sprites/text-box")
    self.w, self.h = self.background:getSize()

    local x, y = player:getPosition()
    self:moveTo(x, y + 80) -- Adjust position as needed (this is a hardcoded number for now)
    GLOBAL_UISTACK:push(self) -- Add the chat box to the UI stack

    local image = gfx.image.new(self.w, self.h)
    gfx.pushContext(image)
        self.background:draw(0, 0)
        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
        gfx.drawTextInRect(
            text,
            12, 10,              -- inner top-left padding
            self.w - 24, self.h - 20
        )
        gfx.setImageDrawMode(gfx.kDrawModeCopy)
    gfx.popContext()
    
    self:setImage(image)
    self:setZIndex(1002) -- Ensure it appears above other sprites
    self:add()
end

function NpcChatBox:handleInput()
    if pd.buttonJustPressed(pd.kButtonA) then
        GLOBAL_UISTACK:pop() -- Remove the chat box from the UI stack
        return true
    end
end