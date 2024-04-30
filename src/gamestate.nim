import std/[random]
import raylib
import properties, colours
const
    pixelSize*: int = 512 ## Playing area width and height in pixels
    gridSize*: int = 8 ## Width and height of a single tile in pixels
    gridOffset*: int = screenHeight - playFieldHeight ## Offset of the playing area from the top
    tileOnAxis*: int = pixelSize div gridSize ## Amount of tiles on a single axis


# =============================================================================
# Game logic:
# =============================================================================

type
    Tile = enum
        ## Tiles
        tileSnakeHead, tileSnakeBody, tileBackground, tileFruit
    TilePosition = object
        x*, y*: 0 .. tileOnAxis
    PixelArea = object
        x1*, y1*, x2*, y2*: int
    Arena* = object
        ## Playing area
        tiles*: array[tileOnAxis, array[tileOnAxis, Tile]]

type
    Snake* = object
        tiles*: seq[TilePosition]
        onGraceFrame*, graceFrameAllowed*: bool

proc spawnFruit*(arena: var Arena) =
    var
        spawnAllowed: bool = false
        x: int
        y: int
    while not spawnAllowed:
        x = rand(0 .. tileOnAxis)
        y = rand(0 .. tileOnAxis)

        if arena.tiles[x][y] == tileBackground:
            spawnAllowed = true

    arena.tiles[x][y] = tileFruit


# =============================================================================
# Game graphics:
# =============================================================================

proc withSnake*(arena: Arena, snake: Snake): Arena =
    ## Arena with snake inside it (used for rendering)
    result = arena
    for id, tile in snake.tiles:
        result.tiles[tile.x][tile.y] = (
            if id != 0: tileSnakeBody
            else: tileSnakeHead
        )

proc toPixelArea*(position: TilePosition): PixelArea =
    result = PixelArea(
        x1: position.x * gridSize,
        y1: position.y * gridSize
    )
    result.x2 = result.x1 + gridSize
    result.y2 = result.y1 + gridSize

proc drawTile(tile: Tile, position: TilePosition) =
    let pixelArea: PixelArea = position.toPixelArea()
    case tile:
    of tileBackground: discard
    of tileSnakeBody:
        drawRectangle(
            int32 pixelArea.x1 + 1, int32 pixelArea.y1 + 1,
            int32 gridSize - 2, int32 gridSize - 2,
            colourSnake
        )
    of tileSnakeHead:
        drawRectangle(
            int32 pixelArea.x1, int32 pixelArea.y1,
            int32 gridSize, int32 gridSize,
            colourSnake
        )
    of tileFruit:
        drawRectangle(
            int32 pixelArea.x1 + 2, int32 pixelArea.y1 + 2,
            int32 gridSize - 4, int32 gridSize - 4,
            colourFruit
        )

proc drawArena*(arena: Arena) =
    ## Draws the entire arena to the screen
    for rowId, row in arena.tiles:
        for colId, tile in row:
            drawTile(tile, TilePosition(
                x: rowId, y: colId
            ))
