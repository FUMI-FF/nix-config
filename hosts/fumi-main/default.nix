{ hostName, pkgs, ... }:

{
  networking.hostName = hostName;

  boot.kernelParams = [
    "pcie_aspm=off"
  ];

  services.fwupd.enable = true;

  environment.systemPackages = with pkgs; [
    fwupd
    pciutils
    usbutils
  ];
}
