{
  pkgs,
  username,
  homeDirectory ? "/home/${username}",
  gitName ? username,
  gitEmail ? "",
  ...
}:

{
  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    neovim
    firefox
    vivaldi
    bottles
    wofi
    waybar
    eza
    fzf
    starship
    wl-clipboard
    nodejs
  ];

  home.file."Pictures/wallpapers/wallpaper.png".source = ../assets/wallpaper.png;

  xdg.configFile."hypr".source = pkgs.runCommand "hypr-config" { } ''
    mkdir -p "$out"
    ln -s ${../dotfiles/hypr/hyprland.conf} "$out/hyprland.conf"
    cat > "$out/hyprpaper.conf" <<EOF
    wallpaper {
      monitor =
      path = ${homeDirectory}/Pictures/wallpapers/wallpaper.png
      fit_mode = cover
    }
    EOF
  '';
  xdg.configFile."waybar".source = ../dotfiles/waybar;
  xdg.configFile."wofi".source = ../dotfiles/wofi;
  xdg.configFile."nvim".source = ../dotfiles/nvim;
  xdg.configFile."fcitx5".source = ../dotfiles/fcitx5;

  programs.starship.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    initContent = ''
      export PATH="$HOME/.npm-global/bin:$PATH"
    '';

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
        name = gitName;
        email = gitEmail;
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
