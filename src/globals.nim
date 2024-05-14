import raylib

const startingTurnsPerSecond*: float = 2.5

var
    frameCounter*: uint ## Frame counter since the game launch
    lastUpdate*: uint ## Last update (frame counter)
    turnsPerSecond*: float = startingTurnsPerSecond ## Amount of snake moves per turn ~= difficulty
    turnsPerSecondIncrement*: float = 0.1
    turnsPerSecondIncrementRate*: uint = 20

    playerScore*: uint = 0 ## Current player score
    playerScoreIncrement*: uint = 2 ## Amount of score to increment on nom nom of fruit
    playerHighscore*: uint = 0 ## Player highscore (set at game fail and game init from file)

    playerAlive*: bool = false ## Global flag if player is alive or dead

proc updateFrameCount*() =
    ## Increments the frame counter and updates the FPS
    if unlikely frameCounter >= uint.high():
        frameCounter = uint.low()
    frameCounter.inc()

proc allowSnakeMove*(): bool =
    ## Determines if the snake is allowed to make a move or not
    result = frameCounter - lastUpdate > uint(float(getFPS()) / turnsPerSecond)
    if result: lastUpdate = frameCounter

proc handlePlayerSpeedDifficulty*() =
    ## Updates `turnsPerSecond` based on score
    turnsPerSecond = startingTurnsPerSecond + turnsPerSecondIncrement * float(playerScore div uint(turnsPerSecondIncrementRate))

