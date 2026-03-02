# Home configuration

{ 
  pkgs,
  ...
}: {
  imports = [
    ./firefox.nix
    ./git.nix
    ./kitty.nix
    ./neovim.nix
    ./niri.nix
    ./noctalia.nix
    ./swayidle.nix
    ./vscode.nix
  ];

  home = {
    username = "jason";
    homeDirectory = "/home/jason";

    packages = with pkgs; [
      chromium # Primarly for VIA
      playerctl
      xwayland-satellite
    ];

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;
}
