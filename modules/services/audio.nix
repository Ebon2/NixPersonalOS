{ config, pkgs, ... }:

{
  # Deshabilitar PulseAudio (usamos PipeWire)
  services.pulseaudio.enable = false;

  # Habilitar RealtimeKit para prioridad de audio
  security.rtkit.enable = true;

  # PipeWire - servidor de audio moderno
  services.pipewire = {
    enable = true;
    
    # Compatibilidad con ALSA
    alsa = {
      enable = true;
      support32Bit = true;  # Para juegos y apps de 32 bits
    };
    
    # Compatibilidad con PulseAudio
    pulse.enable = true;
    
    # JACK (para producción musical - descomenta si lo necesitas)
    # jack.enable = true;

    # Configuración de latencia baja (para audio profesional)
    # wireplumber.configPackages = [
    #   (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/99-low-latency.conf" ''
    #     monitor.alsa.rules = [
    #       {
    #         matches = [ { node.name = "~alsa_output.*" } ]
    #         actions = {
    #           update-props = {
    #             api.alsa.period-size = 256
    #             api.alsa.headroom = 1024
    #           }
    #         }
    #       }
    #     ]
    #   '')
    # ];
  };

  # Paquetes de audio adicionales
  environment.systemPackages = with pkgs; [
    # Utilidades
    pavucontrol  # Control de volumen gráfico
    # easyeffects  # Efectos de audio (ecualizador, etc)
    # helvum       # Patchbay gráfico para PipeWire
  ];
}
