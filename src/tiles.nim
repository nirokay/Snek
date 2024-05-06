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

proc rect*(x1, y1, x2, y2: int): Rectangle = Rectangle(
    x: float x1,
    y: float y1,
    width: float(x2 - x1 + 1),
    height: float(y2 - y1 + 1)
)

const
    textureBackground* = newDrawableTile()
        # Background tile:
        .add(colBgGrey,
            rect(1, 1, 14, 14)
        )
    textureFruit* = newDrawableTile()
        # Fruit body:
        .add(colBgRed,
            rect(5, 5, 10, 12),
            rect(4, 6, 11, 11)
        )
        # Highlights:
        .add(colFgPink,
            rect(5, 8, 5, 9),
            rect(5, 7, 6, 7),
            rect(9, 10, 9, 10)
        )
        # Stem:
        .add(colFgBrown,
            rect(7, 3, 8, 5)
        )
        # Leaf:
        .add(colFgGreen,
            rect(9, 4, 11, 5)
        )
    textureSnakeBody* = newDrawableTile()
        # Body:
        .add(colBgGreen,
            # Without shadow/highlight:
            # rect(3, 2, 12, 13),
            # rect(2, 3, 13, 12)

            # With shadow/highlight
            rect(3, 3, 12, 12)
        )
        # "Shadow":
        .add(colBgDarkGreen,
            rect(13, 3, 13, 12),
            rect(3, 13, 12, 13)
        )
        # Highlight:
        .add(colBgLightGreen,
            rect(3, 2, 12, 2),
            rect(2, 3, 2, 12)
        )
    textureSnakeHead* = newDrawableTile()
        # Body:
        .add(colBgGreen,
            # Without shadow/highlight:
            # rect(2, 1, 13, 14),
            # rect(1, 2, 14, 13)

            # With shadow/highlight:
            rect(2, 2, 13, 13)
        )
        # "Shadow":
        .add(colBgDarkGreen,
            rect(14, 2, 14, 13),
            rect(2, 14, 13, 14)
        )
        # Highlight:
        .add(colBgLightGreen,
            rect(2, 1, 13, 1),
            rect(1, 2, 1, 13)
        )
        # Eyes:
        .add(colFgBlack,
            rect(4, 7, 5, 8),
            rect(10, 7, 11, 8)
        )

proc drawTile*(targetResolution: int, x, y: int, tile: DrawableTile) =
    let factor: float = float(targetResolution div tileResolution)
    for colourId, shapes in tile:
        for shape in shapes:
            var rect: Rectangle = shape
            rect.x *= factor
            rect.y *= factor
            rect.width *= factor
            rect.height *= factor
            rect.x += float x
            rect.y += float y
            drawRectangle(rect, colourPalette[colourId mod 16])
