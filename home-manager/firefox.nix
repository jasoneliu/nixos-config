{ 
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
      settings = {
        "browser.search.region" = "US";
        "browser.aboutConfig.showWarning" = false;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        bitwarden
	ublock-origin
      ];
    };
  };
}
