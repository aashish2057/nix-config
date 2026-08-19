{pkgs, ...}: let
  package = pkgs.voxtype-onnx;
in {
  home-manager.sharedModules = [
    {
      services.voxtype = {
        enable = true;
        inherit package;
        wayland.display = "wayland-1";

        settings = {
          engine = "parakeet";
          state_file = "auto";

          audio.feedback.enabled = true;
          audio.max_duration_secs = 600;

          hotkey = {
            enabled = false;
            mode = "toggle";
          };

          osd.enabled = false;

          output = {
            mode = "paste";
            paste_keys = "ctrl+shift+v";
            restore_clipboard = true;
            restore_clipboard_delay_ms = 500;
          };

          parakeet = {
            model = "parakeet-tdt-0.6b-v3-int8";
            model_type = "tdt";
          };
        };
      };
    }
  ];
}
