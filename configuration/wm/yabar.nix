
# yabar config

{ pkgs, ... }:

{
  programs.yabar = {
    enable = false;
    package = pkgs.yabar-unstable;
    
    bars."bar" = {
      position = "top";
      font = "Droid Sans, FontAwesome Bold 9";
      extra = {
        background-color-argb = "0xaa226666";
        underline-size = "2";
        overline-size = "2";
      };
      indicators = {
        # various examples for internal blocks:
        ya_ws = {
          exec = "YABAR_WORKSPACE";
          align = "left";
          extra = {
            fixed-size = 40;
            internal-option1 = "        ";
          };
        };
        ya_title = {
          exec = "YABAR_TITLE";
          align = "left";
          extra = {
            justify = "left";
            fixed-size = 300;
          };
        };
        ya_date = {
          exec = "YABAR_DATE";
          align = "center";
          extra = {
            fixed-size = 150;
            interval = 1;
            background-color-rgb = "0x279DBD";
            underline-color-rgb = "0xC02942";
            internal-prefix = " ";
            internal-option1 = "%a %d %b, %I:%M:%S";
          };
        };
        ya_volume = {
          exec = "YABAR_VOLUME";
          align = "right";
          extra = {
            interval = 1;
            internal-option1  = "default Master 0"; # device, mixer, index (separated by a space)
            internal-option2  = "mapped"; # if set to 'mapped', use logarithmic scale (like `amixer -M` and `alsamixer`)
            internal-option3  = " "; # characters to display when sound is on or off (separated by a space)
            internal-suffix = "%";
            background-color-rgb = "0x529e67";
            underline-color-rgb = "0x91313b";
          };
        };
        ya_uptime = {
          exec = "YABAR_UPTIME";
          align = "right";
          extra = {
            fixed-size = 70;
            interval = 1;
            background-color-rgb = "0x96B49C";
            underline-color-rgb = "0xF8CA00";
            internal-prefix = " ";
            #internal-spacing = true;
          };
        };
        ya_mem = {
          exec = "YABAR_MEMORY";
          align = "right";
          extra = {
            fixed-size = 70;
            interval = 1;
            background-color-rgb = "0x45ADA8";
            underline-color-rgb = "0xFA6900";
            internal-prefix = " ";
            #internal-spacing = true;
          };
        };
        ya_thermal = {
          exec = "YABAR_THERMAL";
          align = "right";
          extra = {
            fixed-size = 40;
            interval = 1;
            background-color-rgb = "0x309292";
            underline-color-rgb = "0xE08E79";
            internal-option1 = "thermal_zone0"; # one of /sys/class/thermal/NAME/temp
            internal-option2 = "70; 0xFFFFFFFF; 0xFFED303C"; #Critical Temperature, fg, bg
            internal-option3 = "58; 0xFFFFFFFF; 0xFFF4A345"; #Warning Temperature, fg, bg
            internal-prefix = " ";
            #internal-spacing = true;
          };
        };
        ya_brightness = {
          exec = "YABAR_BRIGHTNESS";
          align = "right";
          extra = {
            fixed-size = 40;
            interval = 1;
            background-color-rgb = "0x81A8B8";
            underline-color-rgb = "0xBD1550";
            internal-prefix = " ";
            internal-option1 = "intel_backlight"; # one of /sys/class/backlight/intel_backlight/brightness
            #internal-spacing = true;
          };
        };
        ya_cpu = {
          exec = "YABAR_CPU";
          align = "right";
          extra = {
            fixed-size = 60;
            interval = 1;
            internal-prefix = " ";
            internal-suffix = "%";
            background-color-rgb = "0x98D9B6";
            underline-color-rgb = "0xE97F02";
            #internal-spacing = true;
          };
        };
        ya_bat = {
          exec = "YABAR_BATTERY";
          align = "right";
          extra = {
            fixed-size = 70;
            interval = 1;
            internal-suffix = "%";
            internal-option1 = "BAT0";
            internal-option2 = "    ";
            #internal-spacing = true;
          };
        };
        ya_disk = {
          exec = "YABAR_DISKIO";
          align = "right";
          extra = {
            fixed-size = 110;
            interval = 1;
            internal-prefix = " ";
            internal-option1 = "sda"; # name from `lsblk` or `ls /sys/class/block/`
            internal-option2 = " "; # characters to be placed before in/out data
            background-color-rgb = "0x49708A";
            underline-color-rgb = "0xECD078";
            #internal-spacing = true;
          };
        };
        ya_wifi = {
          exec = "YABAR_WIFI";
          extra = {
            internal-prefix = "  ";
            internal-suffix = " ";
            internal-option1 = "wlp3s0";
            variable-size = "true";
            background-color-rgb = "0x444444";
          };
        };
      };
    };
  };
}
