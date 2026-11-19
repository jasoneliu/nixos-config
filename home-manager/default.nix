# Home configuration

{
  pkgs,
  ...
}:
{
  imports = [
    ./firefox.nix
    ./git.nix
    ./kitty.nix
    ./neovim.nix
    ./niri.nix
    ./noctalia.nix
    ./vscodium.nix
    ./yazi.nix
    ./zsh.nix
  ];

  home = {
    username = "jason";
    homeDirectory = "/home/jason";

    packages = with pkgs; [
      chromium # Primarly for VIA
      fastfetch
      nixfmt
      playerctl
      xwayland-satellite
    ];

    pointerCursor = {
      enable = true;
      gtk.enable = true;

      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 20;
    };

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "26.11";
  };

  programs.home-manager.enable = true;
}
