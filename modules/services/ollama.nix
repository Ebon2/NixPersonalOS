{ config, pkgs, ... }:

{
  # ─────────────────────────────────────────────────────────────────────────────
  # Ollama — inferencia local 100% en CPU
  #
  # Ya usas nixos-unstable como nixpkgs en el flake, así que pkgs.ollama-cpu
  # ya es la versión más reciente. No es necesario importar canales externos.
  # ─────────────────────────────────────────────────────────────────────────────
  services.ollama = {
    enable = true;

    # ollama-cpu = build sin soporte CUDA/ROCm → fuerza procesamiento en CPU
    package = pkgs.ollama;

    environmentVariables = {
      OLLAMA_MODELS            = "/var/lib/ollama/models";
      OLLAMA_NUM_PARALLEL      = "2";     # peticiones paralelas al demonio
      OLLAMA_MAX_LOADED_MODELS = "1";     # máximo 1 modelo en RAM a la vez
      OLLAMA_FLASH_ATTENTION   = "1";     # reduce uso de memoria
      OLLAMA_KEEP_ALIVE        = "5m";    # descarga el modelo tras 5 min inactivo
      OLLAMA_NUM_THREADS       = "14";    # hilos de CPU (ajusta a tus núcleos)
      OLLAMA_KV_CACHE_TYPE     = "q8_0";  # caché cuantizado → menos RAM en CPU
    };
  };

  # ─────────────────────────────────────────────────────────────────────────────
  # Exponer el binario `ollama` en el PATH global de todos los usuarios.
  #
  # El módulo services.ollama instala el demonio pero NO añade el CLI al PATH.
  # Sin esto, `ollama pull gemma3:2b` daría "command not found".
  # ─────────────────────────────────────────────────────────────────────────────
  environment.systemPackages = [ pkgs.ollama-cpu ];
}
