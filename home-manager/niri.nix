{
  config,
  inputs,
  pkgs,
  ...
}:
{
  wayland.windowManager.niri = {
    enable = true;

    package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri;

    settings =
      let
        kitty = "${pkgs.kitty}/bin/kitty";
        noctalia = "${pkgs.noctalia}/bin/noctalia";
      in
      {
        # Start Noctalia at startup
        spawn-at-startup = [
          noctalia
        ];

        # Configure input devices
        input = {
          touchpad = {
            tap = { };
            drag = false;
            accel-speed = 0.2;
          };
        };

        # Configure output for FW16
        output = {
          _args = [ "eDP-1" ];
          _children = [
            { mode = "2560x1600@165.000"; }
            { scale = 1.5; }
            {
              position._props = {
                x = 0;
                y = 0;
              };
            }
          ];
        };

        # Configure cursor style
        cursor = {
          xcursor-theme = "Bibata-Modern-Ice";
          xcursor-size = 20;
        };

        # Configure windows layout
        layout = {
          # Set gaps around windows
          gaps = 16;

          # Avoid centering when focusing off-screen column
          center-focused-column = "never";

          # Set background color (used before background image loads)
          background-color = "black";

          # Set default width of new windows
          default-column-width = {
            proportion = 0.5;
          };

          # Customize preset column widths
          preset-column-widths._children = [
            { proportion = 0.33333; }
            { proportion = 0.5; }
            { proportion = 0.66667; }
            { proportion = 1.0; }
          ];

          # Customize present window heights
          preset-window-heights._children = [
            { proportion = 0.5; }
            { proportion = 1.0; }
          ];

          # Configure focus ring
          focus-ring = {
            width = 3;
            active-color = "rgba(235, 188, 186, 0.6)";
          };

          # Configure struts
          struts = {
            # Reserve space for Noctalia bar on the left screen edge
            left = 32;
          };
        };

        # Configure layer and window rules
        _children = [
          {
            # Set the Noctalia overview wallpaper on the backdrop
            layer-rule = {
              match._props = {
                namespace = "^noctalia-backdrop";
              };
              place-within-backdrop = true;
            };
          }
          {
            # Open the Firefox picture-in-picture player as floating by default
            window-rule = {
              match._props = {
                app-id = "firefox$";
                title = "^Picture-in-Picture$";
              };
              open-floating = true;
            };
          }
          {
            # Add rounded corners to all windows
            window-rule = {
              geometry-corner-radius = [
                12.0
                12.0
                12.0
                12.0
              ];
              clip-to-geometry = true;
            };
          }
          {
            # Add transparency to non-active windows
            window-rule = {
              match._props = {
                is-active = false;
              };
              opacity = 0.9;
            };
          }
        ];

        # Disable the "Important Hotkeys" pop-up at startup
        hotkey-overlay.skip-at-startup = true;

        # Ask clients to omit their client-side decorations if possible
        prefer-no-csd = true;

        # Set path where screenshots are saved
        screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

        # Allow notification actions and window activation from Noctalia
        debug.honor-xdg-activation-with-invalid-serial = true;

        # Configure keybinds
        binds = {
          # ------------------------------ System ------------------------------

          # Audio
          "XF86AudioRaiseVolume".spawn = [
            noctalia
            "msg"
            "volume-up"
          ];
          "XF86AudioLowerVolume".spawn = [
            noctalia
            "msg"
            "volume-down"
          ];
          "XF86AudioMute".spawn = [
            noctalia
            "msg"
            "volume-mute"
          ];

          # Media
          "XF86AudioPlay".spawn = [
            "playerctl"
            "play-pause"
          ];
          "XF86AudioPrev".spawn = [
            "playerctl"
            "previous"
          ];
          "XF86AudioNext".spawn = [
            "playerctl"
            "next"
          ];

          # Brightness
          "XF86MonBrightnessUp".spawn = [
            noctalia
            "msg"
            "brightness-up"
          ];
          "XF86MonBrightnessDown".spawn = [
            noctalia
            "msg"
            "brightness-down"
          ];

          # Screenshots
          "Print".spawn = [
            noctalia
            "msg"
            "screenshot-region"
          ];
          "Ctrl+Print".spawn = [
            noctalia
            "msg"
            "screenshot-fullscreen"
          ];
          "Shift+Print".spawn = [
            noctalia
            "msg"
            "screenshot-window"
          ];

          # ------------------------------ User ------------------------------

          # Applications
          "Mod+Return".spawn = kitty;

          # Noctalia
          "Mod+Space".spawn = [
            noctalia
            "msg"
            "panel-toggle"
            "launcher"
          ];
          "Mod+S".spawn = [
            noctalia
            "msg"
            "panel-toggle"
            "control-center"
          ];
          "Mod+Escape".spawn = [
            noctalia
            "msg"
            "panel-toggle"
            "session"
          ];

          # ------------------------------ Niri ------------------------------

          # Hotkey overlay
          "Mod+Shift+Slash".show-hotkey-overlay = { };

          # Escape hatch to toggle the inhibitor
          "Mod+Shift+Escape" = {
            _props.allow-inhibiting = false;
            toggle-keyboard-shortcuts-inhibit = { };
          };

          # Exit niri
          "Mod+Ctrl+Escape".quit = { };

          # ------------------------------ Columns + Windows ------------------------------

          # Close window
          "Mod+Q" = {
            _props.repeat = false;
            close-window = { };
          };

          # Focus column / window
          "Mod+Left".focus-column-left = { };
          "Mod+Down".focus-window-down = { };
          "Mod+Up".focus-window-up = { };
          "Mod+Right".focus-column-right = { };
          "Mod+N".focus-column-left = { };
          "Mod+E".focus-window-down = { };
          "Mod+I".focus-window-up = { };
          "Mod+O".focus-column-right = { };
          "Mod+TouchpadScrollRight" = {
            _props.cooldown-ms = 150;
            focus-column-right = { };
          };
          "Mod+TouchpadScrollLeft" = {
            _props.cooldown-ms = 150;
            focus-column-left = { };
          };
          "Mod+Shift+TouchpadScrollDown" = {
            _props.cooldown-ms = 150;
            focus-column-right = { };
          };
          "Mod+Shift+TouchpadScrollUp" = {
            _props.cooldown-ms = 150;
            focus-column-left = { };
          };

          # Move column / window
          "Mod+Ctrl+Left".move-column-left = { };
          "Mod+Ctrl+Down".move-window-down = { };
          "Mod+Ctrl+Up".move-window-up = { };
          "Mod+Ctrl+Right".move-column-right = { };
          "Mod+Ctrl+N".move-column-left = { };
          "Mod+Ctrl+E".move-window-down = { };
          "Mod+Ctrl+I".move-window-up = { };
          "Mod+Ctrl+O".move-column-right = { };
          "Mod+Ctrl+TouchpadScrollRight" = {
            _props.cooldown-ms = 150;
            move-column-right = { };
          };
          "Mod+Ctrl+TouchpadScrollLeft" = {
            _props.cooldown-ms = 150;
            move-column-left = { };
          };
          "Mod+Ctrl+Shift+TouchpadScrollDown" = {
            _props.cooldown-ms = 150;
            move-column-right = { };
          };
          "Mod+Ctrl+Shift+TouchpadScrollUp" = {
            _props.cooldown-ms = 150;
            move-column-left = { };
          };

          # Focus first / last column
          "Mod+Home".focus-column-first = { };
          "Mod+H".focus-column-first = { };
          "Mod+End".focus-column-last = { };
          "Mod+Slash".focus-column-last = { };

          # Move column to first / last
          "Mod+Ctrl+Home".move-column-to-first = { };
          "Mod+Ctrl+H".move-column-to-first = { };
          "Mod+Ctrl+End".move-column-to-last = { };
          "Mod+Ctrl+Slash".move-column-to-last = { };

          # Move the focused window in and out of a column
          "Mod+BracketLeft".consume-or-expel-window-left = { };
          "Mod+BracketRight".consume-or-expel-window-right = { };

          # Consume one window from the right to the bottom of the focused column
          "Mod+Comma".consume-window-into-column = { };

          # Expel the bottom window from the focused column to the right
          "Mod+Period".expel-window-from-column = { };

          # Move the focused window between the floating and the tiling layout
          "Mod+V".toggle-window-floating = { };
          "Mod+Shift+V".switch-focus-between-floating-and-tiling = { };

          # Toggle tabbed column display mode
          "Mod+W".toggle-column-tabbed-display = { };

          # Center column
          "Mod+C".center-column = { };

          # Center all fully visible columns
          "Mod+Ctrl+C".center-visible-columns = { };

          # ------------------------------ Resizing ------------------------------

          # Cycle through preset column widths / window heights
          "Mod+R".switch-preset-column-width = { };
          "Mod+Shift+R".switch-preset-column-width-back = { };
          "Mod+Ctrl+R".switch-preset-window-height = { };
          "Mod+Ctrl+Shift+R".switch-preset-window-height-back = { };

          # Adjust column width / window height
          "Mod+Minus".set-column-width = "-10%";
          "Mod+Equal".set-column-width = "+10%";
          "Mod+Shift+Minus".set-window-height = "-10%";
          "Mod+Shift+Equal".set-window-height = "+10%";

          # Maximize column width
          "Mod+F".maximize-column = { };

          # Fullscreen window
          "Mod+Shift+F".fullscreen-window = { };

          # Expand the focused column to fill space not taken up by other fully visible columns
          "Mod+Ctrl+F".expand-column-to-available-width = { };

          # Maximize window to edges of the screen
          "Mod+M".maximize-window-to-edges = { };

          # ------------------------------ Workspaces ------------------------------

          # Toggle overview
          "Mod+Tab" = {
            _props.repeat = false;
            toggle-overview = { };
          };

          # Focus workspace
          "Mod+Page_Down".focus-workspace-down = { };
          "Mod+Page_Up".focus-workspace-up = { };
          "Mod+U".focus-workspace-down = { };
          "Mod+Y".focus-workspace-up = { };
          "Mod+TouchpadScrollDown" = {
            _props.cooldown-ms = 150;
            focus-workspace-down = { };
          };
          "Mod+TouchpadScrollUp" = {
            _props.cooldown-ms = 150;
            focus-workspace-up = { };
          };
          "Mod+1".focus-workspace = 1;
          "Mod+2".focus-workspace = 2;
          "Mod+3".focus-workspace = 3;
          "Mod+4".focus-workspace = 4;
          "Mod+5".focus-workspace = 5;
          "Mod+6".focus-workspace = 6;
          "Mod+7".focus-workspace = 7;
          "Mod+8".focus-workspace = 8;
          "Mod+9".focus-workspace = 9;

          # Move column to workspace
          "Mod+Ctrl+Page_Down".move-column-to-workspace-down = { };
          "Mod+Ctrl+Page_Up".move-column-to-workspace-up = { };
          "Mod+Ctrl+U".move-column-to-workspace-down = { };
          "Mod+Ctrl+Y".move-column-to-workspace-up = { };
          "Mod+Ctrl+TouchpadScrollDown" = {
            _props.cooldown-ms = 150;
            move-column-to-workspace-down = { };
          };
          "Mod+Ctrl+TouchpadScrollUp" = {
            _props.cooldown-ms = 150;
            move-column-to-workspace-up = { };
          };
          "Mod+Ctrl+1".move-column-to-workspace = 1;
          "Mod+Ctrl+2".move-column-to-workspace = 2;
          "Mod+Ctrl+3".move-column-to-workspace = 3;
          "Mod+Ctrl+4".move-column-to-workspace = 4;
          "Mod+Ctrl+5".move-column-to-workspace = 5;
          "Mod+Ctrl+6".move-column-to-workspace = 6;
          "Mod+Ctrl+7".move-column-to-workspace = 7;
          "Mod+Ctrl+8".move-column-to-workspace = 8;
          "Mod+Ctrl+9".move-column-to-workspace = 9;

          # Move workspace
          "Mod+Shift+Page_Down".move-workspace-down = { };
          "Mod+Shift+Page_Up".move-workspace-up = { };
          "Mod+Shift+U".move-workspace-down = { };
          "Mod+Shift+Y".move-workspace-up = { };

          # ------------------------------ Monitors ------------------------------

          # Focus monitor
          "Mod+Shift+Left".focus-monitor-left = { };
          "Mod+Shift+Down".focus-monitor-down = { };
          "Mod+Shift+Up".focus-monitor-up = { };
          "Mod+Shift+Right".focus-monitor-right = { };
          "Mod+Shift+N".focus-monitor-left = { };
          "Mod+Shift+E".focus-monitor-down = { };
          "Mod+Shift+I".focus-monitor-up = { };
          "Mod+Shift+O".focus-monitor-right = { };

          # Move column to monitor
          "Mod+Shift+Ctrl+Left".move-column-to-monitor-left = { };
          "Mod+Shift+Ctrl+Down".move-column-to-monitor-down = { };
          "Mod+Shift+Ctrl+Up".move-column-to-monitor-up = { };
          "Mod+Shift+Ctrl+Right".move-column-to-monitor-right = { };
          "Mod+Shift+Ctrl+N".move-column-to-monitor-left = { };
          "Mod+Shift+Ctrl+E".move-column-to-monitor-down = { };
          "Mod+Shift+Ctrl+I".move-column-to-monitor-up = { };
          "Mod+Shift+Ctrl+O".move-column-to-monitor-right = { };
        };
      };
  };
}
