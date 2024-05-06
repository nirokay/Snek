import std/[os]
import raylib

# =============================================================================
# Game information:
# =============================================================================

const
    gameName*: string = "Snek"
    gameVersion*: string = "0.1.0"
    gameAuthors*: seq[string] = @["nirokay"]


# =============================================================================
# Window/Layout and Raylib information:
# =============================================================================

const
    playFieldWidth*: int32 = 1024
    playFieldHeight*: int32 = playFieldWidth

    statusBarHeight*: int32 = 100

    screenWidth*: int32 = playFieldWidth
    screenHeight*: int32 = playFieldHeight + statusBarHeight

    targetFPS*: int32 = 60


# =============================================================================
# Files:
# =============================================================================

const
    saveDirectory*: string = getDataDir() & "/nirokay/snek/"
    saveFileHighscore*: string = saveDirectory & "highscore.dat"

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

const imageRawIcon: string = readFile("assets/icon.png")
let imageWindowIconLocation: string = saveDirectory & "icon.png"

if not imageWindowIconLocation.fileExists():
    imageWindowIconLocation.writeFile(imageRawIcon)

let imageWindowIcon*: Image = block:
    var result: Image = Image()
    try:
        result = loadImage(imageWindowIconLocation)
    except CatchableError:
        echo "Failed to load window icon..."
    result
