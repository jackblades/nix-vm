--------------------------------------------------------------------------------
-- | Example.hs
--
-- Example configuration file for xmonad using the latest recommended
-- features (e.g., 'desktopConfig').
module Main (main) where

--------------------------------------------------------------------------------
-- import XMonad.Actions.TreeSelect
-- import XMonad.Actions.WindowNavigation
-- import XMonad.Layout.MultiToggle
-- XMonad.Actions.FloatSnap

import System.Exit
import Control.Monad (replicateM_)

import XMonad
import XMonad.Actions.RotSlaves
import XMonad.Actions.Search
import XMonad.Actions.Warp (banish, Corner(UpperLeft))
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.Place
import XMonad.Layout.AutoMaster
import XMonad.Layout.BinarySpacePartition (emptyBSP)
import XMonad.Layout.Grid
import XMonad.Layout.Magnifier (magnifiercz)
import XMonad.Layout.MouseResizableTile
import XMonad.Layout.MultiToggle as MT
import XMonad.Layout.MultiToggle.Instances as MTI
-- import XMonad.Layout.ToggleLayouts as T (ToggleLayout(..), toggleLayouts)
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
main = do
  -- only spawn one instance [uses /bin/sh]
  spawn "pgrep yabar || (while true; do yabar -c /home/ajit/.xmonad/yabar.config; done)"

  spawn "pgrep terminator || terminator"
  
  -- spawn "pgrep firefox || firefox"
  -- spawn "pgrep code || code"
  -- spawn "pgrep tilda || tilda --hidden"

  let config = rootConfig `additionalKeysP` keyConfig
  -- ewmh is needed to get window info in bar
  xmonad $ ewmh config
  
rootConfig = desktopConfig
    { modMask    = mod4Mask -- Use the "Win" key for the mod key
    , focusedBorderColor = "#7FFFD4"
    , startupHook = do
        -- require login the _first_ time
        -- spawnOnce "xautolock -locknow"
        startupHook desktopConfig
                -- placeHook (withGaps (25,0,25,0) (smart (0.2,0.2))) 
                --    -- place floating windows
                -- <+> 
    , manageHook = myManageHook 
                <+> manageHook desktopConfig
    , layoutHook = desktopLayoutModifiers $ myLayouts
    , logHook    = dynamicLogString def >>= xmonadPropLog
    , handleEventHook = handleEventHook def <+> docksEventHook <+> fullscreenEventHook
    }
      
keyConfig = 
      [ ("M-S-q",   shellPrompt myXPConfig)
      , ("M-w",   kill)
      -- , ("M-S-q",   confirmPrompt myXPConfig "exit" (io exitSuccess))
      
      , ("M-l", spawn "xautolock -locknow")
      , ("M-m", banish UpperLeft)
      , ("M-z", sendMessage NextLayout)
      -- , ("M-f", sendMessage (T.Toggle "Full"))
      , ("M-f", sendMessage (MT.Toggle FULL))
      , ("M-x", sendMessage (MT.Toggle MIRROR))
      
      , ("M-<Tab>", rotAllUp)
      , ("M-S-<Tab>", rotAllDown)
      , ("M-S-`", windows W.focusUp)
      , ("M-`", windows W.focusDown)
      , ("M-S-<Return>", spawn "pgrep terminator || terminator")

      , ("M-<Space>", shellPrompt myXPConfig)
      , ("M-i", spawn "xcalib -i -a")

      -- TODO XMonad.Actions.WindowNavigation workspaces
      -- TODO XMonad.Actions.TreeSelect workspaces
      -- https://hackage.haskell.org/package/xmonad-contrib-0.15/docs/XMonad-Actions-TreeSelect.html

      , ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +1.5%")
      , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@  -1.5%")
      , ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")    
      , ("<XF86AudioPlay>", spawn "playerctl play-pause")    
      , ("<XF86AudioPrev>", spawn "playerctl previous")    
      , ("<XF86AudioNext>", spawn "playerctl next")    
      , ("<XF86MonBrightnessUp>", spawn "brightnessctl s +7%")
      , ("<XF86MonBrightnessDown>", spawn "brightnessctl s -7%")    
      ]

--------------------------------------------------------------------------------
-- | Customize layouts.
--
-- This layout configuration uses two primary layouts, 'ResizableTall'
-- and 'BinarySpacePartition'.  You can also use the 'M-<Esc>' key
-- binding defined above to toggle between the current layout and a
-- full screen layout.
myLayouts = id
          -- remove borders from floating windows
          $ lessBorders OnlyScreenFloat
          -- http://hackage.haskell.org/package/xmonad-contrib-0.15/docs/XMonad-Layout-MultiToggle.html
          $ mkToggle (NOBORDERS ?? FULL ?? EOT)
          $ mkToggle (single MIRROR)
          $ spaced threeColumns ||| spaced mouseResizable ||| magnified
  where
    spaced = spacingRaw True (Border 2 2 2 2) True (Border 2 2 2 2) True
           -- $ mouseResizable
    magnified = magnifiercz 1.5 mouseResizable  -- magnify the focused widow
    mouseResizable = mouseResizableTile { masterFrac = 0.6 }
    threeColumns = ThreeColMid 1 (3/100) (1/2)
    -- others = ResizableTall 1 (1.5/100) (3/5) [] ||| emptyBSP

--------------------------------------------------------------------------------
-- | Customize the way 'XMonad.Prompt' looks and behaves.  It's a
-- great replacement for dzen.
myXPConfig = def
  { position          = Top
  , alwaysHighlight   = True
  , promptBorderWidth = 0
  , font              = "xft:bitstream vera sans mono:bold:size=9:antialias=true"
  , bgColor           = "black"
  , fgColor           = "white"
  , height            = 27
  }

--------------------------------------------------------------------------------
-- | Manipulate windows as they are created.  The list given to
-- @composeOne@ is processed from top to bottom.  The first matching
-- rule wins.
--
-- Use the `xprop' tool to get the info you need for these matches.
-- For className, use the second value that xprop gives you.
myManageHook = composeOne
  [ className =? "Tilda" -?> doFloat
  , className =? ".terminator-wrapped"   -?> doRectFloat (W.RationalRect 0 0 1 1)
  
  , className =? "vlc"   -?> doFloat
  
  , className =? "Lxappearance" -?> doRectFloat (W.RationalRect 0.01 0.2 0.4 0.6)
  , className =? "Wicd-client.py" -?> doRectFloat (W.RationalRect 0.59 0.2 0.4 0.6)
  
    -- generic actions 
  , isFullscreen         -?> doFullFloat
  , isDialog             -?> doCenterFloat
    -- Move transient windows to their parent:
  , transience
  ]

--
-- myManageHook = composeAll. concat $
--     [ [ className =? c --> doFullFloat | c <- floats]
--     , [ resource =? r --> doIgnore | r <- ignore]
--     , [ isFullscreen --> doFullFloat]
--     , [ isDialog --> doCenterFloat]
--     -- probably shifts the window to a desktop
--     -- , [ resource =? "gecko" --> doF (W.shift "net") ]
--     ]
--   where 
--     ignore = []
--     floats = ["Tilda"]
--     -- floats = ["sdlpal", "MPlayer", "Gimp", "qemu-system-x86_64", "Gnome-typing-monitor", "Vlc", "Dia", "DDMS", "Audacious", "Wine"]


--     -- Move transient windows to their parent:
--   -- , transience
--   -- ]
