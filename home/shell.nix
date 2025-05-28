{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    autosuggestion.enable = true;

    history = {
      ignoreAllDups = true;
      ignoreSpace = true;
      append = true;
      size = 5000;
      share = true;
    };

    initContent = ''
      setopt hist_find_no_dups
      setopt hist_save_no_dups

      source ${pkgs.zsh-fzf-history-search}/share/zsh-fzf-history-search/zsh-fzf-history-search.plugin.zsh
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh

      export PATH=~/.npm-global/bin:$PATH
    '';
  };
}
