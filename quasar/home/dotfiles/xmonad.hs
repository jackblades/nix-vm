{-# LANGUAGE LambdaCase #-}

module Main (main) where

-- TODO dynamic workspaces
-- TODO 

------------------------------------------------------------------------------
-- XMonad.Actions.FloatSnap
import qualified Data.Tree as Tree 
import qualified Data.List as L (find, findIndex, tails)
import qualified Data.Monoid as Monoid

import System.Exit
import System.Environment (getArgs)
import Control.Monad (replicateM_, when, filterM)
import System.IO (hPutStrLn, stderr)

import XMonad
import XMonad.Actions.Commands
import XMonad.Actions.CycleWS
import XMonad.Actions.RotSlaves
import XMonad.Actions.Search
import XMonad.Actions.Warp (banish, Corner(UpperLeft))
import XMonad.Actions.WindowGo
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.FadeWindows (isFloating)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ServerMode
import XMonad.Layout.BinarySpacePartition (emptyBSP)
import XMonad.Layout.Fullscreen (fullscreenManageHook)
import XMonad.Layout.Grid
import XMonad.Layout.MouseResizableTile
import XMonad.Layout.MultiToggle as MT
import XMonad.Layout.MultiToggle.Instances as MTI
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing -- (spacingRaw, Border)
import XMonad.Layout.ResizableTile (ResizableTall(..))
import XMonad.Layout.ThreeColumns
import XMonad.Prompt
import XMonad.Prompt.ConfirmPrompt
import XMonad.Prompt.Shell
import XMonad.Util.EZConfig
import XMonad.Util.Paste
import XMonad.Util.SpawnOnce
import XMonad.Util.WindowProperties

import qualified XMonad.Core as XM (Query)
import qualified XMonad.Layout.Magnifier as Magnifier
import qualified XMonad.StackSet as W

------------------------------------------------------------------------------
-- | xmonad server client cmds
cmds :: [(String, X ())]
cmds = 
  [ ("apps", rofiApps)
  , ("calendar", spawn "/etc/settings-calendar")
  , ("network", spawn "/etc/settings-network")
  , ("power", spawn "/etc/settings-power")
  , ("sound", spawn "/etc/settings-sound")
  , ("colorinvert", spawn "xcalib -i -a")
  , ("layout", sendMessage NextLayout)
  , ("layout-magnify", sendMessage Magnifier.Toggle)
  , ("layout-full", sendMessage (MT.Toggle FULL) >> raiseFocusedWindow)
  , ("ws-next", moveTo Next NonEmptyWS)
  , ("ws-prev", moveTo Prev NonEmptyWS)
  , ("win-next", rotAllUp)
  , ("win-prev", rotAllDown)
  ]

rofiApps = spawn "/run/current-system/sw/bin/rofi -show drun -modi drun,window,ssh -show-icons -sidebar-mode -columns 3 -p apps -config /etc/rofi/config -theme /etc/rofi/nord.rasi"

------------------------------------------------------------------------------
-- | setup client/server and args
main = getArgs >>= \case
  [] -> wmserver
  "client":c:args -> sendCommand c
  _ -> return ()

-- xmonad client
wmserver = do
  spawn "systemctl --user restart quasar-topbar"

  let config = rootConfig `additionalKeysP` keyConfig
  -- ewmh is needed to get window info in bar
  xmonad $ ewmh config
  
-- xmonad server
rootConfig = desktopConfig
  { modMask = mod4Mask -- win key
  -- window borders
  , borderWidth = 0
  , focusedBorderColor = "#000000"
  -- xmonad startup
  , startupHook = do
      -- spawnOnce "systemctl --user restart quasar-terminal"
      startupHook desktopConfig
  , layoutHook = myLayouts
  -- on create window
  , manageHook = fullscreenManageHook
      <+> myManageHook 
      <+> manageHook desktopConfig
  -- on windowset change (focus change)
  , logHook = do
      dynamicLogString def >>= xmonadPropLog
      raiseFocusedIfFloating
  -- on general event
  , handleEventHook = fullscreenEventHook 
      <+> docksEventHook 
      <+> serverModeEventHookCmd' (return cmds) 
      <+> handleEventHook def
  }
      
------------------------------------------------------------------------------
-- | Customize layouts.
myLayouts = mkToggle (FULL ?? EOT)
  $ avoidStruts  -- no overlap dock, except when fullscreen
  $ mkToggle (single MIRROR)
  $ spaced . magnified
  $ mouseResizable ||| threeColumns ||| Grid
  where
    d = 3
    spaced = spacingRaw True (Border d d d d) True (Border d d d d) True
    -- Magnifier.magnifiercz' 1.5  -- magnify the focused widow
    magnified = Magnifier.magnifierOff  
    mouseResizable = mouseResizableTile { masterFrac = 0.6 }
    threeColumns = ThreeColMid 1 (3/100) (1/2)

------------------------------------------------------------------------------
-- | Manipulate windows as they are created.
-- @composeOne@ processes first-match from top to bottom
-- Use the `xprop' tool to get the info you need for these matches.
myManageHook = composeOne
  [ className =? "Tilda" -?> doFloat
  , appName =? "Terminator Preferences" -?> doFloat
  , className =? ".terminator-wrapped" -?> rectFloat 0 0 1 1
  -- control applications
  , className =? "Pavucontrol" -?> rectFloat 0.44 0.04 0.55 0.5
  , className =? ".blueman-manager-wrapped" -?> rectFloat 0.23 0.04 0.20 0.5
  , className =? "Lxappearance" -?> rectFloat 0.01 0.2 0.4 0.6
  , className =? "Wicd-client.py" -?> rectFloat 0.59 0.2 0.4 0.6
  -- generic actions 
  -- , isFullscreen -?> doFullFloat
  , isDialog -?> doCenterFloat
  -- Move transient windows to their parent:
  , transience
  ] where 
      fullscreenRect = rectFloat 0 0 1 1
      rectFloat x y w h = doRectFloat $ W.RationalRect x y w h

------------------------------------------------------------------------------
ifTerminal t f = 
  ifWindows (className =? ".terminator-wrapped") (\_ -> t) f

ifNotTermSend k a = ifTerminal (sendKey noModMask k) a

-- | Keybindings
keyConfig = 
  [ ("M-S-q",   shellPrompt promptConfig)
  -- , ("M-S-q",   confirmPrompt promptConfig "exit" (io exitSuccess))

  -- fast actions bound to f-keys
  -- , ("<F1>",)   -- used by terminator
  , ("<F2>", sendMessage NextLayout)
  , ("<F3>", sendMessage Magnifier.Toggle) 
  , ("<F4>", kill) 
  , ("<F5>", rotAllUp) 
  , ("<F6>", windows W.focusDown) 
  , ("<F7>", shiftToPrev >> prevWS) 
  , ("<F8>", shiftToNext >> nextWS) 
  , ("<F9>", moveTo Next NonEmptyWS) 
  , ("<F10>", moveTo Next EmptyWS) 
  , ("<F11>", sendMessage (MT.Toggle FULL) >> raiseFocusedWindow >> sendKey noModMask xK_F11)
  , ("<F12>", rofiApps)   

  , ("<Print>", spawn "scrot window_%Y-%m-%d-%H-%M-%S.png -d 1-u -e 'mv $f /run/media/external/quasar/screenshot/'")   
  
  
  -- mouse actions
  , ("M-m", banish UpperLeft)
  
  -- cycle windows
  , ("M-<Tab>", rotAllUp)  -- TODO handle floating better
  , ("M-S-<Tab>", rotAllDown)
  , ("M-S-`", windows W.focusUp)
  , ("M-`", windows W.focusDown)
  
  -- move windows across workspaces
  , ("M-<Right>", moveTo Next NonEmptyWS)
  , ("M-<Left>", moveTo Prev NonEmptyWS)
  , ("M-S-<Right>", shiftToNext >> nextWS)
  , ("M-S-<Left>", shiftToPrev >> prevWS)
  
  -- manage windows
  , ("M-w",   kill)
  
  -- switch layouts
  , ("M-z", sendMessage NextLayout)
  , ("M-f", sendMessage (MT.Toggle FULL) >> raiseFocusedWindow >> sendKey noModMask xK_F11)
  , ("M-x", sendMessage (MT.Toggle MIRROR))
  , ("M-a", sendMessage Magnifier.Toggle)
  
  -- desktop launcher and terminal
  , ("M-<Space>", spawn "rofi -show drun -modi drun,window,ssh -show-icons -sidebar-mode -columns 3 -p apps -config /etc/rofi/config -theme /etc/rofi/nord.rasi")
  , ("M-S-<Space>", spawn "rofi-theme-selector")
  , ("M-S-<Return>", spawn "pgrep terminator || terminator")

  -- apps
  , ("M-e", spawn "thunar ~")
  , ("M-S-e", spawn "thunar /run/media/external")
  
  -- system commands
  , ("M-l", spawn "xautolock -locknow")

  -- music
  , ("<XF86AudioPlay>", spawn "deadbeef --play-pause")    
  , ("<XF86AudioStop>", spawn "deadbeef --toggle-pause")    
  , ("<XF86AudioPrev>", spawn "deadbeef --prev")    
  , ("<XF86AudioNext>", spawn "deadbeef --next")    
  
  -- audio
  , ("<XF86AudioRaiseVolume>", spawn "/etc/settings-volume-set +1.5%")
  , ("<XF86AudioLowerVolume>", spawn "/etc/settings-volume-set -1.5%")
  , ("<XF86AudioMute>", spawn "/etc/settings-volume-mute") 
  
  -- display, brightness and color
  , ("M-i", spawn "xcalib -i -a")
  , ("<XF86MonBrightnessUp>", spawn "/etc/settings-brightness +7%")
  , ("<XF86MonBrightnessDown>", spawn "/etc/settings-brightness -7%")    

  ]


