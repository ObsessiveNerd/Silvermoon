import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"

import "map"
import "ui/npc_chat_box"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('DoorWorld').extends(gfx.sprite)

function DoorWorld:init(entity)
    self.entity = entity
    self.doorId = entity.fields.door_id
    print("doorid: " .. entity.fields.door_id)
    self.locked = true;
    self.isOpen = false;

    self:setTag(TAGS.Door)
    self:setImage(GLOBAL_MAP:getEntityImage(entity))
    local px, py = GLOBAL_MAP:tileToWorld(entity.gridX, entity.gridY)

    self:setCollideRect(0, 0, entity.width * ZOOM, entity.height * ZOOM)
    self:setCenter(0, 0)
    self:moveTo(px, py)
    self:setScale(ZOOM)
    self:setZIndex(1000)
    self:add()
end

function DoorWorld:tryOpen()
    if self.locked and player.inventory.key == 0 then
        NpcChatBox("Door is locked!")
        return
    elseif self.locked and player.inventory.key > 0 then
        player.inventory.key -= 1
        self.locked = false
        NpcChatBox("You unlocked the door with a key!", 
            function() 
                self:remove()
                setContext("Door", self.entity) end)
    else
        self:remove()
        setContext("Door", self.entity)
    end
end

function DoorWorld:getSpawnPosition()
    return self.entity.fields.relative_spawn_point
end