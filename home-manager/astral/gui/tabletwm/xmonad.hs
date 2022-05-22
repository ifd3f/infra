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
import Data.Traversable
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

myConfig = ewmh $ def 
    { modMask = mod4Mask
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

myKeybinds :: XConfig Layout -> Map (ButtonMask, KeySym) (X ())
myKeybinds conf@(XConfig {XMonad.terminal = terminal, XMonad.modMask = modMask}) =
    M.map (\(_, action) -> action) bindsWithHelp
    where
        spawnHelp :: X ()
        spawnHelp = do
            let entries = map (\(k, h, a) -> (k ++ " - " ++ h, a)) perKeyHelps
            result <- runProcessWithInput "rofi" ["-dmenu"] $
                intercalate "\n" $ map fst entries
            let targetEntry = takeWhile (/='\n') result  -- drop trailing newline
            case find ((==targetEntry) . fst) entries of
                Just (_, a) -> a
                Nothing -> return ()

        perKeyHelps :: [(String, String, X ())]
        perKeyHelps = sortBy (\(a, _, _) (b, _, _) -> compare a b)
            [ (buttonMaskToPrefix bm ++ keysymToString ks, help, action)
            | ((bm, ks), (help, action)) <- M.toList bindsWithHelp
            ]

        bindsWithHelp :: Map (ButtonMask, KeySym) (String, X ())
        bindsWithHelp = M.fromList bindsList

        -- TODO: check for duplicates
        bindsList :: [((ButtonMask, KeySym), (String, X ()))]
        bindsList =
            [ ((modMask,                 xK_Return), ("Launch terminal " ++ terminal, spawn terminal))
            , ((modMask .|. shiftMask,   xK_c     ), ("Close the focused window", kill))

            , ((modMask,                 xK_space ), ("Rotate through the available layout algorithms", sendMessage NextLayout))
            , ((modMask .|. shiftMask,   xK_space ), ("Reset the layouts on the current workspace to default", setLayout $ XMonad.layoutHook conf))
            , ((modMask,                 xK_d     ),  ("Spawn the default launcher", spawnLauncher))

            , ((modMask,                 xK_n     ), ("Resize viewed windows to the correct size", refresh))

            -- move focus up or down the window stack
            , ((modMask,                 xK_Tab   ), ("Move focus to the next window", windows W.focusDown))
            , ((modMask .|. shiftMask,   xK_Tab   ), ("Move focus to the previous window", windows W.focusUp  ))
            , ((modMask,                 xK_j     ), ("Move focus to the next window", windows W.focusDown))
            , ((modMask,                 xK_k     ), ("Move focus to the previous window", windows W.focusUp  ))
            , ((modMask,                 xK_m     ), ("Move focus to the master window", windows W.focusMaster  ))

            -- modifying the window order
            , ((modMask .|. shiftMask,   xK_Return), ("Swap the focused window and the master window", windows W.swapMaster))
            , ((modMask .|. shiftMask,   xK_j     ), ("Swap the focused window with the next window", windows W.swapDown  ))
            , ((modMask .|. shiftMask,   xK_k     ), ("Swap the focused window with the previous window", windows W.swapUp    ))

            -- resizing the master/slave ratio
            , ((modMask,                 xK_h     ), ("Shrink the master area", sendMessage Shrink))
            , ((modMask,                 xK_l     ), ("Expand the master area", sendMessage Expand))

            -- floating layer support
            , ((modMask,                 xK_t     ), ("Push window back into tiling", withFocused $ windows . W.sink))

            -- increase or decrease number of windows in the master area
            , ((modMask .|. controlMask, xK_h     ), ("Increment the number of windows in the master area", sendMessage (IncMasterN 1)))
            , ((modMask .|. controlMask, xK_l     ), ("Deincrement the number of windows in the master area", sendMessage (IncMasterN (-1))))

            -- quit, or restart
            , ((modMask .|. shiftMask,   xK_q     ), ("Quit XMonad", io (exitWith ExitSuccess)))

            , ((modMask,                 xK_slash ), ("Display help prompt", spawnHelp))
            -- repeat the binding for non-American layout keyboards

            -- restart/quit
            , ((modMask .|. shiftMask,   xK_r     ), ("Restart XMonad", restartXMonad))  -- note that we do not compile, home-manager does it for us
            , ((modMask .|. shiftMask,   xK_e     ), ("Quit XMonad with a prompt.", confirmPrompt amberXPConfig "exit" $ io exitSuccess))
            ]
            ++
            -- mod-[1..9] %! Switch to workspace N, and 0 goes to 10
            -- mod-shift-[1..9] %! Move client to workspace N
            [((mod .|. modMask, k), (hf wsname, windows $ wf wsname))
                | (wsname, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9] ++ [xK_0])
                , (wf, mod, hf) <- [(W.greedyView, 0, ("Switch to workspace " ++)), (W.shift, shiftMask, ("Move to workspace " ++))]]
            ++
            -- mod-{w,e,r} %! Switch to physical/Xinerama screens 1, 2, or 3
            -- mod-shift-{w,e,r} %! Move client to screen 1, 2, or 3
            [((mod .|. modMask, key), (hf sc, screenWorkspace sc >>= flip whenJust (windows . wf)))
                | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
                , (wf, mod, hf) <- [(W.view, 0, ("Switch to screen " ++) . show), (W.shift, shiftMask, ("Move to screen " ++) . show)]]

buttonMaskToPrefix :: ButtonMask -> String
buttonMaskToPrefix bm = addKey mod4Mask "M" ++ addKey controlMask "C" ++ addKey shiftMask "S" ++ addKey mod1Mask "A"
    where
        addKey tm s = if bm .&. tm /= 0 then s ++ "-" else []

restartXMonad = spawn "if type xmonad; then xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi"
spawnLauncher = spawn "rofi -show combi"

