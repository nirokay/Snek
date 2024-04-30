var
    frameCount*: uint
    lastUpdate*: uint

proc updateFrameCount*() =
    ## Increments the frame counter and updates the FPS
    if unlikely frameCount >= uint.high():
        frameCount = uint.low()
    frameCount.inc()
