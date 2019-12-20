{ lib, pkgs, config, ... }:
with lib;
{
  shellAliases = {
    fish-theme = "set -U | grep fish_color_";

    # -- with fish functions: path-select, fzlocate and rcd 
    ed = "env TERM=xterm-256color micro";
    ff = "ranger";
    ll = "grc --colour=on ls -alFh --group-directories-first";
    lst = "grc --colour=on ls -lFhtr --group-directories-first";
    lsta = "grc --colour=on ls -AlFhtr --group-directories-first";

    cp = "rsync -avP";
    cpr = "rsync -avrP";

    rmr = "rm -r";
    rmrf = "rm -rf";

    wcl = "wc -l";

    jess = "python -m json.tool | pygmentize -l json | less";
    less = "less -R";

    fzfr = "fzf --ansi --reverse";
    fzfm = "fzf --ansi --reverse --multi";

    # url processing
    urldecode = "python -c \"import sys, urllib as ul, urlparse as up, json; print ul.unquote(sys.stdin.read());\"";
    urldecode-queryjson = "python -c \"import sys, urllib as ul, urlparse as up, json; print json.dumps(up.parse_qs(ul.unquote(sys.stdin.read())));\"";

    # applications
    aria2t = "aria2c -x16 --file-allocation=none --seed-time=0";
    aria2f = "aria2c  --max-concurrent-downloads=1 --connect-timeout=60 --max-connection-per-server=16 --split=16 --min-split-size=1M --human-readable=true --download-result=full --seed-time=none --dir=./ --input-file";

    # process management
    psf = "grc --colour=on ps auxx | fzf --ansi --reverse";
    psfm = "grc --colour=on ps auxx | fzf --ansi --reverse --multi";

    # job management
    job-select = "jobs | fzf-tmux --ansi --reverse";
    job-kill = "kill (jobs | fzf-tmux --ansi --reverse | awk '{print $2}')";
    job-kill9 = "kill -9 (jobs | fzf-tmux --ansi --reverse | awk '{print $2}')";

  };
  shellInit =
    ''
      echo \n\n\t\t\t USE \'nn\' FOR DAILY TODO. READ FREQUENTLY \n\n 

      set -x EDITOR env TERM=xterm-256color micro

      ######################### less configuration
      set -x LESS_TERMCAP_mb (tput bold; tput setaf 2) # green
      set -x LESS_TERMCAP_md (tput bold; tput setaf 6) # cyan
      set -x LESS_TERMCAP_me (tput sgr0)
      set -x LESS_TERMCAP_so (tput bold; tput setaf 3; tput setab 4) # yellow on blue
      set -x LESS_TERMCAP_se (tput rmso; tput sgr0)
      set -x LESS_TERMCAP_us (tput smul; tput bold; tput setaf 7) # white
      set -x LESS_TERMCAP_ue (tput rmul; tput sgr0)
      set -x LESS_TERMCAP_mr (tput rev)
      set -x LESS_TERMCAP_mh (tput dim)
      set -x LESS_TERMCAP_ZN (tput ssubm)
      set -x LESS_TERMCAP_ZV (tput rsubm)
      set -x LESS_TERMCAP_ZO (tput ssupm)
      set -x LESS_TERMCAP_ZW (tput rsupm)
      set -x GROFF_NO_SGR 1         # For Konsole and Gnome-terminal

      set -x LESS "--RAW-CONTROL-CHARS"
      #########################

      function mkcd
        test -d $argv[1]
        or begin
          mkdir -p $argv[1]
          cd $argv[1]
        end
      end

      # generate the nixpkgs (maybe lock this file afterwards)
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

      # TODO interactive select
      # get it from https://github.com/junegunn/fzf/blob/master/shell/key-bindings.fish
      # \ct, \cr and particularly \ec
        
      function path-select
        count $argv > /dev/null
        or set -l argv .

        set cmdline (string trim (commandline))
        ${pkgs.bfs}/bin/bfs $argv | fzfm --height 50% | while read -l line
          set sels $sels \"(string trim $line)\"
        end
        commandline -r "$cmdline $sels"
        # commandline -f repaint
      end
      bind \ck path-select

      function fzlocate
        count $argv > /dev/null
        or read -P "Search term: " -l argv
        
        set cmdline (string trim (commandline))
        ${pkgs.mlocate}/bin/locate -i $argv | fzfm --height 50% | while read -l line
          set sels $sels \"(string trim $line)\"
        end
        commandline -r "$cmdline $sels"
        # commandline -f repaint
      end
      bind \cj fzlocate

      function rcd
        set tmpfile (${pkgs.coreutils}/bin/mktemp /tmp/rcd.XXXXXX)
        # TODO ${pkgs.tmux}/bin/tmux split-window -p 30 ranger --choosedir $tmpfile
        ${pkgs.ranger}/bin/ranger --choosedir=$tmpfile
        cd (cat $tmpfile)
        ${pkgs.coreutils}/bin/rm $tmpfile
      end

      # service queues
      function queue-youtube
        ${pkgs.coreutils}/bin/echo "$argv" >> /tmp/youtube-queue
      end
      function queue-torrent
        ${pkgs.coreutils}/bin/echo "$argv" >> /tmp/torrent-queue
      end


      # web search from cli
      function stpb
        ${pkgs.firefox}/bin/firefox --private-window "https://thepiratebay.org/search/$argv/0/99/0"
      end
      function sggl
        ${pkgs.firefox}/bin/firefox "https://www.google.com/search?q=$argv"
      end
      function shkg
        set argv (echo $argv | string replace -a " " "+")
        ${pkgs.firefox}/bin/firefox "http://hackage.haskell.org/packages/search?terms=$argv"
      end
      function shgl
        set argv (echo $argv | string replace -a " " "+")
        ${pkgs.firefox}/bin/firefox "https://hoogle.haskell.org/?hoogle=$argv&scope=set%3Astackage"
      end
    '';
}