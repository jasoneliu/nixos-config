{
  config,
  pkgs,
  ...
}: {
  programs.niri.settings = let
    kitty = "${pkgs.kitty}/bin/kitty";
    noctalia-shell = "${pkgs.noctalia-shell}/bin/noctalia-shell";
  in {
    # Spawn processes at startup
    spawn-at-startup = [
      # Start Noctalia
      {
        command = [
          noctalia-shell
        ];
      }

      # Show Noctalia lock screen on startup
      { 
        command = [
          "sh" "-c" 
          ''
            # Check every 1ms for up to 1s
            i=0
            while [ $i -lt 1000 ]; do
              # Check if Noctalia has started
              if [ -S /run/user/$(id -u)/quickshell/by-id/*/ipc.sock ]; then
                # Try locking screen
                ${noctalia-shell} ipc call lockScreen lock
                
                # Check if lock screen is active
                if ${noctalia-shell} ipc call state all | grep -q '"lockScreenActive": true'; then
                  break
                fi
              fi

              sleep 0.001
              i=$((i+1))
            done
          ''
        ]; 
      }
    ];

    # Configure input devices
    input = {
      touchpad = {
        tap = true;
        drag = false;
        natural-scroll = false;
        accel-speed = 0.2;
      };
    };

    # Configure outputs for FW16
    outputs."eDP-1" = {
      mode = {
        height = 1600;
        width = 2560;
        refresh = 165.000;
      };
      scale = 1.5;
      position = {
        x = 0;
        y = 0;
      };
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
      preset-column-widths = [
        { proportion = 0.33333; }
        { proportion = 0.5; }
        { proportion = 0.66667; }
        { proportion = 1.0; }
      ];

      # Customize present window heights
      preset-window-heights = [
        { proportion = 0.5; }
        { proportion = 1.0; }
      ];

      # Configure focus ring
      focus-ring = {
        width = 3;
        active = {
          color = "rgba(180, 190, 254, 0.6)";
        };
      };

      # Configure shortcuts
      struts = {
        left = -8;
      };
    };

    # Configure window rules
    window-rules = [
      # Open the Firefox picture-in-picture player as floating by default
      {
        matches = [
          {
            app-id = "firefox$";
            title = "^Picture-in-Picture$";
          }
        ];
        open-floating = true;
      }

      # Add rounded corners to all windows
      {
        geometry-corner-radius = {
          bottom-left = 12.0;
          bottom-right = 12.0;
          top-left = 12.0;
          top-right = 12.0;
        };
        clip-to-geometry = true;
      }

      # Add transparency to non-active windows
      {
        matches = [
          {
            is-active = false;
          }
        ];
        opacity = 0.9;
      }
    ];

    # Configure layout rules
    layer-rules = [
      # Set the Noctalia overview wallpaper on the backdrop
      {
        matches = [
          {
            namespace = "^noctalia-overview*";
          }
        ];
        place-within-backdrop = true;
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
    binds = with config.lib.niri.actions; {
      # ------------------------------ System ------------------------------

      # Audio
      "XF86AudioRaiseVolume".action.spawn = [noctalia-shell "ipc" "call" "volume" "increase"];
      "XF86AudioLowerVolume".action.spawn = [noctalia-shell "ipc" "call" "volume" "decrease"];
      "XF86AudioMute".action.spawn = [noctalia-shell "ipc" "call" "volume" "muteOutput"];

      # Media
      "XF86AudioPlay".action.spawn = ["playerctl" "play-pause"];
      "XF86AudioPrev".action.spawn = ["playerctl" "previous"];
      "XF86AudioNext".action.spawn = ["playerctl" "next"];

      # Brightness
      "XF86MonBrightnessUp".action.spawn = [noctalia-shell "ipc" "call" "brightness" "increase"];
      "XF86MonBrightnessDown".action.spawn = [noctalia-shell "ipc" "call" "brightness" "decrease"];
      
      # Screenshots
      "Print".action.screenshot = {
        show-pointer = false;
      };
      "Ctrl+Print".action.screenshot-screen = {
        show-pointer = false;
      };
      "Shift+Print".action.screenshot-window = {};

      # ------------------------------ User ------------------------------

      # Applications
      "Mod+Return".action.spawn = kitty;

      # Noctalia
      "Mod+Space".action.spawn = [noctalia-shell "ipc" "call" "launcher" "toggle"];
      "Mod+S".action.spawn = [noctalia-shell "ipc" "call" "controlCenter" "toggle"];
      "Mod+Escape".action.spawn = [noctalia-shell "ipc" "call" "lockScreen" "lock"];
      
      # ------------------------------ Niri ------------------------------
      
      # Hotkey overlay
      "Mod+Shift+Slash".action = show-hotkey-overlay;

      # Escape hatch to toggle the inhibitor
      "Mod+Shift+Escape" = { 
        allow-inhibiting = false; 
        action = toggle-keyboard-shortcuts-inhibit; 
      };

      # Exit niri
      "Mod+Ctrl+Escape".action = quit;

      # ------------------------------ Columns + Windows ------------------------------

      # Close window
      "Mod+Q" = {
        repeat = false;
        action = close-window;
      };

      # Focus column / window
      "Mod+Left".action = focus-column-left;
      "Mod+Down".action = focus-window-down;
      "Mod+Up".action = focus-window-up;
      "Mod+Right".action = focus-column-right;
      "Mod+N".action = focus-column-left;
      "Mod+E".action = focus-window-down;
      "Mod+I".action = focus-window-up;
      "Mod+O".action = focus-column-right;
      "Mod+TouchpadScrollRight" = {
        cooldown-ms = 150;
        action = focus-column-right;
      };
      "Mod+TouchpadScrollLeft" = {
        cooldown-ms = 150;
        action = focus-column-left;
      };
      "Mod+Shift+TouchpadScrollDown" = {
        cooldown-ms = 150;
        action = focus-column-right;
      };
      "Mod+Shift+TouchpadScrollUp" = {
        cooldown-ms = 150;
        action = focus-column-left;
      };

      # Move column / window
      "Mod+Ctrl+Left".action = move-column-left;
      "Mod+Ctrl+Down".action = move-window-down;
      "Mod+Ctrl+Up".action = move-window-up;
      "Mod+Ctrl+Right".action = move-column-right;
      "Mod+Ctrl+N".action = move-column-left;
      "Mod+Ctrl+E".action = move-window-down;
      "Mod+Ctrl+I".action = move-window-up;
      "Mod+Ctrl+O".action = move-column-right;
      "Mod+Ctrl+TouchpadScrollRight" = {
        cooldown-ms = 150;
        action = move-column-right;
      };
      "Mod+Ctrl+TouchpadScrollLeft" = {
        cooldown-ms = 150;
        action = move-column-left;
      };
      "Mod+Ctrl+Shift+TouchpadScrollDown" = {
        cooldown-ms = 150;
        action = move-column-right;
      };
      "Mod+Ctrl+Shift+TouchpadScrollUp" = {
        cooldown-ms = 150;
        action = move-column-left;
      };

      # Focus first / last column
      "Mod+Home".action = focus-column-first;
      "Mod+H".action = focus-column-first;
      "Mod+End".action = focus-column-last;
      "Mod+Slash".action = focus-column-last;

      # Move column to first / last
      "Mod+Ctrl+Home".action = move-column-to-first;
      "Mod+Ctrl+H".action = move-column-to-first;
      "Mod+Ctrl+End".action = move-column-to-last;
      "Mod+Ctrl+Slash".action = move-column-to-last;

      # Move the focused window in and out of a column
      "Mod+BracketLeft".action = consume-or-expel-window-left;
      "Mod+BracketRight".action = consume-or-expel-window-right;

      # Consume one window from the right to the bottom of the focused column
      "Mod+Comma".action = consume-window-into-column;
      
      # Expel the bottom window from the focused column to the right
      "Mod+Period".action = expel-window-from-column;

      # Move the focused window between the floating and the tiling layout
      "Mod+V".action = toggle-window-floating;
      "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;

      # Toggle tabbed column display mode
      "Mod+W".action = toggle-column-tabbed-display;

      # Center column
      "Mod+C".action = center-column;

      # Center all fully visible columns
      "Mod+Ctrl+C".action = center-visible-columns;

      # ------------------------------ Resizing ------------------------------

      # Cycle through preset column widths / window heights
      "Mod+R".action = switch-preset-column-width;
      "Mod+Shift+R".action = switch-preset-column-width-back;
      "Mod+Ctrl+R".action = switch-preset-window-height;
      "Mod+Ctrl+Shift+R".action = switch-preset-window-height-back;

      # Adjust column width / window height
      "Mod+Minus".action = set-column-width "-10%";
      "Mod+Equal".action = set-column-width "+10%";
      "Mod+Shift+Minus".action = set-window-height "-10%";
      "Mod+Shift+Equal".action = set-window-height "+10%";

      # Maximize column width
      "Mod+F".action = maximize-column;

      # Fullscreen window
      "Mod+Shift+F".action = fullscreen-window;

      # Expand the focused column to fill space not taken up by other fully visible columns
      "Mod+Ctrl+F".action = expand-column-to-available-width;

      # Maximize window to edges of the screen
      "Mod+M".action = maximize-window-to-edges;
      
      # ------------------------------ Workspaces ------------------------------

      # Toggle overview
      "Mod+Tab" = { repeat = false; action = toggle-overview; };

      # Focus workspace
      "Mod+Page_Down".action = focus-workspace-down;
      "Mod+Page_Up".action = focus-workspace-up;
      "Mod+U".action = focus-workspace-down;
      "Mod+Y".action = focus-workspace-up;
      "Mod+TouchpadScrollDown" = {
        cooldown-ms = 150;
        action = focus-workspace-down;
      };
      "Mod+TouchpadScrollUp" = {
        cooldown-ms = 150;
        action = focus-workspace-up;
      };
      "Mod+1".action = focus-workspace 1;
      "Mod+2".action = focus-workspace 2;
      "Mod+3".action = focus-workspace 3;
      "Mod+4".action = focus-workspace 4;
      "Mod+5".action = focus-workspace 5;
      "Mod+6".action = focus-workspace 6;
      "Mod+7".action = focus-workspace 7;
      "Mod+8".action = focus-workspace 8;
      "Mod+9".action = focus-workspace 9;

      # Move column to workspace
      "Mod+Ctrl+Page_Down".action = move-column-to-workspace-down;
      "Mod+Ctrl+Page_Up".action = move-column-to-workspace-up;
      "Mod+Ctrl+U".action = move-column-to-workspace-down;
      "Mod+Ctrl+Y".action = move-column-to-workspace-up;
      "Mod+Ctrl+TouchpadScrollDown" = {
        cooldown-ms = 150;
        action = move-column-to-workspace-down;
      };
      "Mod+Ctrl+TouchpadScrollUp" = {
        cooldown-ms = 150;
        action = move-column-to-workspace-up;
      };
      "Mod+Ctrl+1".action.move-column-to-workspace = 1;
      "Mod+Ctrl+2".action.move-column-to-workspace = 2;
      "Mod+Ctrl+3".action.move-column-to-workspace = 3;
      "Mod+Ctrl+4".action.move-column-to-workspace = 4;
      "Mod+Ctrl+5".action.move-column-to-workspace = 5;
      "Mod+Ctrl+6".action.move-column-to-workspace = 6;
      "Mod+Ctrl+7".action.move-column-to-workspace = 7;
      "Mod+Ctrl+8".action.move-column-to-workspace = 8;
      "Mod+Ctrl+9".action.move-column-to-workspace = 9;

      # Move workspace
      "Mod+Shift+Page_Down".action = move-workspace-down;
      "Mod+Shift+Page_Up".action = move-workspace-up;
      "Mod+Shift+U".action = move-workspace-down;
      "Mod+Shift+Y".action = move-workspace-up;

      # ------------------------------ Monitors ------------------------------
      
      # Focus monitor
      "Mod+Shift+Left".action = focus-monitor-left;
      "Mod+Shift+Down".action = focus-monitor-down;
      "Mod+Shift+Up".action = focus-monitor-up;
      "Mod+Shift+Right".action = focus-monitor-right;
      "Mod+Shift+N".action = focus-monitor-left;
      "Mod+Shift+E".action = focus-monitor-down;
      "Mod+Shift+I".action = focus-monitor-up;
      "Mod+Shift+O".action = focus-monitor-right;

      # Move column to monitor
      "Mod+Shift+Ctrl+Left".action = move-column-to-monitor-left;
      "Mod+Shift+Ctrl+Down".action = move-column-to-monitor-down;
      "Mod+Shift+Ctrl+Up".action = move-column-to-monitor-up;
      "Mod+Shift+Ctrl+Right".action = move-column-to-monitor-right;
      "Mod+Shift+Ctrl+N".action = move-column-to-monitor-left;
      "Mod+Shift+Ctrl+E".action = move-column-to-monitor-down;
      "Mod+Shift+Ctrl+I".action = move-column-to-monitor-up;
      "Mod+Shift+Ctrl+O".action = move-column-to-monitor-right;
    };
  };
}