------------------------------------------------------------------------------
-- | util functions

raiseFocusedWindow :: X ()
raiseFocusedWindow = 
  withDisplay $ \d ->
    withFocused $ \w ->
      io $ raiseWindow d w
  -- raiseWindow :: Display -> Window -> IO () 

raiseFocusedWindowConditional :: (Window -> X Bool) -> X ()
raiseFocusedWindowConditional cond =
  withFocused $ \w -> do
    cond w >>= \case
      False -> return ()
      True -> raiseFocusedWindow
      
raiseFocusedIfFloating :: X ()
raiseFocusedIfFloating = raiseFocusedWindowConditional (runQuery isFloating)

withQuery :: XM.Query a -> (a -> X ()) -> X ()
withQuery q f = withFocused $ \w -> runQuery q w >>= f

findWindow :: (Window -> X Bool) -> X [Window]
findWindow condition = do
  windows <- gets (W.index . windowset)  -- MonadState XState X
  filterM condition windows


------------------------------------------------------------------------------
-- | server send command
sendCommand :: String -> IO ()
sendCommand = sendCommand' "XMONAD_COMMAND"

sendCommand' :: String -> String -> IO ()
sendCommand' addr s = do
  d   <- openDisplay ""
  rw  <- rootWindow d $ defaultScreen d
  a <- internAtom d addr False
  m <- internAtom d s False
  allocaXEvent $ \e -> do
    setEventType e clientMessage
    setClientMessageEvent e rw a 32 m currentTime
    sendEvent d rw False structureNotifyMask e
    sync d False


