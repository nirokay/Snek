# Package

version       = "1.0.1"
author        = "nirokay"
description   = "A basic snake game."
license       = "GPL-3.0-only"
srcDir        = "src"
bin           = @["snek"]

# I do not know what i am doing:
installExt    = @["png"]
installDirs   = @["assets"]
installFiles  = @["assets/icon.png"]

# Dependencies

requires "nim >= 2.0.0"
requires "naylib"
