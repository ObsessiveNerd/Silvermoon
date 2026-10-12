import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('NpcChatBox').extends(gfx.sprite)

function NpcChatBox:init(text)
    local uiBG = gfx.image.new("sprites/text-box")
    self:setImage(uiBG)
    self:moveTo(87, 175) -- Adjust position as needed
    self:setZIndex(1001) -- Ensure it appears above other sprites
    self:setScale(0.5)
    self.w, self.h = uiBG:getSize()
    self.x, self.y = 87, 175
    self:add()
end

function NpcChatBox:update()
    if pd.buttonJustPressed(pd.kButtonA) then
        
    end
end