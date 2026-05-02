{ ... }:

{
  programs.git = {
    enable    = true;
    userName  = "username";
    userEmail = "user@email.com"; # ← cambia esto

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase        = false;
      core.editor        = "nvim";
      diff.colorMoved    = "default";
    };

    # delta — diff más bonito (opcional)
    delta.enable = true;
  };
}
