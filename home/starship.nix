{...}: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = builtins.concatStringsSep "" [
        "  $username"
        "$hostname"
        "$localip"
        "$shlvl"
        "$singularity"
        "$kubernetes"
        "$directory"
        "$vcsh"
        "$fossil_branch"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$git_metrics"
        "$git_status"
        "$hg_branch"
        "$pijul_channel"
        "$docker_context"
        "$package"
        "$c"
        "$cmake"
        "$cobol"
        "$daml"
        "$dart"
        "$deno"
        "$dotnet"
        "$elixir"
        "$elm"
        "$erlang"
        "$fennel"
        "$golang"
        "$guix_shell"
        "$haskell"
        "$haxe"
        "$helm"
        "$java"
        "$julia"
        "$kotlin"
        "$gradle"
        "$lua"
        "$nim"
        "$nodejs"
        "$ocaml"
        "$opa"
        "$perl"
        "$php"
        "$pulumi"
        "$purescript"
        "$python"
        "$raku"
        "$rlang"
        "$red"
        "$ruby"
        "$rust"
        "$scala"
        "$solidity"
        "$swift"
        "$terraform"
        "$vlang"
        "$vagrant"
        "$zig"
        "$buf"
        "$nix_shell"
        "$conda"
        "$meson"
        "$spack"
        "$memory_usage"
        "$aws"
        "$gcloud"
        "$openstack"
        "$azure"
        "$env_var"
        "$crystal"
        "$custom"
        "$sudo"
        "$cmd_duration"
        "$line_break"
        "$jobs"
        "$battery"
        "$time"
        "$status"
        "$os"
        "$container"
        "$shell"
        "$character"
      ];
      command_timeout = 1000;

      # Disable the line_break module.
      line_break = {
        disabled = true;
      };

      aws = {
        symbol = "  ";
      };

      buf = {
        symbol = " ";
      };

      c = {
        symbol = " ";
      };

      conda = {
        symbol = " ";
      };

      dart = {
        symbol = " ";
      };

      docker_context = {
        symbol = " ";
      };

      elixir = {
        symbol = " ";
      };

      elm = {
        symbol = " ";
      };

      fossil_branch = {
        symbol = " ";
      };

      golang = {
        symbol = " ";
      };

      guix_shell = {
        symbol = " ";
      };

      haskell = {
        symbol = " ";
      };

      haxe = {
        symbol = "⌘ ";
      };

      hg_branch = {
        symbol = " ";
      };

      java = {
        symbol = " ";
      };

      julia = {
        symbol = " ";
      };

      lua = {
        symbol = " ";
      };

      meson = {
        symbol = "喝 ";
      };

      nim = {
        symbol = " ";
      };

      nix_shell = {
        symbol = " ";
      };

      os = {
        symbols = {
          Alpine = " ";
          Amazon = " ";
          Android = " ";
          Arch = " ";
          CentOS = " ";
          Debian = " ";
          DragonFly = " ";
          Emscripten = " ";
          EndeavourOS = " ";
          Fedora = " ";
          FreeBSD = " ";
          Garuda = "﯑ ";
          Gentoo = " ";
          HardenedBSD = "ﲊ ";
          Illumos = " ";
          Linux = " ";
          Macos = " ";
          Manjaro = " ";
          Mariner = " ";
          MidnightBSD = " ";
          Mint = " ";
          NetBSD = " ";
          NixOS = " ";
          OpenBSD = " ";
          openSUSE = " ";
          OracleLinux = " ";
          Pop = " ";
          Raspbian = " ";
          Redhat = " ";
          RedHatEnterprise = " ";
          Redox = " ";
          Solus = "ﴱ ";
          SUSE = " ";
          Ubuntu = " ";
          Unknown = " ";
          Windows = " ";
        };
      };

      package = {
        symbol = " ";
      };

      pijul_channel = {
        symbol = "🪺 ";
      };

      python = {
        symbol = " ";
      };

      rlang = {
        symbol = "ﳒ ";
      };

      ruby = {
        symbol = " ";
      };

      rust = {
        symbol = " ";
      };

      scala = {
        symbol = " ";
      };

      spack = {
        symbol = "🅢 ";
      };
    };
  };
}
