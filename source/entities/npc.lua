import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"

import "ui/npc_chat_box"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('NPC').extends(gfx.sprite)

function NPC:init(entity, sprite)
    self:setImage(sprite)
    self:setScale(ZOOM)
    self:setCenter(0, 0)
    local px, py = GLOBAL_MAP:tileToWorld(entity.gridX, entity.gridY)
    self:setCollideRect(0, 0, entity.width * ZOOM, entity.height * ZOOM)
    self:setZIndex(1000)
    self:moveTo(px, py)
    self:add()
end

function NPC:interact()
    local chatBox = NpcChatBox("Now.. where did I put that key?")
end