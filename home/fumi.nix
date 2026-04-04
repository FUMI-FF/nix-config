{ pkgs, ... }:
let
  wallpaper = "/home/fumi/Pictures/wallpapers/pixel_town.jpg";
in
{
  home.username = "fumi";
  home.homeDirectory = "/home/fumi";
  home.stateVersion = "25.11";

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

  # ---- wallpaper 配置 ----
  home.file."Pictures/wallpapers/pixel_town.jpg".source =
    ../assets/pixel_town.jpg;

  xdg.configFile."hypr".source = ../dotfiles/hypr;
  xdg.configFile."waybar".source = ../dotfiles/waybar;
  xdg.configFile."wofi".source = ../dotfiles/wofi;
  xdg.configFile."nvim".source = ../dotfiles/nvim;
  xdg.configFile."fcitx5".source = ../dotfiles/fcitx5;

  # programs 
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
    };
  };


  # fzf
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;

    userName = "fumi";
    userEmail = "expugnatiomundi@gmail.com";

    aliases = {
      co = "checkout";
      br = "branch";
      ci = "commit";
      st = "status";

      lg = "log --oneline --graph --decorate --all";
      amend = "commit --amend --no-edit";
    };
  };
}
