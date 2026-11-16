{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;

    settings = {
      backdrop = {
        blur_intensity = 0.3;
        enabled = true;
        tint_intensity = 0.5;
      };
      bar = {
        default = {
          background_opacity = 0;
          capsule = true;
          center = [ "workspaces" ];
          compositor_blur = false;
          dead_zone = {
            click_through = true;
          };
          end = [
            "tray"
            "notifications"
            "bluetooth"
            "network"
            "battery"
          ];
          margin_edge = 4;
          margin_ends = 0;
          padding = 16;
          position = "left";
          reserve_space = false;
          start = [ "clock" ];
        };
      };
      battery = {
        warning_threshold = 20;
      };
      control_center = {
        shortcuts = [
          { type = "wifi"; }
          { type = "bluetooth"; }
          { type = "caffeine"; }
          { type = "notification"; }
          { type = "power_profile"; }
          { type = "clipboard"; }
        ];
        sidebar = "full";
        sidebar_section = "full";
        width = 800;
      };
      desktop_widgets = {
        enabled = false;
      };
      idle = {
        behavior = {
          lock-and-suspend = {
            action = "lock_and_suspend";
            enabled = true;
            timeout = 1800;
          };
          screen-off = {
            action = "screen_off";
            enabled = true;
            locked_timeout = 60;
            timeout = 300;
          };
        };
        behavior_order = [
          "screen-off"
          "lock-and-suspend"
        ];
        pre_action_fade_seconds = 1;
      };
      location = {
        auto_locate = true;
      };
      lockscreen = {
        blur_intensity = 0.2;
        tint_intensity = 0;
        transition = [ "disc" ];
        transition_duration = 700;
      };
      nightlight = {
        enabled = true;
      };
      shell = {
        button_borders = false;
        card_borders = false;
        input_borders = false;
        panel = {
          control_center_placement = "floating";
          control_center_position = "center";
          session_placement = "floating";
          session_position = "center";
        };
        popup_borders = false;
        screenshot = {
          append_mode_suffix = false;
          confirm_region = true;
          directory = "/home/jason/Pictures/Screenshots";
        };
        session = {
          actions = [
            {
              action = "lock_and_suspend";
              countdown_seconds = 0;
              enabled = true;
              glyph = "moon";
              label = "Sleep";
              shortcut = "s";
              variant = "default";
            }
            {
              action = "reboot";
              countdown_seconds = 0;
              enabled = true;
              label = "Restart";
              shortcut = "r";
              variant = "default";
            }
            {
              action = "shutdown";
              countdown_seconds = 0;
              enabled = true;
              shortcut = "p";
              variant = "default";
            }
          ];
          grid_columns = 5;
        };
      };
      theme = {
        builtin = "Rosé Pine";
      };
      wallpaper = {
        default = {
          path = "${../wallpapers/evening-sky.png}";
        };
        directory = "${../wallpapers}";
        transition = [ "disc" ];
      };
      weather = {
        unit = "imperial";
      };
      widget = {
        clock = {
          vertical_format = "%b%n%d%n—%n%I%n%M%n%p";
        };
        network = {
          show_label = false;
        };
        workspaces = {
          empty_color = "tertiary";
          show_labels = false;
        };
      };
    };
  };
}
