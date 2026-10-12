# Dithered lighting edges

The lighting system uses a 4px source-cell grid (two cells per 8px map tile).
Rather than using alpha transparency, render darkness over the world with black
ordered-dither patterns. This suits the Playdate's 1-bit display and keeps the
edge of a light source readable without requiring hand-drawn sprites.

## Light levels

Keep `light[x][y]` as a small integer value. A simple initial scheme is:

| Brightness | Darkness overlay |
| --- | --- |
| `0` | Solid black |
| `1` | Dense black dither |
| `2` | Sparse black dither |
| `3` | No overlay (fully lit) |

The fully lit state must draw *nothing*. Drawing a white rectangle would erase
the level artwork beneath it.

## Ordered dither pattern

Use a repeating 4x4 Bayer matrix. It is stable, inexpensive, and unlike a
random pattern does not flicker as the player moves.

```lua
local BAYER_4X4 = {
    { 0,  8,  2, 10 },
    {12,  4, 14,  6 },
    { 3, 11,  1,  9 },
    {15,  7, 13,  5 },
}
```

Draw selected black pixels across the lighting cell:

```lua
local function drawDitheredDarkness(x, y, size, darkness)
    -- darkness: 0 = fully lit, 1 = slight, 2 = medium, 3 = black
    if darkness == 0 then return end

    gfx.setColor(gfx.kColorBlack)

    if darkness == 3 then
        gfx.fillRect(x, y, size, size)
        return
    end

    -- Tune these to taste. Higher threshold means more black pixels.
    local threshold = darkness == 1 and 4 or 10

    for pixelY = 0, size - 1 do
        for pixelX = 0, size - 1 do
            local patternY = (y + pixelY) % 4 + 1
            local patternX = (x + pixelX) % 4 + 1

            if BAYER_4X4[patternY][patternX] < threshold then
                gfx.fillRect(x + pixelX, y + pixelY, 1, 1)
            end
        end
    end
end
```

Use the *world draw position* in the matrix lookup (`x + pixelX`, `y +
pixelY`), not the lighting-grid indices. That lets the pattern continue across
cell boundaries instead of visibly restarting inside every 4px cell.

## Using it in `Map:updateLighting`

The lighting-cell source size is 4px. Convert it to the game's world drawing
space using `ZOOM`:

```lua
local LIGHT_CELL_SIZE = TILE_SIZE / 2
local LIGHT_CELL_WORLD_SIZE = LIGHT_CELL_SIZE * ZOOM

for x = 1, LIGHTING_WIDTH do
    for y = 1, LIGHTING_HEIGHT do
        local drawX = (x - 1) * LIGHT_CELL_WORLD_SIZE
        local drawY = (y - 1) * LIGHT_CELL_WORLD_SIZE
        local brightness = self.light[x][y]

        drawDitheredDarkness(
            drawX,
            drawY,
            LIGHT_CELL_WORLD_SIZE,
            3 - brightness
        )
    end
end
```

Clamp brightness to the `0`-`3` range when accumulating light from multiple
sources.

## Rendering order

The darkness overlay must render after terrain sprites. If it is drawn while
calculating FOV, `gfx.sprite.update()` will redraw the map on top of it.

For a temporary debugging implementation, draw it after `gfx.sprite.update()`
in `playdate.update()`. This also darkens player and entity sprites. The
finished implementation should be a custom lighting sprite with a z-index
above terrain and below the player/entities.

## When to use drawn sprites instead

Procedural dithering is the preferred default for ambient light and normal
light falloff. Use a hand-drawn sprite or texture only when a light needs a
specific artistic character, such as torch flicker/noise, smoke, or an
irregular window pattern.
