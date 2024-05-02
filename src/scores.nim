import std/[os, strutils]
import globals

let
    saveDirectory*: string = getDataDir() & "/nirokay/snek/"
    saveFileHighscore*: string = saveDirectory & "highscore.dat"

proc readHighScoreFromFile*() =
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
    if not saveDirectory.dirExists():
        saveDirectory.createDir()
    if not saveFileHighscore.fileExists():
        saveFileHighscore.writeFile("0")

proc incrementPlayerScore*() =
    playerScore += playerScoreIncrement
    if playerScore > playerHighscore:
        playerHighscore = playerScore

proc writeHighscoreToFile*() =
    saveFileHighscore.writeFile($playerHighscore)

proc updatePlayerHighscore*() =
    try:
        writeHighscoreToFile()
    except IOError as e:
        echo "Failed to save highscore: " & $e.name & "\n" & e.msg
