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

          audio.max_duration_secs = 600;

          hotkey = {
            enabled = false;
            mode = "toggle";
          };

          osd.enabled = false;

          output = {
            mode = "type";
          };

          parakeet = {
            model = "parakeet-unified-en-0.6b";
            streaming = true;
            streaming_chunk_secs = 0.32;
            streaming_left_context_secs = 5.6;
            streaming_right_context_secs = 0.32;
          };
        };
      };
    }
  ];
}
