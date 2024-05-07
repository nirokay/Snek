# Package

version       = "0.1.0"
author        = "nirokay"
description   = "A basic snake game."
license       = "GPL-3.0-only"
srcDir        = "src"
bin           = @["snek"]
installExt    = @["png"]

# Dependencies

requires "nim >= 2.0.0"
requires "naylib"
