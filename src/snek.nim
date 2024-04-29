import std/[strutils]
import properties

when isMainModule:
    echo gameName & " v" & gameVersion & " by " & gameAuthors.join(", ")
