import Control.Arrow ((>>>))
import Data.List
import Data.Map (Map)
import Data.Traversable
import System.Exit
import System.IO
import Data.Bits
import Data.Word
import qualified Data.Map as M

import Graphics.X11.Xinerama (getScreenInfo)
import Graphics.X11.Xlib
import Graphics.X11.Xlib.Extras
import Graphics.X11.ExtraTypes.XF86
import Data.Traversable
import XMonad
import XMonad.Core (X, withDisplay, io)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.Reflect
import XMonad.Layout.Spacing
import XMonad.Prompt
import XMonad.Prompt.ConfirmPrompt
import XMonad.Util.EZConfig
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import qualified XMonad.StackSet as W

myConfig = ewmh $ def 
    { modMask = mod4Mask
    , terminal = "alacritty"
    , layoutHook = myLayoutHook
    , manageHook = myManageHook <+> manageHook def
    , startupHook = myStartupHook
    , keys = myKeybinds
    , borderWidth = 2
    , handleEventHook = handleEventHook def -- <+> fullscreenEventHook
    , workspaces = map show [1 .. 10 :: Int]
    } 

main = do
    xmonad $ docks myConfig 

xdisplays :: X [Rectangle]
xdisplays = withDisplay $ io . getScreenInfo

myLayoutHook = spacingWithEdge 10 $ avoidStruts $ layouts
    where
        layouts = masterLeft ||| masterRight ||| masterTop ||| Full
        masterLeft = Tall nmaster delta ratio
        masterRight = reflectHoriz masterLeft
        masterTop = Mirror masterLeft
        nmaster = 1
        ratio = 1/2
        delta = 3/100

myStartupHook = do
    setWMName "L3GD"
    spawn "xset r rate 250 60" -- faster hold-and-repeat
    spawn "systemctl restart --user polybar.service" -- faster hold-and-repeat
    spawn "$HOME/.fehbg"
    spawnOnce "redshift-gtk"
    spawnOnce "light-locker"
    spawnOnce "flameshot"

myManageHook = manageDocks <+> composeAll
    [ className =? "gimp" --> doFloat
    , className =? "Vncviewer" --> doFloat
    ]

