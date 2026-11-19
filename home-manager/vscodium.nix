{
  pkgs,
  ...
}:
{
  programs.vscodium = {
    enable = true;

    package = pkgs.vscodium;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        esbenp.prettier-vscode
        mvllow.rose-pine
      ];

      userSettings = {
        "telemetry.enableTelemetry" = false;
        "editor.formatOnSave" = true;
        "editor.fontFamily" = "'Iosevka', monospace";
        "editor.fontLigatures" = false;
        "terminal.integrated.fontFamily" = "'Iosevka', monospace";
        "workbench.colorTheme" = "Rosé Pine";
        "workbench.iconTheme" = "rose-pine-icons";
      };
    };
  };
}
