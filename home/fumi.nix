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

  # ---- hyprpaper 設定 ----
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    wallpaper {
      monitor = ,
      path = ${wallpaper}
    }
  '';
  xdg.configFile."hypr/hyprland.conf".source =
    ../dotfiles/hypr/hyprland.conf;

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
}
