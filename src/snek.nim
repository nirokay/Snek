import std/[strutils]
import raylib
import properties, globals, gamestate, colours, assets

var
    arena: Arena
    snake: Snake


proc gameInit() =
    ## Initializes game and assets (there are none lol)
    arena = Arena()
    snake = Snake()

    arena.isRunning = true
    arena.spawnRandomFruit(snake)

proc gameUpdate() =
    ## Updates game logic
    updateFrameCount()
    # stdout.write "\nFPS: " & $getFPS() & " | Last update: " & $lastUpdate & " | Frame-count: " & $frameCounter & "               "

    # Reset:
    if isKeyReleased(Escape): gameInit()

    if not arena.isRunning: return

    # Read snake controls:
    snake.controls()

    # Only called when movement allowed:
    if not allowSnakeMove(): return
    handlePlayerSpeedDifficulty()

    arena.update(snake)

proc gameRender() =
    ## Renders a frame
    beginDrawing()
    clearBackground(colourBackground)
    block `Draw arena`:
        drawArena arena.withSnake(snake)

    block blockRenderGameOver:
        if arena.isRunning:
            break blockRenderGameOver
        drawText(cstring "Game over :(", 0, 0, 32, RayWhite)
    endDrawing()

proc gameUnload() =
    ## Unloads all assets (there are none lol)
    discard

proc gameUpdateRender() =
    updateFrameCount()
    gameUpdate()
    gameRender()

proc main() =
    ## Main proc with loop and error handling
    initWindow(screenWidth, screenHeight, gameName & " v" & gameVersion & " by " & gameAuthors.join(", "))
    setExitKey(Delete)

    # Game loop:
    try:
        gameInit()
        when defined(emscripten):
            emscriptenSetMainLoop(gameUpdateRender, targetFPS, 1)
        else:
            setTargetFPS(targetFPS)
            while not windowShouldClose():
                gameUpdateRender()
        gameUnload()

    # Error "handling":
    #except CatchableError as e:
    #    echo "Error panic: " & $e.name & "\n" & e.msg
    #except Defect as e:
    #    echo "Defect panic: " & $e.name & "\n" & e.msg

    # Close window:
    finally:
        closeWindow()

when isMainModule:
    main()