myKeybinds :: XConfig Layout -> Map (ButtonMask, KeySym) (X ())
myKeybinds conf@(XConfig {XMonad.terminal = terminal, XMonad.modMask = modMask}) =
    M.map (\(_, action) -> action) bindsWithHelp
    where
        spawnHelp :: X ()
        spawnHelp = do
            let entries = sortBy (\(a, _) (b, _) -> compare a b)
                            [ ("<b>" ++ buttonMaskToPrefix bm ++ keysymToString ks ++ "</b> - <i>" ++ help ++ "</i>", action)
                            | ((bm, ks), (help, action)) <- M.toList bindsWithHelp
                            ]
            result <- runProcessWithInput "rofi" ["-dmenu", "-markup-rows"] $
                intercalate "\n" $ map fst entries
            let targetEntry = takeWhile (/='\n') result  -- drop trailing newline
            case find ((==targetEntry) . fst) entries of
                Just (_, a) -> a
                Nothing -> return ()

        bindsWithHelp :: Map (ButtonMask, KeySym) (String, X ())
        bindsWithHelp = M.fromList bindsList

        -- TODO: check for duplicates
        bindsList :: [((ButtonMask, KeySym), (String, X ()))]
        bindsList =
            [ ((modMask,                 xK_Return), ("Launch terminal " ++ terminal, spawn terminal))
            , ((modMask .|. shiftMask,   xK_q     ), ("Close the focused window", kill))

            , ((modMask,                 xK_space ), ("Rotate through the available layout algorithms", sendMessage NextLayout))
            , ((modMask .|. shiftMask,   xK_space ), ("Reset layouts on the current workspace to default", setLayout $ XMonad.layoutHook conf))
            , ((modMask,                 xK_d     ), ("Spawn launcher", spawnLauncher))

            , ((modMask,                 xK_n     ), ("Resize viewed windows to the correct size", refresh))

            -- move focus up or down the window stack
            , ((modMask,                 xK_Tab   ), ("Focus next window", windows W.focusDown))
            , ((modMask .|. shiftMask,   xK_Tab   ), ("Focus previous window", windows W.focusUp))
            , ((modMask,                 xK_j     ), ("Focus next window", windows W.focusDown))
            , ((modMask,                 xK_k     ), ("Focus previous window", windows W.focusUp))
            , ((modMask,                 xK_m     ), ("Focus master window", windows W.focusMaster))

            -- modifying the window order
            , ((modMask .|. shiftMask,   xK_Return), ("Swap focused window and master window", windows W.swapMaster))
            , ((modMask .|. shiftMask,   xK_j     ), ("Swap focused window with next window", windows W.swapDown))
            , ((modMask .|. shiftMask,   xK_k     ), ("Swap focused window with previous window", windows W.swapUp))

            -- resizing the master/slave ratio
            , ((modMask,                 xK_h     ), ("Shrink master area", sendMessage Shrink))
            , ((modMask,                 xK_l     ), ("Expand master area", sendMessage Expand))

            -- floating layer support
            , ((modMask .|. shiftMask,   xK_f     ), ("Float window", withFocused toggleFloat))

            -- increase or decrease number of windows in the master area
            , ((modMask .|. controlMask, xK_h     ), ("More windows in master area", sendMessage (IncMasterN 1)))
            , ((modMask .|. controlMask, xK_l     ), ("Less windows in master area", sendMessage (IncMasterN (-1))))

            -- a help prompt for convenience
            , ((modMask,                 xK_slash ), ("Display help prompt", spawnHelp))

            -- session controls
            , ((modMask .|. controlMask, xK_r     ), ("Restart XMonad", restartXMonad))  -- note that we do not compile, home-manager does it for us
            , ((modMask .|. controlMask, xK_e     ), ("Quit XMonad with a prompt", confirmPrompt amberXPConfig "exit" $ io exitSuccess))
            , ((modMask .|. controlMask, xK_semicolon), ("Lock session", spawn "light-locker-command -l"))

            -- screenshot utilities
            , ((0,                       xK_Print ), ("Full screenshot", spawn "flameshot full"))
            , ((controlMask,             xK_Print ), ("Region screenshot", spawn "flameshot gui"))

            -- media keys
            , ((0, xF86XK_AudioRaiseVolume), ("Raise audio volume", spawn "pactl set-sink-volume @DEFAULT_SINK@ +2%"))
            , ((0, xF86XK_AudioLowerVolume), ("Lower audio volume", spawn "pactl set-sink-volume @DEFAULT_SINK@ -2%"))
            , ((0, xF86XK_AudioMute       ), ("Toggle audio mute", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle"))
            ]
            ++
            -- mod-[1..9] %! Switch to workspace N, and 0 goes to 10
            -- mod-shift-[1..9] %! Move client to workspace N
            [((mod .|. modMask, k), (hf wsname, windows $ wf wsname))
                | (wsname, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9] ++ [xK_0])
                , (wf, mod, hf) <- [(W.greedyView, 0, ("Focus workspace " ++)), (W.shift, shiftMask, ("Move window to workspace " ++))]]
            ++
            -- mod-{w,e,r} %! Switch to physical/Xinerama screens 1, 2, or 3
            -- mod-shift-{w,e,r} %! Move client to screen 1, 2, or 3
            [((mod .|. modMask, key), (hf sc, screenWorkspace sc >>= flip whenJust (windows . wf)))
                | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
                , (wf, mod, hf) <- [(W.view, 0, ("Focus screen " ++) . show), (W.shift, shiftMask, ("Move window to screen " ++) . show)]]

toggleFloat w = windows (\s -> if M.member w (W.floating s)
    then W.sink w s
    else (W.float w (W.RationalRect (1/3) (1/4) (1/2) (4/5)) s))

buttonMaskToPrefix :: ButtonMask -> String
buttonMaskToPrefix bm = addKey mod4Mask "M" ++ addKey controlMask "C" ++ addKey shiftMask "S" ++ addKey mod1Mask "A"
    where
        addKey tm s = if bm .&. tm /= 0 then s ++ "-" else []

restartXMonad = spawn "if type xmonad; then xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi"
spawnLauncher = spawn "rofi -show combi"

