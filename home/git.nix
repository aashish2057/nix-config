{lib, ...}: {
  programs.git = {
    enable = true;

    userName = "aashish2057";
    userEmail = "aashish2057@gmail.com";

    extraConfig = {
      push.autoSetupRemote = true;
      pull.rebase = true;
    };

    delta = {
      enable = true;
      options.features = "side-by-side";
    };
  };
}
