import std/[strutils, segfaults]
import raylib
import properties, globals, gamestate

var
    arena: Arena
    player: Snake


proc gameInit() =
    ## Initializes game and assets (there are none lol)

proc gameUpdate() =
    ## Updates game logic
    let fps = getFPS()

proc gameRender() =
    ## Renders a frame
    beginDrawing()
    clearBackground(Color(r: 0, g: 0, b: 0))
    block allDrawingCalls:
        drawCircle(screenWidth div 2, screenHeight div 2, 50, RayWhite)
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
    except CatchableError as e:
        echo "Error panic: " & $e.name & "\n" & e.msg
    except Defect as e:
        echo "Defect panic: " & $e.name & "\n" & e.msg

    # Close window:
    finally:
        closeWindow()

when isMainModule:
    main()
