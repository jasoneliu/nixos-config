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
    ./noctalia.nix
    ./vscode.nix
  ];

  home = {
    username = "jason";
    homeDirectory = "/home/jason";

    packages = with pkgs; [
      chromium # Primarly for VIA
      xwayland-satellite
    ];

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;
}
