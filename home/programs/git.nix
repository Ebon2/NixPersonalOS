{ userConfig, ... }:

{
  programs.git = {
    enable    = true;
    settings = {
      user.name  = userConfig.name;
      user.email = userConfig.email;
      init.defaultBranch = userConfig.gitDefaultBranch;
      pull.rebase        = false;
      core.editor        = "nvim";
      diff.colorMoved    = "default";
    };
  };
  
  programs.delta.enable = true;
  programs.delta.enableGitIntegration = true;
}
