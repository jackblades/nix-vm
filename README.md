
# TODO
- autolocking
    - only 'physlock -l' remaining

- constants (username, hostname, etc)
- xmonad
- post-install script (for things like vscode extensions etc)

# home-manager
- is *ON* [ quasar/home/manager.nix ]

# notifications
- using dunst
- thankfully works with udiskie automount

# contained environments with 'nix-shell -i'

# power / lock
- xmonad start out locked
    - login required to use (display-manager auto login enabled)
- xautolock handles lock on inactivity
- xss-lock handles lock on sleep (via xautolock)
- ideally if xautolock also ran `physlock -l` we would have complete security
    - most linuxes don't even go this far

- or light-locker / light-locker-command with lightdm

# wifi
- 
- connect to network
    $ connmanctl
    [connmanctl] enable wifi
    [connmanctl] agent on
    [connmanctl] scan wifi
    [connmanctl] services
    -- wait for network name and [long-identifier]
    [connmanctl] services [long-identifier] 
    [connmanctl] connect [long-identifier]

# bluetooth
- see https://nixos.wiki/wiki/Bluetooth
- pairing and connecting to device
    $ bluetoothctl
    [bluetooth] # power on
    [bluetooth] # agent on
    [bluetooth] # default-agent
    [bluetooth] # scan on
    --- put device on pairing mode and wait for hex-address ---
    [bluetooth] # pair [hex-address]
    [bluetooth] # connect [hex-address]
- also see `bluetooth-player`

# XMonad conf
- main key changed to "windows key" from "alt"
- https://linuxaria.com/pills/how-to-have-a-transparent-terminal-as-wallpaper-that-displays-information
    - xrootconsole can be used to tails a file in a window on your X11 root window
    - eterm

# Flatpak conf
- post-activation
    - flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    - flatpak update
    - flatpak search bustle
    - flatpak install flathub org.freedesktop.Bustle
    - flatpak run org.freedesktop.Bustle
    - flatpak run --filesystem=/tmp/mounts/office org.phoenicis.playonlinux
    - flatpak uninstall org.phoenicis.playonlinux
    - flatpak uninstall --unused


# candidates
  - services.ihaskell.enable = true;
  - services.jupyter.enable = true;
  - services.jupyter.password = "123ajit123";

  - services.elasticsearch.enable = false;
  - services.emby.enable = false;
  - services.flexget.enable = false;
  - services.grafana.enable = false;
  - services.graphite.enable = false;
  - services.hoogle.enable = false;
  - services.hound.enable = false;
  - services.hydra.enable = false;
  - services.infinoted.enable = false;
  - services.jira.enable = false;













