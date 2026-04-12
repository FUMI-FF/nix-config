{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "fumi-main";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Tokyo";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ja_JP.UTF-8";
    LC_IDENTIFICATION = "ja_JP.UTF-8";
    LC_MEASUREMENT = "ja_JP.UTF-8";
    LC_MONETARY = "ja_JP.UTF-8";
    LC_NAME = "ja_JP.UTF-8";
    LC_NUMERIC = "ja_JP.UTF-8";
    LC_PAPER = "ja_JP.UTF-8";
    LC_TELEPHONE = "ja_JP.UTF-8";
    LC_TIME = "ja_JP.UTF-8";
  };

  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      fcitx5-skk
      fcitx5-gtk
      libsForQt5.fcitx5-qt
    ];
  };

  environment.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    INPUT_METHOD = "fcitx";
  };

  users.users.fumi = {
    isNormalUser = true;
    description = "fumi";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  programs.zsh.enable = true;
  programs.hyprland.enable = true;

  # GDM で Hyprland に入る。GNOME 本体は入れない。
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = false;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "ctrl:nocaps";
  };

  # bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    wireplumber.enable = true;
  };

  # A2DP / AAC / LDACなどのコーデック対応
  services.pipewire.wireplumber.extraConfig = {
    "bluez-monitor.conf" = {
      "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-msbc" = true;
        "bluez5.enable-hw-volume" = true;
      };
    };
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    font-awesome
    hackgen-nf-font
    nerd-fonts.jetbrains-mono
  ];

  environment.systemPackages = with pkgs; [
    git
    hyprpaper
    grim
    slurp
    ghostty
    pavucontrol
    bat
    ripgrep
    fd
    bottom
    neofetch
  ];

  system.stateVersion = "25.11";
}
