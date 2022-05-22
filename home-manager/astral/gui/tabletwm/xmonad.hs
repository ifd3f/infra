import Control.Arrow
import System.Exit
import System.IO
import Data.Map (Map)
import qualified Data.Map as M

import Graphics.X11.Xinerama (getScreenInfo)
import Graphics.X11.Xlib
import Graphics.X11.Xlib.Extras
import XMonad
import XMonad.Core (X, withDisplay, io)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Prompt
import XMonad.Prompt.ConfirmPrompt
import XMonad.Util.EZConfig
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import qualified XMonad.StackSet as W


win = mod4Mask

xdisplays :: X [Rectangle]
xdisplays = withDisplay $ io . getScreenInfo

myStartupHook = do
    setWMName "L3GD"
    spawn "xset r rate 250 60" -- faster hold-and-repeat
    spawn "systemctl restart --user polybar.service" -- faster hold-and-repeat
    spawnOnce "redshift-gtk"
    spawnOnce "flameshot"
    -- spawnOnce "$HOME/.config/polybar/launch.sh"
    -- spawn "$HOME/.fehbg"

myManageHook = manageDocks <+> composeAll
    [ className =? "gimp" --> doFloat
    , className =? "Vncviewer" --> doFloat
    ]

myKeybindsWithHelp :: XConfig Layout -> Map (ButtonMask, KeySym) (String, X ())
myKeybindsWithHelp conf@(XConfig {XMonad.terminal = terminal, XMonad.modMask = modMask}) = M.fromList $
    [ ((modMask,               xK_Return), spawn terminal) -- %! Launch terminal
    , ((modMask .|. shiftMask, xK_c     ), kill) -- %! Close the focused window

    , ((modMask,               xK_space ), sendMessage NextLayout) -- %! Rotate through the available layout algorithms
    , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf) -- %!  Reset the layouts on the current workspace to default
    , ((modMask,               xK_d     ), spawnLauncher)

    , ((modMask,               xK_n     ), refresh) -- %! Resize viewed windows to the correct size

    -- move focus up or down the window stack
    , ((modMask,               xK_Tab   ), windows W.focusDown) -- %! Move focus to the next window
    , ((modMask .|. shiftMask, xK_Tab   ), windows W.focusUp  ) -- %! Move focus to the previous window
    , ((modMask,               xK_j     ), windows W.focusDown) -- %! Move focus to the next window
    , ((modMask,               xK_k     ), windows W.focusUp  ) -- %! Move focus to the previous window
    , ((modMask,               xK_m     ), windows W.focusMaster  ) -- %! Move focus to the master window

    -- modifying the window order
    , ((modMask,               xK_Return), windows W.swapMaster) -- %! Swap the focused window and the master window
    , ((modMask .|. shiftMask, xK_j     ), windows W.swapDown  ) -- %! Swap the focused window with the next window
    , ((modMask .|. shiftMask, xK_k     ), windows W.swapUp    ) -- %! Swap the focused window with the previous window

    -- resizing the master/slave ratio
    , ((modMask,               xK_h     ), sendMessage Shrink) -- %! Shrink the master area
    , ((modMask,               xK_l     ), sendMessage Expand) -- %! Expand the master area

    -- floating layer support
    , ((modMask,               xK_t     ), withFocused $ windows . W.sink) -- %! Push window back into tiling

    -- increase or decrease number of windows in the master area
    , ((modMask .|. controlMask, xK_h     ), sendMessage (IncMasterN 1)) -- %! Increment the number of windows in the master area
    , ((modMask .|. controlMask, xK_l     ), sendMessage (IncMasterN (-1))) -- %! Deincrement the number of windows in the master area

    -- quit, or restart
    , ((modMask .|. shiftMask, xK_q     ), io (exitWith ExitSuccess)) -- %! Quit xmonad

    , ((modMask .|. shiftMask, xK_slash ), helpCommand) -- %! Run xmessage with a summary of the default keybindings (useful for beginners)
    -- repeat the binding for non-American layout keyboards
    , ((modMask              , xK_question), helpCommand) -- %! Run xmessage with a summary of the default keybindings (useful for beginners)

    -- restart/quit
    , ((modMask .|. shiftMask, xK_r     ), restartXMonad) -- Restart xmonad. Do not compile, home-manager does it for us
    , ((modMask .|. shiftMask, xK_e     ), confirmPrompt amberXPConfig "exit" $ io exitSuccess) --
    ]
    ++
    -- mod-[1..9] %! Switch to workspace N, and 0 goes to 10
    -- mod-shift-[1..9] %! Move client to workspace N
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9] ++ [xK_0])
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    -- mod-{w,e,r} %! Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r} %! Move client to screen 1, 2, or 3
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    where
        helpCommand :: X ()
        helpCommand = return () -- TODO

myKeybinds :: XConfig Layout -> Map (ButtonMask, KeySym) (X ())
myKeybinds = myKeybindsWithHelp >>> M.map (\(help, action) -> action)

restartXMonad = spawn "if type xmonad; then xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi"
spawnLauncher = spawn "rofi -show combi"

myConfig = ewmh $ def 
    { modMask = win
    , terminal = "alacritty"
    , layoutHook = avoidStruts $ layoutHook def
    , manageHook = myManageHook <+> manageHook def
    , startupHook = myStartupHook
    , keys = myKeybinds
    , handleEventHook = handleEventHook def -- <+> fullscreenEventHook
    , workspaces = map show [1 .. 10 :: Int]
    } 

main = do
    xmonad $ docks myConfig 