------------------------------------------------------------------------------
-- | unused currently

-- unused because xautolock wants lock app to not fork
subIndex :: Eq a => [a] -> [a] -> Maybe Int
subIndex substr str = L.findIndex (isPrefixOf substr) (L.tails str)

quasarLock :: X ()
quasarLock = withFocused $ \w -> do
  windowTitle <- runQuery title w  -- title :: Query String
  let yt = subIndex " - YouTube - " windowTitle
  let vlc = subIndex " - VLC media player" windowTitle
  if yt == Nothing && vlc == Nothing
    then spawn "xautolock -locknow"
    else spawn "(pacmd list-sink-inputs | grep 'state: RUNNING') || xautolock -locknow"

quasarSuspend :: X ()
quasarSuspend =
  spawn "(pacmd list-sink-inputs | grep 'state: RUNNING') || systemctl suspend"


------------------------------------------------------------------------------
-- | Customize the way 'XMonad.Prompt' looks and behaves
-- https://braincrater.wordpress.com/2008/11/29/pimp-your-xmonad-3-prompt/
promptConfig = def
  { position          = Top
  , alwaysHighlight   = True
  , promptBorderWidth = 0
  , font              = "xft:bitstream vera sans mono:bold:size=9:antialias=true"
  , bgColor           = "black"
  , fgColor           = "white"
  , height            = 27
  }

