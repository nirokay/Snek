import raylib

proc drawTextCentered*(text: string, posX: int32, posY: int32, fontSize: int32, color: Color) =
    ## Draws text centered on the X axis
    let width: int32 = measureText(text, fontSize)
    drawText(text, posX - width div 2, posY, fontSize, color)

proc rgba*(r, g, b, a: byte): Color =
    ## Shortcut for `Color(r: r, g: g, b: b, a: a)`
    result = Color(
        r: r,
        g: g,
        b: b,
        a: a
    )
proc rgb*(r, g, b: byte): Color =
    ## Shortcut for `Color(r: r, g: g, b: b, 255)`
    result = rgba(r, g, b, 255)
