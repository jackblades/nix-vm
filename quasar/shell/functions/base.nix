{ lib, pkgs, config, ... }:
with lib;
{
  shellAliases = {
    fish-theme = "set -U | grep fish_color_";
    # --
    ff = "ranger";
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

    # url processing
    urldecode = "python -c \"import sys, urllib as ul, urlparse as up, json; print ul.unquote(sys.stdin.read());\"";
    urldecode-queryjson = "python -c \"import sys, urllib as ul, urlparse as up, json; print json.dumps(up.parse_qs(ul.unquote(sys.stdin.read())));\"";

    # applications
    aria2t = "aria2c -x16 --file-allocation=none --seed-time=0";

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