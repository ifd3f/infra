import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.SetWMName
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig
import XMonad.Core (X, withDisplay, io)
import Graphics.X11.Xinerama (getScreenInfo)
import Graphics.X11.Xlib.Types (Rectangle)
import System.IO
import qualified XMonad.StackSet as W
import qualified Data.Map        as Map


win = mod4Mask

xdisplays :: X [Rectangle]
xdisplays = withDisplay $ io . getScreenInfo

myStartupHook = do
    setWMName "L3GD"
    spawnOnce "discord"
    spawnOnce "redshift-gtk"
    spawnOnce "flameshot"
    spawnOnce "$HOME/.config/polybar/launch.sh"
    spawn "$HOME/.fehbg"

myManageHook = manageDocks <+> composeAll
    [ className =? "gimp" --> doFloat
    , className =? "Vncviewer" --> doFloat
    ]

myKeybindsP = 
    [ ("M-w", kill)
    , ("M-d", spawn "dmenu_run")
    , ("M-S-R", spawn "xmonad --restart")
    ]

myOverrideKeys c = c `removeKeysP` [stroke | (stroke, _) <- myKeybindsP] `additionalKeysP` myKeybindsP

myConfig = ewmh $ myOverrideKeys $ def 
    { modMask = win
    , terminal = "alacritty"
    , layoutHook = avoidStruts $ layoutHook def
    , manageHook = myManageHook <+> manageHook def
    , startupHook = myStartupHook
    , handleEventHook = handleEventHook def <+> fullscreenEventHook
    } 

main = do
    xmproc <- spawnPipe "xmobar" 
    xmonad $ docks myConfig 
