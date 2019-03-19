
# TODO
- autolocking
    - only 'physlock -l' remaining

- notifications

# home-manager
- is *OFF*
- toggle on if fresh install (in machine.nix)
- TODO probably should move to a dedicated home-manager setup (instead of configuration.nix)
    - configuration.nix could still setup the home-manager and initial switch configuration


# contained environments with 'nix-shell -i'

# power / lock
- xmonad start out locked
    - login required to use (display-manager auto login enabled)
- xautolock handles lock on inactivity
- xss-lock handles lock on sleep (via xautolock)
- ideally if xautolock also ran `physlock -l` we would have complete security
    - most linuxes don't even go this far

- or light-locker / light-locker-command with lightdm

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
















