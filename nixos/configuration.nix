# System configuration

{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.framework-16-amd-ai-300-series
    inputs.home-manager.nixosModules.home-manager
    inputs.niri.nixosModules.niri
    
    ./hardware-configuration.nix
    ./users.nix
  ];

  nixpkgs = {
    config.allowUnfree = true;

    overlays = [
      inputs.nur.overlays.default
      inputs.niri.overlays.niri

      # Force noctalia-shell to use the flake input version globally
      (final: prev: {
        noctalia-shell = inputs.noctalia.packages.${prev.stdenv.hostPlatform.system}.default;
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
      experimental-features = "nix-command flakes";

      # Disable global registry
      flake-registry = "";
    };
  };

  boot = {
    # Silence most kernel logs
    consoleLogLevel = 0;

    initrd = {
      systemd.enable = true;

      # Silence NixOS logs
      verbose = false;
    };

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
      package = pkgs.niri;
    };
  };

  # Enable rtkit for audio
  security.rtkit.enable = true;

  services = {
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

    # Configure greeter
    greetd = {
      enable = true;

      settings = let
        niri-session = "${pkgs.niri}/bin/niri-session";
        tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
      in {
        # Launch niri on startup
        initial_session = {
          # Silence niri log: https://github.com/niri-wm/niri/issues/254
          command = "${niri-session} 2> /dev/null";
          user = "jason";
        };

        # Fall back to tuigreet
        default_session = {
          # Silence niri log: https://github.com/niri-wm/niri/issues/254
          command = "${tuigreet} --time --remember --cmd ${niri-session} 2> /dev/null";
          user = "greeter";
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
  system.stateVersion = "25.11";
}
