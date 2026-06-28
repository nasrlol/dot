import XMonad
import System.IO

import XMonad.Util.EZConfig
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)


main :: IO ()
main = xmonad $ conf $ programs

terminal = "alacritty"

programs = do 
    xmproc <- spawnPipe "xmobar"


conf = def
    { modMask    = mod4Mask }

  `additionalKeysP`
    [ ("M-t"  , spawn "alacritty"    ),
      ("M-e"  , spawn "emacs"        ),
      ("M-b"  , spawn "firefox"      )]
