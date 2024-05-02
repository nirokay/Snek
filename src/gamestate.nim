import std/[random]
import raylib
import properties, palette, scores, tiles
const
    pixelSize*: int = playFieldWidth ## Playing area width and height in pixels
    gridSize*: int = 64 ## Width and height of a single tile in pixels
    gridOffset*: int = screenHeight - playFieldHeight ## Offset of the playing area from the top
    tileOnAxis*: int = pixelSize div gridSize ## Amount of tiles on a single axis



# =============================================================================
# Game logic:
# =============================================================================

type
    Tile = enum
        ## Tiles
        tileBackground, tileSnakeHead, tileSnakeBody, tileFruit
    TileNumberRange = 0 .. tileOnAxis
    TilePosition = object
        x*, y*: TileNumberRange
    PixelArea = object
        x1*, y1*, x2*, y2*: int

    Arena* = object
        ## Playing area
        tiles*: array[tileOnAxis, array[tileOnAxis, Tile]] ## Visual tiles (for rendering)
        food*: TilePosition ## Food position
        isRunning*: bool

    SnakeDirection* = enum
        dirNone, dirUp, dirDown, dirLeft, dirRight
    Snake* = object
        tiles*: seq[TilePosition] = @[
            TilePosition(x: tileOnAxis div 2, y: tileOnAxis div 2)
        ]
        onGraceFrame*, graceFrameAllowed*: bool
        direction*, nextDirection*: SnakeDirection = dirNone
        queuedInputs*: seq[SnakeDirection]

proc withSnake*(arena: Arena, snake: Snake): Arena =
    ## Arena with snake inside it (used for rendering)
    result = arena
    for id, tile in snake.tiles:
        result.tiles[tile.x][tile.y] = (
            if id != 0: tileSnakeBody
            else: tileSnakeHead
        )

proc getHeadPosition*(snake: Snake): TilePosition =
    ## Gets the current snake head position
    result = snake.tiles[0]

proc spawnRandomFruit*(arena: var Arena, snake: Snake) =
    ## Picks a random field to spawn the next fruit, repeats until it finds an empty tile
    var
        spawnAllowed: bool = false
        x: int
        y: int
        arenaWithSnake = arena.withSnake(snake)
    block checkFreeSpace:
        for row in arenaWithSnake.tiles:
            if tileBackground in row:
                break checkFreeSpace
        echo "Lol"
        return

    while not spawnAllowed:
        x = rand(TileNumberRange.high - 1)
        y = rand(TileNumberRange.high - 1)

        if arenaWithSnake.tiles[x][y] == tileBackground:
            spawnAllowed = true

    arena.food = TilePosition(x: x, y: y)

proc processNomNom*(snake: var Snake, arena: var Arena) =
    ## Logic for eating and respawning fruit in arena
    if snake.getHeadPosition() != arena.food: return
    snake.tiles.add(snake.tiles[^1]) ## make long boi
    incrementPlayerScore()
    arena.spawnRandomFruit(snake)

proc nextSnakePosition*(snake: Snake): TilePosition =
    ## Gets the next position where the snake head would be in the next move
    var
        current: TilePosition = snake.getHeadPosition()
        x: int = current.x
        y: int = current.y

    # Calculate next position:
    case snake.direction:
    of dirNone: discard
    of dirUp: y -= 1
    of dirDown: y += 1
    of dirLeft: x -= 1
    of dirRight: x += 1

    # Prevent under-/overflowing:
    let base: int = TileNumberRange.high
    x = (x + base * 2) mod TileNumberRange.high
    y = (y + base * 2) mod TileNumberRange.high

    echo snake.tiles
    return TilePosition(x: x, y: y)

proc onGameOver*(snake: var Snake, arena: var Arena) =
    updatePlayerHighscore()
    arena.isRunning = false

proc updateMovementIn*(snake: var Snake, arena: var Arena) =
    ## Updates the whole snake position in the arena
    if snake.direction == dirNone: return
    let
        next: TilePosition = snake.nextSnakePosition()
        tail: TilePosition = snake.tiles.pop()
    discard tail

    # Lose condition:
    if next in snake.tiles:
        onGameOver(snake, arena)

    snake.tiles.insert(next, 0)

proc getNextDirection(snake: Snake): SnakeDirection =
    var nextDirection: SnakeDirection = snake.direction
    proc keyboard[V](dir: SnakeDirection, buttons: array[V, KeyboardKey]) =
        for button in buttons:
            if isKeyDown(button) or isKeyPressed(button) or isKeyPressedRepeat(button) or isKeyReleased(button): nextDirection = dir
    keyboard(dirUp, playerControlsUp)
    keyboard(dirDown, playerControlsDown)
    keyboard(dirLeft, playerControlsLeft)
    keyboard(dirRight, playerControlsRight)
    return nextDirection

proc controls*(snake: var Snake) =
    let nextDirection: SnakeDirection = getNextDirection(snake)
    if nextDirection == dirNone: return
    var allowUpdate: bool = nextDirection != (
        case snake.direction:
        of dirNone: dirNone
        of dirUp: dirDown
        of dirDown: dirUp
        of dirLeft: dirRight
        of dirRight: dirLeft
    )

    if nextDirection != snake.direction:
        echo allowUpdate, "  ", snake.direction, "  ", nextDirection

    if allowUpdate: snake.nextDirection = nextDirection

proc update*(arena: var Arena, snake: var Snake) =
    snake.direction = snake.nextDirection
    snake.updateMovementIn(arena)
    snake.processNomNom(arena)

# =============================================================================
# Game graphics:
# =============================================================================

proc toPixelArea*(position: TilePosition): PixelArea =
    result = PixelArea(
        x1: position.x * gridSize,
        y1: position.y * gridSize + gridOffset
    )
    result.x2 = result.x1 + gridSize
    result.y2 = result.y1 + gridSize

proc drawArenaTile(tile: Tile, position: TilePosition) =
    let pixelArea: PixelArea = position.toPixelArea()
    drawTile gridSize, pixelArea.x1, pixelArea.y1:
        case tile:
        of tileBackground:
            textureBackground
        of tileSnakeBody:
            textureSnakeBody
        of tileSnakeHead:
            textureSnakeHead
        of tileFruit:
            textureFruit

proc drawArena*(arena: Arena) =
    ## Draws the entire arena to the screen
    var arena = arena
    arena.tiles[arena.food.x][arena.food.y] = tileFruit
    for rowId, row in arena.tiles:
        for colId, tile in row:
            drawArenaTile(tile, TilePosition(
                x: rowId, y: colId
            ))
