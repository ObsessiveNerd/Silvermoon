-- Central contract between LDtk and the game.  Keep identifiers here instead
-- of scattering map-specific strings through gameplay code.
LDtkConfig = {
    projectPath = "maps/testlevel2.ldtk",
    defaultLevel = "Level_1",
    tileSize = 8,
    visualLayers = { "Ground_textures", "Unique_tiles", "Collision" },
    collisionLayer = "Collision",
    entitiesLayer = "Entities",
    collision = {
        Undrawn = 0,
        Empty = 1,
        Solid = 2,
        VisionBlocker = 3,
        MovementBlocker = 4,
    },
    entityAliases = {
        Player = "PlayerSpawn",
        Monster = "Enemy",
        KeyItem = "Item",
    }
}
