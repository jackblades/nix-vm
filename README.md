
# TODO
- constants (username, hostname, etc)
- post-install script (for things like vscode extensions etc)

# java spplications
- set -x _JAVA_AWT_WM_NONREPARENTING 1

# firefox
- if it doesn't connect to internet after suspend
  - change network settings to 'no proxy'
- primevideo (DRM stuff)
  - about:preferences > search DRM > enable

# notifications
- using dunst
- thankfully works with udiskie automount

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













