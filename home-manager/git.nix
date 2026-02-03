{
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;

    settings= {
      user = {
        name = "jasoneliu";
        email = "jasoneliu03@gmail.com";
      };

      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "nvim";
    };
  };
}
