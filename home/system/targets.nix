{ ... }:
{
  systemd.user.targets.setup = {
    Unit = {
      Description = "setup apps";
    };
  };
  
  systemd.user.targets.gaming = {
    Unit = {
      Description = "gaming apps";
    };
  };

  systemd.user.targets.work = {
    Unit = {
      Description = "work apps";
    };
  };

  systemd.user.targets.online = {
    Unit = {
      Description = "online apps";
    };
  };
}