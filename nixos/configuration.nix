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
    ];
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
    };
    
    channel.enable = false;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
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

  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };
  niri-flake.cache.enable = true;

  security.rtkit.enable = true;

  services = {
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

    greetd = {
      enable = true;

      settings = {
        # Launch niri on startup
        initial_session = {
          command = "niri-session";
          user = "jason";
        };

        # Fall back to tuigreet
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
          user = "greeter";
        };
      };
    };

    power-profiles-daemon.enable = true;
    printing.enable = true;
    upower.enable = true;
    udev.packages = [ pkgs.via ];
  };

  time.timeZone = "America/Los_Angeles";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
