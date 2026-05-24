{ ... }:

{
  programs.mangohud = {
    enable = true;

    settings = {
      # Posición
      position = "top-left";
      offset_x = 15;
      offset_y = 15;

      # FPS / frametime
      fps = true;
      frametime = true;
      frame_timing = 1;

      # GPU
      gpu_stats = true;
      gpu_temp = true;
      gpu_core_clock = true;
      gpu_mem_clock = true;
      gpu_power = true;
      gpu_load = true;
      vram = true;
      gpu_name = true;

      # CPU
      cpu_stats = true;
      cpu_temp = true;
      cpu_power = true;
      cpu_load_change = true;

      # RAM
      ram = true;

      # Proton/Wine
      wine = true;

      # HUD
      font_size = 24;
      font_scale = 1.0;
      background_alpha = 0.35;
      round_corners = 10;
      alpha = 0.95;
      legacy_layout = false;

      # Colores
      text_color = "FFFFFF";
      gpu_color = "00E5FF";
      cpu_color = "FF3C78";
      vram_color = "00FF85";
      ram_color = "FFD700";
      fps_color = "8B5CF6";
      frametime_color = "FF4444";

      # Layout
      table_columns = 2;
      histogram = true;

      # Hotkeys
      toggle_hud = "Shift_R+F12";
      toggle_logging = "Shift_L+F2";

      # Menos ruido
      media_player_name = "off";
      battery = "off";
      network = "off";
      fan = "off";
    };
  };
}