import raylib

proc drawTextCentered*(text: cstring, posX: int32, posY: int32, fontSize: int32, color: Color) =
    ## Draws text centered on the X axis
    let width: int32 = measureText(text, fontSize)
    drawText(text, posX - width div 2, posY, fontSize, color)

