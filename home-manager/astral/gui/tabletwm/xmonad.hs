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
    spawn "xset r rate 250 60" -- faster hold-and-repeat
    -- spawnOnce "redshift-gtk"
    -- spawnOnce "flameshot"
    -- spawnOnce "$HOME/.config/polybar/launch.sh"
    -- spawn "$HOME/.fehbg"

myManageHook = manageDocks <+> composeAll
    [ className =? "gimp" --> doFloat
    , className =? "Vncviewer" --> doFloat
    ]

myKeybinds conf@(XConfig {XMonad.terminal = terminal, XMonad.modMask = modMask}) = 
    [ ((modMask, xK_w), kill)
    , ((modMask, xK_d), spawn "rofi -show drun")
    , ((modMask, xK_Return), spawn terminal)
    ]

myOverrideKeys c = c `removeKeys` [stroke | (stroke, _) <- kbs] `additionalKeys` kbs
    where kbs = myKeybinds c

myConfig = ewmh $ myOverrideKeys $ def 
    { modMask = win
    , terminal = "alacritty"
    , layoutHook = avoidStruts $ layoutHook def
    , manageHook = myManageHook <+> manageHook def
    , startupHook = myStartupHook
    , handleEventHook = handleEventHook def -- <+> fullscreenEventHook
    } 

main = do
    xmonad $ docks myConfig 

