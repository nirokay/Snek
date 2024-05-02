import std/[sequtils]
import raylib
import palette

const tileResolution*: int = 16

type DrawableTile* = array[32, seq[Rectangle]] ## Colour ID to sequence of rectangles

proc newDrawableTile(): DrawableTile =
    ## Gets a new drawable tile

proc add(tile: DrawableTile, id: ColourPaletteId, shapes: seq[Rectangle]): DrawableTile =
    result = tile
    result[int id] = shapes
proc add(tile: DrawableTile, id: ColourPaletteId, shapes: varargs[Rectangle]): DrawableTile =
    result = add(tile, id, shapes.toSeq())

proc rect*(x, y, width, height: int): Rectangle = Rectangle(
    x: float x,
    y: float y,
    width: float width,
    height: float height
)

const
    textureBackground* = newDrawableTile()
        .add(colBgGrey,
            rect(1, 1, 14, 14)
        )
    textureFruit* = newDrawableTile()
        .add(colBgRed,
            rect(4, 4, 8, 8)
        )
        .add(colFgBrown,
            rect(7, 1, 2, 4)
        )
        .add(colFgGreen,
            rect(9, 2, 3, 2)
        )
    textureSnakeBody* = newDrawableTile()
        .add(colBgGreen,
            rect(2, 2, 12, 12)
        )
    textureSnakeHead* = newDrawableTile()
        .add(colBgGreen,
            rect(1, 1, 14, 14)
        )
        .add(colFgBlack,
            rect(4, 7, 2, 2),
            rect(10, 7, 2, 2)
        )

proc drawTile*(targetResolution: int, x, y: int, tile: DrawableTile) =
    let factor: float = float(targetResolution div tileResolution)
    for colourId, shapes in tile:
        let colourId = colourId mod 16
        for shape in shapes:
            var rect: Rectangle = shape
            rect.x *= factor
            rect.y *= factor
            rect.width *= factor
            rect.height *= factor
            rect.x += float x
            rect.y += float y
            echo rect
            drawRectangle(rect, colourPalette[colourId])
