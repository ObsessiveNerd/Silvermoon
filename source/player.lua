import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"

import "contexts/reload"
import "revolver"
import "map"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Player').extends()

currentDirection = 'Down'

function Player:init(revolver)
    self.inventory = {
        key = 0
    }
    self.revolver = Revolver()
    playerImage = gfx.image.new("sprites/proto2")
    self.viewRadius = 8
    self.speed = 5
    self.maxHealth = 100
    self.health = 100

    self.playerSprite = gfx.sprite.new(playerImage)
    self.playerSprite:setCenter(0.5, 0.5)
    self.playerSprite:setTag(TAGS.Player)
    self.playerSprite:setZIndex(1000)
    self.playerSprite:setScale(ZOOM)

    local collisionPadding = 2
    self.playerSprite:setCollideRect(collisionPadding, collisionPadding, (TILE_SIZE * ZOOM) - collisionPadding * 2, (TILE_SIZE * ZOOM) - collisionPadding * 2) 

end

function Player:add()
    self.playerSprite:add()
    local posX, posY = GLOBAL_MAP:tileToWorld(self.tileX, self.tileY)
    local halfTileSize = (TILE_SIZE * ZOOM) / 2
    self.playerSprite:moveTo(posX + halfTileSize, posY + halfTileSize)
    self:updateCamera(posX + halfTileSize, posY + halfTileSize)
    computeFOV(self.tileX, self.tileY, self.viewRadius)
end

function Player:updateCamera(x, y)
    gfx.setDrawOffset(
            -x + 200,
            -y + 120
        )
end

function Player:getPosition()
    return self.playerSprite:getPosition()
end

function Player:getMapTilePos()
    return self.tileX, self.tileY
end

function Player:update()
    local needsUpdate = false
    local moveX = 0
    local moveY = 0
    
    if pd.buttonIsPressed(pd.kButtonUp) then
        moveY = -1
        needsUpdate = true
        currentDirection = 'Up'
    elseif pd.buttonIsPressed(pd.kButtonDown) then
        moveY = 1
        needsUpdate = true
        currentDirection = 'Down'
    end
    if pd.buttonIsPressed(pd.kButtonLeft) then
        moveX = -1
        needsUpdate = true
        currentDirection = 'Left'
    elseif pd.buttonIsPressed(pd.kButtonRight) then
        moveX = 1
        needsUpdate = true
        currentDirection = 'Right'
    end
    
    if needsUpdate then
        local x, y = self.playerSprite:getPosition()
        local goalX = x + moveX * self.speed
        local goalY = y + moveY * self.speed
        
        local actualX, actualY, collisions, numberOfCollisions = self.playerSprite:moveWithCollisions(goalX, goalY)
        for i = 1, numberOfCollisions do
            if collisions[i].other:getTag() == TAGS.Key then
                NpcChatBox("You picked up a key!")
                self.inventory.key = self.inventory.key + 1
                GLOBAL_MAP:removeEntity(collisions[i].other)
            elseif collisions[i].other:getTag() == TAGS.Door then
                local door = collisions[i].other
                door:tryOpen()
            end
        end

        local tx, ty = GLOBAL_MAP:getTilePosition(actualX, actualY)
        if tx ~= self.tileX or ty ~= self.tileY then
            self.tileX = tx
            self.tileY = ty
            computeFOV(self.tileX, self.tileY, self.viewRadius)
        end
        self:updateCamera(actualX, actualY)
    end

    if pd.buttonJustPressed(pd.kButtonA) then
        self:interactWithEnvironment()
        
    elseif pd.buttonJustPressed(pd.kButtonB) then --open inventory/reload
        setContext("Reload")
    end
end

function Player:interactWithEnvironment()
    local x, y = self.playerSprite:getPosition()
    local tileX, tileY = GLOBAL_MAP:getTilePosition(x, y)
    local interactX, interactY = tileX, tileY

    if currentDirection == 'Up' then
        interactY -= 1
    elseif currentDirection == 'Down' then
        interactY += 1
    elseif currentDirection == 'Left' then
        interactX -= 1
    elseif currentDirection == 'Right' then
        interactX += 1
    end

    local entity = GLOBAL_MAP:getEntityAtTile(interactX, interactY)
    if entity then
        entity:interact()
    end
end

function Player:takeDamage(damage)
    self.health -= damage
    if self.health <= 0 then
        print("Player has died!")
        -- Handle player death (e.g., reset game, show game over screen, etc.)
    end
end

function Player:getHealthValues()
    return self.health, self.maxHealth
end

function Player:remove()
    self.playerSprite:remove()
end

function Player:getRevolver()
    return self.revolver
end

function Player:fire()
    local x, y = self.playerSprite:getPosition()
    local xDir = 0
    local yDir = 0

    if currentDirection == 'Up' then
        yDir = -1
    elseif currentDirection == 'Down' then
        yDir = 1
    elseif currentDirection == 'Left' then
        xDir = -1
    elseif currentDirection == 'Right' then
        xDir = 1
    end
end
