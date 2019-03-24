
{ lib, pkgs, config, ... }:
with lib;
let cfg = config.quasar.fish;
    masenkoPrompt = import ./masenko-prompt.nix { pkgs = pkgs; };
in {
  imports = [
    ./fish-nix-shell.nix
  ];

  options.quasar.fish = {
    enable = mkEnableOption "quasar fish configuration";
  };

  config = lib.mkIf cfg.enable {
    quasar.fish-nix-shell.enable = true;

    environment.systemPackages = with pkgs; [
      grc
      python36Packages.pygments

      ag
      aria2
      dtrx
      icdiff  # see csdiff in fish-config/bin, and diff-so-fancy in the gitAndTools package
      most
      moreutils
      multitail
      ncdu
      parallel
      rclone
      tree

      fzf
      neovim
      ranger
      tmux
      terminator  

      #
      # masenkoPrompt
    ];

    programs.fish = {
      enable = true;
      promptInit = "for f in ${masenkoPrompt}/*; source $f; end";
      shellAliases = {
        fish-theme = "set -U | grep fish_color_";

        # shell stuff
        ll = "grc --colour=on ls -alFh --group-directories-first";
        lst = "grc --colour=on ls -AlFhtr --group-directories-first";

        cp = "rsync -avP";
        cpr = "rsync -avrP";

        rmr = "rm -r";
        rmrf = "rm -rf";

        wcl = "wc -l";

        jess = "python -m json.tool | pygmentize -l json | less";
        less = "less -R";

        fzfr = "fzf --ansi --reverse";
        fzfm = "fzf --ansi --reverse --multi";

        # process management
        psf = "grc --colour=on ps auxx | fzf --ansi --reverse";
        psfm = "grc --colour=on ps auxx | fzf --ansi --reverse --multi";

        # job management
        job-select = "jobs | fzf-tmux --ansi --reverse";
        job-kill = "kill (jobs | fzf-tmux --ansi --reverse | awk \\'{print $2}\\')";
        job-kill9 = "kill -9 (jobs | fzf-tmux --ansi --reverse | awk \\'{print $2}\\')";
        
        # list fonts
        fonts-list = "fc-list";

        # settings
        settings-net = "wicd-gtk";
        settings-bt = "bluetoothctl connect FC:58:FA:D4:FC:68";
        settings-wall = "feh --bg-scale /home/ajit/Downloads/(ls /home/ajit/Downloads | fzf --reverse --prompt \"wallpaper > \")";

          # boat stone bt config
          bt-stone-connect = "echo connect FC:58:FA:D4:FC:68 | bluetoothctl";
          bt-stone-disconnect = "echo disconnect | bluetoothctl";
          bt-stone-reconnect = "bt-stone-disconnect; and sleep 5; and bt-stone-connect";

          # mount disks
          mount-list = "ls /tmp/mounts";

        # nix stuff
        nix-pkgs = "test -f /tmp/packages.nix; or nix-env -qaP \\'*\\' > /tmp/packages.nix; most /tmp/packages.nix";
        nix-home-conf = "man home-configuration.nix | grep -v \\'^        \\' | grep -v \\'^[ \\r\\n\\t]*$\\' | most";
        
        nix-install = "nix-env -i";
        nix-uninstall = "nix-env -e";
        nix-list-installed = "nix-env -q";

        nix-list-generations = "nix-env --list-generations";
        nix-gc = "nix-collect-garbage --delete-older-than 3d";
        nix-gc1 = "nix-collect-garbage --delete-older-than 1d";
        nix-gcd = "nix-collect-garbage --delete-older-than";
        nix-gc-force = "nix-collect-garbage -d";
        nix-optimize-store = "nix-store --optimise -v";
        nix-rebuild-os = "sudo cp -r ~/nixos /etc; and sudo nixos-rebuild switch";
        nix-rollback-os = "sudo nixos-rebuild switch --rollback";

        # qvm
        # qvm-start = "nohup VBoxHeadless --startvm nix > /tmp/quasar-vm &";
      };
      shellInit = ''
        # set env
        set -x EDITOR nvim
        set -x GIT_EDITOR nvim
        set -x VISUAL code

        function mkcd
          test -d $argv[1]
          or begin
            mkdir -p $argv[1]
            cd $argv[1]
          end
        end

        # generate the nixpkgs (maybe lock this file afterwards)
        test -f /tmp/packages.nix; 
          or nix-env -qaP '*' > /tmp/packages.nix &

        # modifiers for interactive use
        function igrun
          nohup $argv > /dev/null &
        end

        function ign
          eval $argv > /dev/null
        end

        # view colorized source
        function sless
          pygmentize $argv[1] | less -R
        end

        # mount devices [ uses /tmp/mounts ] see bashmount
        function mount-new
          set mfs (fdisk -l | grep /dev/sd | grep -vP '^Disk' | awk '{print $1}' | fzfr)
          read -P 'mount-name | ' -l mname
          test -d /tmp/mounts/$mname
          and echo ERROR mount point /tmp/mounts/$mname already exists
          or begin
            mkdir /tmp/mounts/$mname
            sudo mount $mfs /tmp/mounts/$mname
          end
        end

        function mount-rm
          sudo umount /tmp/mounts/$argv[1]
          and rm -rf $argv[1]
        end

        function mount-rmf
          set name (ls -1 /tmp/mounts | fzf --reverse)
          mount-rm $name
        end    
      '';      
    };
  };
}