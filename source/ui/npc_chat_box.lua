import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('NpcChatBox').extends(gfx.sprite)

function NpcChatBox:init(text)
    local CHAT_FONT = gfx.font.new("fonts/chat-small")

    self.background = gfx.image.new("sprites/text-box")
    self.w, self.h = self.background:getSize()

    local x, y = player:getPosition()
    self:moveTo(x, y + 40) -- Adjust position as needed (this is a hardcoded number for now)
    GLOBAL_UISTACK:push(self) -- Add the chat box to the UI stack

    local image = gfx.image.new(self.w, self.h)
    gfx.pushContext(image)
        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
        gfx.setFont(CHAT_FONT)
        gfx.drawTextInRect(
            text,
            12, 10,              -- inner top-left padding
            self.w - 24, self.h - 20
        )
        gfx.setImageDrawMode(gfx.kDrawModeCopy)
    gfx.popContext()
    
    self:setImage(self.background)
    self:setZIndex(1001) -- Ensure it appears above other sprites
    self:setScale(0.5)
    self:add()
    
    local textSprite = gfx.sprite.new(image)
    textSprite:setZIndex(1002) -- Ensure it appears above the background
    textSprite:moveTo(x, y + 40) -- Adjust position as needed (this is a hardcoded number for now)
    textSprite:add()

end

function NpcChatBox:handleInput()
    if pd.buttonJustPressed(pd.kButtonA) then
        GLOBAL_UISTACK:pop() -- Remove the chat box from the UI stack
        return true
    end
end