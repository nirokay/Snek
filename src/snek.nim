import raylib
import properties, globals, gamestate, palette, scores, utils

var
    arena: Arena ## Global `Arena` variable
    snake: Snake ## Global `Snake` variable


proc gameInit() =
    ## Initializes game and assets (there are none lol)
    arena = Arena()
    snake = Snake()

    arena.isRunning = true
    playerScore = 0
    arena.spawnRandomFruit(snake)

proc gameUpdate() =
    ## Updates game logic
    updateFrameCount()

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
    clearBackground(colour(colBgBlack))
    block blockRenderArena:
        drawArena arena.withSnake(snake)

    block blockRenderGameOver:
        if likely arena.isRunning:
            break blockRenderGameOver
        drawTextCentered(cstring "Game over :(", screenWidth div 2, 420 #[nice]#, fontSizeLarge, RayWhite)
        drawTextCentered(cstring "Press [Escape] to restart", screenWidth div 2, 600, fontSizeMedium, RayWhite)

    block blockRenderUI:
        drawTextCentered(cstring "Score: " & $playerScore, screenWidth div 4, 25, fontSizeScoreBoard, RayWhite)
        drawTextCentered(cstring "Highscore: " & $playerHighScore, screenWidth div 4 + screenWidth div 2, 25, fontSizeScoreBoard, RayWhite)
    endDrawing()

proc gameUnload() =
    ## Unloads all assets (there are none lol)
    discard

proc gameUpdateRender() =
    ## Game update and render loop
    updateFrameCount()
    gameUpdate()
    gameRender()

when isMainModule:
    ## Main proc with loop and error handling
    # Raylib stuff:
    initWindow(screenWidth, screenHeight, gameName & " v" & gameVersion)
    setWindowIcon(imageWindowIcon)
    setExitKey(Delete)

    # Custom stuff:
    initSaveDirectory()
    readHighScoreFromFile()

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

    # Close window:
    finally:
        Info.traceLog "Gracefully exiting"
        updatePlayerHighscore()
        closeWindow()
