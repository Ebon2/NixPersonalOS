{ ... }:

{
  programs.git = {
    enable    = true;
    settings = {
      user.name  = "username";
      user.email = "user@email.com";
      init.defaultBranch = "main";
      pull.rebase        = false;
      core.editor        = "nvim";
      diff.colorMoved    = "default";
    };
  };
  
  programs.delta.enable = true;
  programs.delta.enableGitIntegration = true;
}
