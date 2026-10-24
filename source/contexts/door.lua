import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"

import "map"
import "player"

local pd = playdate
local gfx = playdate.graphics

class('Door').extends()

function Door:init()
    self.x = 400 --not sure why I have to use these values
    self.y = 80

    self.image = gfx.image.new("sprites/temp-door")
    self.sprite = gfx.sprite.new(self.image)

    self.w, self.h = self.image:getSize()
    self.crankSpeed = 0.5
end

function Door:setup(entity)
    pd.display.setScale(1)
    gfx.setDrawOffset(0, 0)
    self.angle = 0
    self.sprite:setCenter(1, 0.5) -- right hinge
    self.sprite:add()
    self.sprite:moveTo(self.x, self.y)

    if entity then
        local fields = entity.fields

        self.connectedLevelId = fields.connected_level_id
        self.connectedDoorId = fields.connected_door_id
        self.doorId = fields.door_id
        self.spawnPos = fields.relative_spawn_point
    end
end

function Door:update()
    local crank = playdate.getCrankChange()

    self.angle += crank * self.crankSpeed
    self.angle = math.max(0, math.min(90, self.angle))

    self:render()
    gfx.sprite.update()

    if pd.buttonJustPressed(pd.kButtonB) then
        setContext('World')
    elseif pd.buttonJustPressed(pd.kButtonUp) then
        self:moveToNextMap()
    end
end

function Door:render()
    local angle = math.rad(self.angle)
    local sx = math.max(0.05, math.cos(angle))

    local img = self.image:scaledImage(sx, 1)

    self.sprite:setImage(img)
    self.sprite:moveTo(self.x + (self.w/2), self.y)
    self.sprite:setCenter(1, 0.5)
end

function Door:tearDown()
    self.sprite:remove()
end

function Door:isOpen()
    return self.angle >= 85
end

function Door:moveToNextMap()
    print("connected level id: " .. self.connectedLevelId)
    setContext("World", self.connectedLevelId)
    local door = GLOBAL_MAP:getDoorById(self.connectedDoorId)
    local point = door:getSpawnPosition()
    player:setPosition(point.cx + 1, point.cy + 1)
    setContext("World", self.connectedLevelId)
end