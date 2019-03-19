# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, home-manager, ... }:

let lib = import <nixpkgs/lib>;
    shell = import ./shell/fish.nix;
    xmonad = import ./wm/xmonad.nix { pkgs = pkgs; };
    gnome = import ./wm/gnome.nix { pkgs = pkgs; };
    xfce = import ./wm/xfce.nix { pkgs = pkgs; };
    wm = xmonad;
    
    override-packages = import ./override-packages.nix { pkgs = pkgs; };

    home-manager-config = {};
    # home-manager-config = import ./home/manager.nix { pkgs = pkgs; home-manager = home-manager; };

    machine = {
      nixpkgs.config.allowUnfree = true;
      
      # sound support
      sound.enable = true;
      hardware.pulseaudio.enable = true;
      # bluetooth support
      hardware.bluetooth.enable = true;
      hardware.bluetooth.extraConfig = ''
        [General]
        Enable=Source,Sink,Media,Socket
      '';
      hardware.pulseaudio.package = pkgs.pulseaudioFull;
      # hardware.pulseaudio.extraModules = [ pkgs.pulseaudio-modules-bt ];

      # opengl support
      hardware.opengl.enable = true;
      hardware.opengl.driSupport32Bit = true;
      hardware.opengl.extraPackages = with pkgs; [
        override-packages.vaapiIntelHybrid
        vaapiVdpau
        libvdpau-va-gl
        # intel-media-driver # only available starting nixos-19.03 or the current nixos-unstable
      ];
      services.xserver.videoDrivers = [ "intel" "nvidia" ];
      # hardware.bumblebee.enable = true;  # seems ok without it
  
      # locate service
      services.locate = {
        enable = true;
        locate = pkgs.mlocate;
        interval = "hourly";
        # localuser = "ajit";  -- insecure [ uses su ]
      };

      # screen lock
      # physlock handles true terminals [ TODO handle better (no tty switching but no cli password)]
      # xautolock handles inactivity [ xmonad.hs:services.xmonad.xautolock ]
      # xss-lock handles system-wide sleep (suspend/hibernate)
      services.physlock.enable = true;
      services.physlock.lockOn.hibernate = false;
      services.physlock.lockOn.suspend = false;

      programs.xss-lock.enable = true;
      programs.xss-lock.lockerCommand = "xautolock -locknow";

      # better ttys
      services.gpm.enable = false;
      services.kmscon.enable = false;
      services.kmscon.hwRender = false;
      services.kmscon.extraOptions = "--term xterm-256color";

      # enable flatpak
      services.flatpak.enable = true;
      services.flatpak.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
 
      # List packages installed in system profile. 
      environment.systemPackages = with pkgs; [
        ag
        aria2
        binutils
        dtrx
        gitAndTools.gitFull
        gcc
        grc
        htop
        icdiff  # see csdiff in fish-config/bin, and diff-so-fancy in the gitAndTools package
        manpages
        moreutils  # WARN
        most
        multitail
        ncdu
        nix
        pciutils  # WARN
        parallel
        # pmutils  # systemctl suspend/hibernate/whatever
        python2
        python3
        python36Packages.pygments
        rclone
        rsync
        speedtest-cli
        sudo
        tree
        utillinux  # WARN
        which
        wget

        fzf
        neovim
        ranger
        tmux
        terminator
        vlc
        firefox
        vscode
        override-packages.wpsoffice
        
        bashmount  # WARN
        brightnessctl
        override-packages.lxapp
        feh
        gotty  # WARN
        i3lock-fancy
        rofi  # WARN
        xtitle
        xorg.xprop
        yabar-unstable

        arc-theme
        paper-icon-theme
      
        # dev stuff [ also see flathub ]
        # datagrip  
        # gitkraken
        # slade
        # smartsynchronize
	
        # sddm
        qt5.qtgraphicaleffects
      ];
      
      nixpkgs.config.packageOverrides = pkgs : {
        jre = pkgs.oraclejre8;
        jdk = pkgs.oraclejdk8;
      };

      # fonts
      fonts = {
        enableFontDir = true;
        enableGhostscriptFonts = true;
        enableDefaultFonts = true;
        fonts = with pkgs; [
          anonymousPro
          corefonts
          dejavu_fonts
          font-droid
          freefont_ttf
          google-fonts
          inconsolata
          liberation_ttf
          powerline-fonts
          source-code-pro
          terminus_font
          ttf_bitstream_vera
          ubuntu_font_family

          vistafonts
          proggyfonts
          font-awesome-ttf
          source-sans-pro
          source-serif-pro 
        ];

        fontconfig.defaultFonts.monospace = [ "Inconsolata\-dz for Powerline" ];
        # fontconfig.defaultFonts.sansSerif = "";
        # fontconfig.defaultFonts.serif = "";
      };
    };
    
    union = lib.recursiveUpdate;
in union machine (union home-manager-config (union wm shell))
