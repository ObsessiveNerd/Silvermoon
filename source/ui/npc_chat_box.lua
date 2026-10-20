import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('NpcChatBox').extends(gfx.sprite)

function NpcChatBox:init(text)
    local uiBG = gfx.image.new("sprites/text-box")
    self:setImage(uiBG)
    self:setZIndex(1001) -- Ensure it appears above other sprites
    self:setScale(0.5)
    self.w, self.h = uiBG:getSize()
    self.x, self.y = 87, 175
    self:add()

    local x, y = player:getPosition()
    self:moveTo(x, y + 40) -- Adjust position as needed (this is a hardcoded number for now)
    GLOBAL_UISTACK:push(self) -- Add the chat box to the UI stack
end

function NpcChatBox:handleInput()
    if pd.buttonJustPressed(pd.kButtonA) then
        GLOBAL_UISTACK:pop() -- Remove the chat box from the UI stack
        return true
    end
end