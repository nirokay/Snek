import raylib

var
    frameCounter*: uint ## Frame counter since the game launch
    lastUpdate*: uint ## Last update (frame counter)
    turnsPerSecond*: uint = 2 ## Amount of snake moves per turn ~= difficulty

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
    result = frameCounter - lastUpdate > uint(uint(getFPS()) div turnsPerSecond)
    if result: lastUpdate = frameCounter

proc handlePlayerSpeedDifficulty*() =
    ## Updates `turnsPerSecond` based on score
    let speed: uint = playerScore div 50 + 2
    turnsPerSecond = speed



