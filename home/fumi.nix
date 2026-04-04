{ pkgs, ... }:
{
  home.username = "fumi";
  home.homeDirectory = "/home/fumi";
  home.stateVersion = "25.11";

  # starship
  programs.starship.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      ls = "eza --icons";
      ll = "eza -al --icons";
      tree = "eza --tree --icons";
      copy = "wl-copy";
      vim = "nvim";

      dotfiles = "git --git-dir=$HOME/.cfg/ --work-tree=$HOME";
    };
  };


  # fzf
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    neovim
    firefox
    wofi
    waybar
    eza
    fzf
    starship
    wl-clipboard
  ];

  # dotfiles
  xdg.configFile."hypr".source = ../dotfiles/hypr;
  xdg.configFile."waybar".source = ../dotfiles/waybar;
  xdg.configFile."wofi".source = ../dotfiles/wofi;
  xdg.configFile."nvim".source = ../dotfiles/nvim;
  xdg.configFile."fcitx5".source = ../dotfiles/fcitx5;
}
