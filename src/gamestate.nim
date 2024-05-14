import std/[random, algorithm]
import raylib
import properties, scores, tiles
const
    pixelSize*: int = playFieldWidth ## Playing area width and height in pixels
    gridSize* {.intdefine.}: int = 48 ## Width and height of a single tile in pixels
    gridOffset*: int = screenHeight - playFieldHeight ## Offset of the playing area from the top
    tileOnAxis*: int = pixelSize div gridSize ## Amount of tiles on a single axis
    spaceOnSides*: int = screenWidth - tileOnAxis * gridSize ## Empty space on left, right side and bottom
    spaceOnSide*: int = spaceOnSides div 2 ## Empty space on one side

# =============================================================================
# Game logic:
# =============================================================================

type
    Tile = enum
        ## Enum of all tiles in the game
        tileBackground, tileSnakeHead, tileSnakeBody, tileFruit
    TileNumberRange = 0 .. tileOnAxis ## Range of axis tiles
    TilePosition = object
        ## `x` and `y` for a tile in its bounding axises
        x*, y*: TileNumberRange
    PixelArea = object
        ## Cutout of the screen for the game area
        x1*, y1*, x2*, y2*: int

    Arena* = object
        ## Playing area
        tiles*: array[tileOnAxis, array[tileOnAxis, Tile]] ## Visual tiles (for rendering)
        food*: TilePosition ## Food position
        isRunning*: bool ## Player alive + accept snake movement input

    SnakeDirection* = enum
        dirNone, dirUp, dirDown, dirLeft, dirRight
    Snake* = object
        tiles*: seq[TilePosition] = @[
            TilePosition(x: tileOnAxis div 2, y: tileOnAxis div 2)
        ]
        onGraceFrame*: bool
        direction*, nextDirection*: SnakeDirection = dirNone


proc withSnake*(arena: Arena, snake: Snake): Arena =
    ## Arena with snake inside it (used for rendering)
    result = arena

    # Reversed, so the snake head is drawn at the end (when self-nom-nom, it will still have a head):
    for id, tile in snake.tiles.reversed():
        result.tiles[tile.x][tile.y] = (
            if id != snake.tiles.len() - 1: tileSnakeBody
            else: tileSnakeHead
        )

proc getHeadPosition*(snake: Snake): TilePosition =
    ## Gets the current snake head position
    result = snake.tiles[0]

proc spawnRandomFruit*(arena: var Arena, snake: Snake) =
    ## Picks a random field to spawn the next fruit, repeats until it finds an empty tile
    var
        arenaWithSnake = arena.withSnake(snake)
        availableSpaces: seq[TilePosition]

    # Loop over every tile, add free tiles to `availableSpaces`, doubles as a
    # check if every tile is occupied, which is, well... unlikely... however
    # an impressive sign of dedication...
    for rowId, row in arenaWithSnake.tiles:
        for colId, tile in row:
            if tile == tileBackground:
                availableSpaces.add TilePosition(x: rowId, y: colId)

    if unlikely availableSpaces.len() == 0:
        echo "lol"
        return

    arena.food = availableSpaces[rand(availableSpaces.len() - 1)]

proc processNomNom*(snake: var Snake, arena: var Arena) =
    ## Logic for eating and respawning fruit in arena
    if likely snake.getHeadPosition() != arena.food:
        return
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

    return TilePosition(x: x, y: y)

proc onGameOver*(snake: var Snake, arena: var Arena) =
    ## Triggered on snake death
    updatePlayerHighscore()
    arena.isRunning = false

proc updateMovementIn*(snake: var Snake, arena: var Arena) =
    ## Updates the whole snake position in the arena
    if snake.direction == dirNone: return
    let next: TilePosition = snake.nextSnakePosition()

    if likely(not snake.onGraceFrame):
        if unlikely next in snake.tiles:
            snake.onGraceFrame = true
            return
    else:
        snake.onGraceFrame = false

    discard snake.tiles.pop()

    # Lose condition:
    if next in snake.tiles:
        onGameOver(snake, arena)

    snake.tiles.insert(next, 0)

proc getNextDirection(snake: Snake): SnakeDirection =
    ## Gets the next direction for the snake
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
    ## Processes the controls for the snake
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

    if allowUpdate: snake.nextDirection = nextDirection

proc update*(arena: var Arena, snake: var Snake) =
    ## Updates the arena and snake
    snake.direction = snake.nextDirection
    snake.updateMovementIn(arena)
    snake.processNomNom(arena)

# =============================================================================
# Game graphics:
# =============================================================================

proc toPixelArea*(position: TilePosition): PixelArea =
    result = PixelArea(
        x1: position.x * gridSize + spaceOnSide,
        y1: position.y * gridSize + gridOffset + spaceOnSide
    )
    result.x2 = result.x1 + gridSize
    result.y2 = result.y1 + gridSize

proc drawArenaTile(tile: Tile, position: TilePosition) =
    let pixelArea: PixelArea = position.toPixelArea()
    drawTile gridSize, pixelArea.x1, pixelArea.y1:
        case tile:
        of tileBackground: textureBackground
        of tileSnakeBody: textureSnakeBody
        of tileSnakeHead: textureSnakeHead
        of tileFruit: textureFruit

proc drawArena*(arena: Arena) =
    ## Draws the entire arena to the screen
    var arena = arena
    arena.tiles[arena.food.x][arena.food.y] = tileFruit
    for rowId, row in arena.tiles:
        for colId, tile in row:
            drawArenaTile(tile, TilePosition(
                x: rowId, y: colId
            ))
