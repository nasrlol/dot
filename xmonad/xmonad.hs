import XMonad
import System.IO
import XMonad.Util.EZConfig
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Layout.Spacing
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Grid
import XMonad.Layout.Magnifier

main :: IO ()
main = do
     xmproc <- spawnPipe "xmobar"
     xmonad $ docks $ conf 

term = "foot"


conf = def

    { terminal   = term
    , manageHook = manageDocks <+> manageHook def
    , layoutHook = avoidStruts $ spacingWithEdge 10 $ layout 
    }

  `removeKeysP`
    [ "M-S-<Return>"]  -- remove the default terminal binding

  `additionalKeysP`
    [ ("M-e"        , spawn "emacs"        ),
      ("M-b"        , spawn "firefox"      ),
      ("M-<Return>" , spawn "foot"         )
    ]


layout = tiled ||| Full ||| threeCol
  where
    threeCol = magnifiercz' 1.3 $ ThreeColMid nmaster delta ratio
    tiled    = Tall nmaster delta ratio
    nmaster  = 1      -- Default number of windows in the master pane
    ratio    = 1/2    -- Default proportion of screen occupied by master pane
    delta    = 3/100  -- Percent of screen to increment by when resizing panes
