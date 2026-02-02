{
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "jasoneliu";
    userEmail = "jasoneliu03@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "nvim";
    };
  };
}
