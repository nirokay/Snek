import std/[os]
import raylib
import globals, properties

let
    saveDirectory*: string = getDataDir() & "/nirokay/snek/"
    saveFileHighscore*: string = saveDirectory & "highscore.dat"

if not saveDirectory.dirExists():
    saveDirectory.createDir()
if not saveFileHighscore.fileExists():
    saveFileHighscore.writeFile("0")

proc incrementPlayerScore*() =
    playerScore += playerScoreIncrement

proc writeHighscoreToFile*() =
    saveFileHighscore.writeFile($playerHighscore)

proc updatePlayerHighscore*(highscore: uint = playerScore) =
    playerHighscore = highscore
    try:
        writeHighscoreToFile()
    except CatchableError as e:
        echo "Failed to save highscore: " & $e.name & "\n" & e.msg
