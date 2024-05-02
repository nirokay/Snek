import raylib

type
    ColourPalette* = array[16, Color]
    ColourPaletteId* = enum
        # Background:
        colBgBlack = 0,
        colBgGrey,
        colBgGreen,
        colBgBrown,
        colBgRed,
        # Foreground:
        colFgBlack = 16,
        colFgGrey,
        colFgGreen,
        colFgBrown,
        colFgRed


const colourPalette*: ColourPalette = [
    Color(r: 10, g: 10, b: 10, a: 255),
    Color(r: 20, g: 20, b: 20, a: 255),
    Color(r: 10, g: 255, b: 10, a: 255),
    Color(r: 150, g: 20, b: 20, a: 255),
    Color(r: 200, g: 10, b: 10, a: 255),
    Color(),
    Color(),
    Color(),
    Color(),
    Color(),
    Color(),
    Color(),
    Color(),
    Color(),
    Color(),
    Color()
]

proc colour*(id: ColourPaletteId): Color =
    ## Gets a colour from the colour palette
    result = colourPalette[int id]
