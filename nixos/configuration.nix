# System configuration

{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.framework-16-amd-ai-300-series
    inputs.home-manager.nixosModules.home-manager

    ./fonts.nix
    ./hardware-configuration.nix
    ./users.nix
  ];

  nixpkgs = {
    config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-unwrapped"
        "via"
      ];

    overlays = [
      inputs.nur.overlays.default

      # Force noctalia to use the flake input version globally
      (final: prev: {
        noctalia = inputs.noctalia.packages.${prev.stdenv.hostPlatform.system}.default;
      })
    ];
  };

  nix = {
    # Disable channels
    channel.enable = false;

    settings = {
      # Deduplicate store files
      auto-optimise-store = true;

      # Enable flakes
      experimental-features = [ "nix-command flakes" ];

      # Disable global registry
      flake-registry = "";
    };
  };

  boot = {
    # Silence most kernel logs
    consoleLogLevel = 0;

    kernelPackages = pkgs.linuxPackages_latest;

    kernelParams = [
      # Silence most kernel logs
      "quiet"
    ];

    loader = {
      # Enable the systemd-boot EFI boot manager
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;

      # Skip the boot menu
      # To show the boot menu, press space repeatedly during boot
      timeout = 0;
    };

    plymouth.enable = true;
  };

  environment.systemPackages = with pkgs; [
    git
    qmk
    unzip
    via
    vim
  ];

  hardware = {
    bluetooth.enable = true;
    keyboard.qmk.enable = true;
  };

  networking = {
    hostName = "fw16";
    networkmanager.enable = true;
  };

  programs = {
    nh = {
      enable = true;
      flake = "/home/jason/nixos-config";

      # Clean old NixOS generations
      clean = {
        enable = true;
        dates = "weekly";

        # Delete generations older than 30 days, but keep at least 5 generations
        extraArgs = "--keep-since 30d --keep 5";
      };
    };

    niri = {
      enable = true;
      package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri;
    };

    steam.enable = true;

    zsh.enable = true;
  };

  security = {
    # Enable rtkit for audio
    rtkit.enable = true;

    # Disable fingerprint during login
    pam.services.login.fprintAuth = false;
  };

  services = {
    # Configure greeter
    displayManager.noctalia-greeter = {
      enable = true;

      settings = {
        appearance = {
          scheme = "Rosé Pine";
          hide_logo = true;
          power_buttons_position = "bottom-right";
          scheme_selector_position = "hidden";
          wallpaper = {
            # blur = 0.2; # Blur doesn't apply for unknown reason
            fill_mode = "crop";
            path = "${../assets/wallpapers/evening-sky.png}";
          };
        };
        clock = {
          position = "above-panel";
          time_format = "%I:%M";
          date_format = "%a %b %e";
        };
        cursor = {
          path = pkgs.bibata-cursors;
          theme = "Bibata-Modern-Ice";
          size = 20;
        };
        output = {
          # Use 1.6x scale to avoid 1px gap in wallpaper due to rounding
          scales = "eDP-1:1.600";
          transforms = "eDP-1:normal";
          use_synced_settings = false;
        };
      };
    };

    # Configure lid events
    logind.settings = {
      Login = {
        # Suspend on lid close
        HandleLidSwitch = "suspend";
        HandleLidSwitchExternalPower = "suspend";

        # Always handle lid events, ignoring inhibitor locks
        LidSwitchIgnoreInhibited = "yes";

        # Add short lid event cooldown to detect hotplugged devices (e.g. external monitors or docks)
        HoldoffTimeoutSec = "1s";
      };
    };

    # Configure audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

      # Fix for FW16 audio
      wireplumber.extraConfig = {
        "10-disable-ucm" = {
          "monitor.alsa.properties" = {
            "alsa.use-ucm" = false;
          };
        };
      };
    };

    # Enable power services
    power-profiles-daemon.enable = true;
    upower.enable = true;

    # Enable fingerprint reader, used for login and sudo
    fprintd.enable = true;

    # Enable CUPS for printing
    printing.enable = true;

    # Configure udev to support VIA
    udev.packages = [ pkgs.via ];
  };

  time.timeZone = "America/Los_Angeles";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "26.11";
}
