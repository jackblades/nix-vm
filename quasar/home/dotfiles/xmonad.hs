{-# LANGUAGE LambdaCase #-}

module Main (main) where

--------------------------------------------------------------------------------
-- XMonad.Actions.FloatSnap
import qualified Data.Tree as Tree 
import qualified Data.List as L (find, findIndex)
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
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ServerMode
import XMonad.Layout.BinarySpacePartition (emptyBSP)
import XMonad.Layout.Grid
import qualified XMonad.Layout.Magnifier as Magnifier
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
import XMonad.Util.SpawnOnce

import qualified XMonad.StackSet as W
--------------------------------------------------------------------------------
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
  
cmds :: [(String, X ())]
cmds = 
  [ ("calendar", spawn "/etc/settings-calendar")
  , ("network", spawn "/etc/settings-network")
  , ("power", spawn "/etc/settings-power")
  , ("sound", spawn "/etc/settings-sound")
  , ("colorinvert", spawn "xcalib -i -a")
  , ("layout", sendMessage NextLayout)
  ]

-- xmonad server
rootConfig = desktopConfig
    { modMask    = mod4Mask -- Use the "Win" key for the mod key
    , focusedBorderColor = "#7FFFD4"
    -- , startupHook = startupHook desktopConfig
    , manageHook = myManageHook 
                <+> manageHook desktopConfig
    , layoutHook = desktopLayoutModifiers $ myLayouts
    , logHook    = dynamicLogString def >>= xmonadPropLog
    , handleEventHook = docksEventHook 
                      <+> fullscreenEventHook 
                      <+> serverModeEventHookCmd' (return cmds) 
                      <+> handleEventHook def
    , borderWidth = 0
    }
      
keyConfig = 
      [ ("M-S-q",   shellPrompt promptConfig)
      , ("M-w",   kill)
      -- , ("M-S-q",   confirmPrompt promptConfig "exit" (io exitSuccess))
      
      , ("M-m", banish UpperLeft)
      , ("M-z", sendMessage NextLayout)
      , ("M-f", sendMessage (MT.Toggle FULL))
      , ("M-x", sendMessage (MT.Toggle MIRROR))
      , ("M-a", sendMessage Magnifier.Toggle)
      
      , ("M-<Tab>", rotAllUp)
      , ("M-S-<Tab>", rotAllDown)
      , ("M-S-`", windows W.focusUp)
      , ("M-`", windows W.focusDown)

      -- apps
      , ("M-e", spawn "thunar ~")
      , ("M-S-e", spawn "thunar /run/media/common")
      
      -- system commands
      , ("M-l", spawn "xautolock -locknow")
      -- use theme 'Paper by qball'
      , ("M-<Space>", spawn "rofi -show drun -modi drun,window,ssh -show-icons -sidebar-mode # -lines 26 -theme-str '#window { height: 768; }' -location 1 ")
      -- , ("M-<Space>", shellPrompt promptConfig)
      , ("M-<Right>", moveTo Next NonEmptyWS)
      , ("M-<Left>", moveTo Prev NonEmptyWS)
      , ("M-S-<Space>", spawn "rofi-theme-selector")
      , ("M-S-<Return>", spawn "pgrep terminator || terminator")
      
      -- display
      , ("M-i", spawn "xcalib -i -a")
      , ("<XF86MonBrightnessUp>", spawn "brightnessctl s +7%")
      , ("<XF86MonBrightnessDown>", spawn "brightnessctl s -7%")    
      
      -- audio
      , ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +1.5%")
      , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@  -1.5%")
      , ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle") 
      , ("<XF86AudioPlay>", spawn "deadbeef --play-pause")    
      , ("<XF86AudioPrev>", spawn "deadbeef --prev")    
      , ("<XF86AudioNext>", spawn "deadbeef --next")    
      ]

--------------------------------------------------------------------------------
-- | Customize layouts.
myLayouts = mkToggle (FULL ?? EOT)
          $ mkToggle (single MIRROR)
          $ spaced . magnified
          $ mouseResizable ||| threeColumns ||| Grid
  where
    spaced = spacingRaw True (Border d d d d) True (Border d d d d) True where d = 3
    magnified = Magnifier.magnifierOff  -- Magnifier.magnifiercz' 1.5  -- magnify the focused widow
    mouseResizable = mouseResizableTile { masterFrac = 0.6 }
    threeColumns = ThreeColMid 1 (3/100) (1/2)

--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- | Manipulate windows as they are created.
-- @composeOne@ processes first-match from top to bottom
-- Use the `xprop' tool to get the info you need for these matches.
myManageHook = composeOne
  [ className =? "Tilda" -?> doFloat
  , appName =? "Terminator Preferences" -?> doFloat
  , className =? ".terminator-wrapped" -?> doRectFloat (W.RationalRect 0 0 1 1)
  -- control applications
  , className =? "Pavucontrol" -?> doRectFloat (W.RationalRect 0.44 0.04 0.55 0.5)
  , className =? ".blueman-manager-wrapped" -?> doRectFloat (W.RationalRect 0.23 0.04 0.20 0.5)
  , className =? "Lxappearance" 
      -?> doRectFloat (W.RationalRect 0.01 0.2 0.4 0.6)
  , className =? "Wicd-client.py" 
      -?> doRectFloat (W.RationalRect 0.59 0.2 0.4 0.6)
  -- generic actions 
  , isFullscreen         -?> doFullFloat
  , isDialog             -?> doCenterFloat
  -- Move transient windows to their parent:
  , transience
  ]

-- util functions

findWindow :: (Window -> X Bool) -> X [Window]
findWindow condition = do
  windows <- gets (W.index . windowset)  -- MonadState XState X
  filterM condition windows

  
-- className = ask >>= (\w -> liftX $ withDisplay $ \d -> fmap resClass $ io $ getClassHint d w)
-- this is a condition that can get className
  -- d <- fmap display ask  -- MonadReader XConf X
  -- getClassHint d w


-- server send command
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

