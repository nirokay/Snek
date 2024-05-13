import std/[os, strutils]
import globals, properties

proc readHighScoreFromFile*() =
    ## Reads the highscore file from the saves directory and attempts to parse it
    var
        rawContent: string = "0"
        highscore: int = 0
    try:
        rawContent = saveFileHighscore.readFile().strip()
    except IOError:
        echo "Could not open save file"
    try:
        highscore = rawContent.parseInt()
    except ValueError:
        echo "Could not parse highscore file"
    try:
        playerHighscore = uint highscore
    except CatchableError:
        echo "Invalid save file data"


proc initSaveDirectory*() =
    ## Creates the save directory and the highscore file if they do not exist
    if not saveDirectory.dirExists():
        saveDirectory.createDir()
    if not saveFileHighscore.fileExists():
        saveFileHighscore.writeFile("0")

proc incrementPlayerScore*() =
    ## Adds to the player score and updates the highscore when a new one is reached
    playerScore += playerScoreIncrement
    if playerScore > playerHighscore:
        playerHighscore = playerScore

proc writeHighscoreToFile() =
    ## Writes the highscore to the highscore file
    saveFileHighscore.writeFile($playerHighscore)
proc updatePlayerHighscore*() =
    ## Attempts to update the highscore file
    try:
        writeHighscoreToFile()
    except IOError as e:
        echo "Failed to save highscore: " & $e.name & "\n" & e.msg
