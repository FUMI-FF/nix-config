{ pkgs, ... }:

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

  home.file."Pictures/wallpapers/wallpaper.png".source =
    ../assets/wallpaper.png;

  xdg.configFile."hypr".source = ../dotfiles/hypr;
  xdg.configFile."waybar".source = ../dotfiles/waybar;
  xdg.configFile."wofi".source = ../dotfiles/wofi;
  xdg.configFile."nvim".source = ../dotfiles/nvim;
  xdg.configFile."fcitx5".source = ../dotfiles/fcitx5;

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
      rebuild = "sudo nixos-rebuild switch --flake ~/nix-config#$(hostname)";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "fumi";
        email = "expugnatiomundi@gmail.com";
      };

      alias = {
        co = "checkout";
        br = "branch";
        ci = "commit";
        st = "status";
        lg = "log --oneline --graph --decorate --all";
        amend = "commit --amend --no-edit";
      };

      init.defaultBranch = "main";
      core.editor = "nvim";
      color.ui = "auto";
    };
  };
}
