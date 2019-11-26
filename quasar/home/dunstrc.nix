{
  global = {
    font = "lemon 8";
    allow_markup = "yes";
    format = "%s\n%b";
    sort = "yes";
    indicate_hidden = "yes";
    alignment  = "left";
    bounce_freq = 0;
    show_age_threshold = 60;
    word_wrap = "yes";
    ignore_newline  = "no";
    geometry = "300x10-10+48";
    ##transparency = 25;
    transparency = 0;
    idle_threshold = 120;
    monitor = 0;
    follow = "mouse";
    sticky_history = "yes";
    line_height = 5;
    separator_height = 0;
    padding = 10;
    horizontal_padding = 10;
    separator_color = "#bfbfbf";
    startup_notification = false;
    show_indicators  = "no";
    dmenu = "/usr/bin/dmenu -p dunst";
    browser = "/usr/bin/google-chrome-beta -new-tab";
    icon_position  = "left";
    icon_folders = "/usr/share/icons/Notifications";
  };

  frame = {
    color = "#ffffff";
    width = 0;
  };

  shortcuts = {
    close = "ctrl+space";
    close_all = "ctrl+shift+space";
    context = "ctrl+shift+period";
    history = "ctrl+shift ";
  };

  urgency_low = {
    background = "#ffffff";
    foreground = "#595959";
    timeout = 5;
  };

  urgency_normal = {
    background = "#ffffff";
    foreground = "#595959";
    timeout = 5;
  };

  urgency_critical = {
    background = "#ffffff";
    foreground = "#595959";
    timeout = 5;
  };

  Discord = {
    appname = "Discord Canary";
    format = "<b>%s</b>\n%b";
    new_icon = "Discord";
  };

  WMail = {
    appname = "Electron";
    format = "<b>%s</b>\n%b";
    new_icon = "WMail";
    timeout = 2000;
  };

  NCMPCPP = {
    appname = "mpc";
    format = "<b>Now Playing:</b>\n%s\n%b";
    #format = "<b>%s</b>\n%b";
    new_icon = "NCMPCPP";
    timeout = 10;
  };

  Spotify = {
    appname = "Spotify";
    format = "<b>Now Playing:</b>\n%s\n%b";
    new_icon = "Spotify";
    timeout = 10;
  };

  Transmission = {
    appname = "Transmission";
    format = "<b>%s</b>\n%b";
    new_icon = "Transmission";
    timeout = 2000;
  };
}