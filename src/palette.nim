import raylib
import utils

type
    ColourPalette* = array[16, Color]
    ColourPaletteId* = enum
        # Background:
        colBgBlack = 0,
        colBgGrey,
        colBgGreen,
        colBgDarkGreen,
        colBgLightGreen,
        colBgBrown,
        colBgRed,
        colBgPink,
        # Foreground:
        colFgBlack = 16,
        colFgGrey,
        colFgGreen,
        colFgDarkGreen,
        colFgLightGreen
        colFgBrown,
        colFgRed,
        colFgPink,

const colourPalette*: ColourPalette = [
    rgb(10, 10, 10), # Black
    rgb(20, 20, 20), # Grey
    rgb(136, 227, 38), # Green
    rgb(112, 176, 39), # Dark Green
    rgb(169, 237, 92), # Light Green
    rgb(117, 74, 61), # Brown
    rgb(212, 10, 10), # Red
    rgb(230, 69 #[nice!]#, 98), # Pink
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
    result = colourPalette[int(id) mod 16]
