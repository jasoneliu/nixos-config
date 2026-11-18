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
          thickness = 40;
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
      lockscreen_widgets = {
        enabled = true;
        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };
        schema_version = 2;
        widget = {
          "lockscreen-login-box@eDP-1" = {
            box_height = 196;
            box_width = 810;
            cx = 853.5;
            cy = 883.5;
            output = "eDP-1";
            placement_height = 1067;
            placement_width = 1707;
            rotation = 0;
            settings = {
              background_color = "surface_container";
              background_opacity = 0.88;
              background_radius = 12;
              center_password_text = false;
              input_opacity = 1;
              input_radius = 6;
              layout = "regular";
              show_caps_lock = false;
              show_keyboard_layout = true;
              show_login_button = true;
              show_media = true;
              show_media_controls = true;
              show_password_reveal = true;
              show_session_buttons = true;
              show_unlock_hint = false;
              show_weather = true;
            };
            type = "login_box";
          };
          lockscreen-widget-date = {
            box_height = 48;
            box_width = 208;
            cx = 853.5;
            cy = 141.5;
            output = "eDP-1";
            placement_height = 1067;
            placement_width = 1707;
            rotation = 0;
            settings = {
              background_opacity = 0;
              format = "%a %b %e";
              shadow = false;
            };
            type = "clock";
          };
          lockscreen-widget-time = {
            box_height = 144;
            box_width = 416;
            cx = 853.5;
            cy = 213.5;
            output = "eDP-1";
            placement_height = 1067;
            placement_width = 1707;
            rotation = 0;
            settings = {
              background_color = "surface";
              background_opacity = 0;
              clock_style = "digital";
              color = "on_surface";
              format = "%I:%M";
              shadow = false;
            };
            type = "clock";
          };
        };
        widget_order = [
          "lockscreen-login-box@eDP-1"
          "lockscreen-widget-date"
          "lockscreen-widget-time"
        ];
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
          vertical_format = "%b%n%d%n—%n%I%n%M";
        };
        network = {
          show_label = false;
        };
        workspaces = {
          empty_color = "tertiary";
          scale = 1.1;
          show_labels = false;
        };
      };
    };
  };
}
