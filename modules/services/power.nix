{ config, pkgs, ... }:

{
  # Power Profiles Daemon (para laptops)
  services.power-profiles-daemon.enable = true;

  # TLP - Advanced power management (alternativa a power-profiles-daemon)
  # NOTA: No uses ambos a la vez, solo uno
  # services.tlp = {
  #   enable = true;
  #   settings = {
  #     CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #     CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  #     CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
  #     CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
  #   };
  # };

  # UPower (monitor de batería)
  services.upower = {
    enable = true;
    percentageLow = 20;
    percentageCritical = 10;
    percentageAction = 5;
  };

  # Suspend/Hibernate
  systemd.sleep.settings = {
    Sleep = {
      HibernateDelaySec = "30min";
    };
  };

  # Brightness control (para laptops)
  # programs.light.enable = true;  # Para control de brillo sin sudo

  # Paquetes de power management
  environment.systemPackages = with pkgs; [
    powertop      # Power consumption monitor
    acpi          # Battery info
    ryzenadj  # AMD Ryzen power control (si tienes Ryzen)
  ];
}
