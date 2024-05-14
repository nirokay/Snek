import std/[os, strutils]
import raylib

# =============================================================================
# Game information:
# =============================================================================

const
    gameName*: string = "Snek" ## Game name (window name)
    gameVersion*: string = "1.0.0" ## Game version (window name)
    gameAuthors*: seq[string] = @["nirokay"] ## Game authors (NOT in window name)


# =============================================================================
# Window/Layout and Raylib information:
# =============================================================================

const
    playFieldWidth* {.intdefine.}: int32 = 1024 ## Playing area width
    playFieldHeight*: int32 = playFieldWidth ## Playing area height (same as width)

    statusBarHeight* {.intdefine.}: int32 = 100 ## Height of the status bar at the top

    screenWidth*: int32 = playFieldWidth ## Screen width
    screenHeight*: int32 = playFieldHeight + statusBarHeight ## Screen height

    targetFPS* {.intdefine.}: int32 = 60 ## Target fps (should not fuck with the update speed)


# =============================================================================
# Files:
# =============================================================================

let
    saveDirectory*: string = getDataDir() / "nirokay" / gameName.toLower() ## Game save directory, depends on the user OS
    saveFileHighscore*: string = saveDirectory / "highscore.dat" ## Highscore save file

# =============================================================================
# Controls:
# =============================================================================

const
    playerControlsUp* = [
        KeyboardKey.Up,    # arrow keys
        KeyboardKey.W,     # wasd
        KeyboardKey.K,     # Vim controls
        KeyboardKey.Kp8    # Numpad
    ]
    playerControlsDown* = [
        KeyboardKey.Down,  # arrow keys
        KeyboardKey.S,     # wasd
        KeyboardKey.J,     # Vim controls
        KeyboardKey.Kp2    # Numpad
    ]
    playerControlsLeft* = [
        KeyboardKey.Left,  # arrow keys
        KeyboardKey.A,     # wasd
        KeyboardKey.H,     # Vim controls
        KeyboardKey.Kp6    # Numpad
    ]
    playerControlsRight* = [
        KeyboardKey.Right, # arrow keys
        KeyboardKey.D,     # wasd
        KeyboardKey.L,     # Vim controls
        KeyboardKey.Kp4    # Numpad
    ]


# =============================================================================
# Fonts:
# =============================================================================

const
    fontSizeLarge*: int32 = 128
    fontSizeMedium*: int32 = 64
    fontSizeTiny*: int32 = 32
    fontSizeScoreBoard*: int32 = 48


# =============================================================================
# Images:
# =============================================================================

# Idk what the fuck I am doing here:
const imageRawIcon: string = block:
    let locations: seq[string] = @[
        "assets" / "icon.png",
        "src" / "assets" / "icon.png"
    ]
    var validPath: string
    for location in locations:
        if not location.fileExists(): continue
        validPath = location
        break
    if validPath == "":
        ""
    else:
        readFile(validPath)

let imageWindowIconLocation: string = saveDirectory / "icon.png" ## Window icon location

if not imageWindowIconLocation.fileExists():
    try:
        imageWindowIconLocation.writeFile(imageRawIcon)
    except CatchableError:
        echo "Failed to write icon image to save directory"

let imageWindowIcon*: Image = block:
    var result: Image = Image()
    try:
        result = loadImage(imageWindowIconLocation)
    except CatchableError:
        echo "Failed to load window icon..."
    result
