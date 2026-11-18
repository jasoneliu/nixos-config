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
      ];

      userSettings = {
        "telemetry.enableTelemetry" = false;
        "editor.formatOnSave" = true;
        "editor.fontFamily" = "'Iosevka', monospace";
        "editor.fontLigatures" = false;
        "terminal.integrated.fontFamily" = "'Iosevka', monospace";
      };
    };
  };
}
