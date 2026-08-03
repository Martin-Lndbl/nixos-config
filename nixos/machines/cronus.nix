{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  networking.hostName = "cronus";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.includeDefaultModules = false;
  boot.initrd.availableKernelModules = lib.mkForce [
    "nvme"
    "ahci"
    "sd_mod"
    "ext4"
  ];
  boot.initrd.systemd.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "kvm-amd" ];

  boot.kernelParams = [
    "nvidia.NVreg_RestrictProfilingToAdminUsers=0"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
  ];

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  system.stateVersion = lib.mkForce "24.11";

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    powerManagement.enable = true;
    gsp.enable = config.hardware.nvidia.open;
    nvidiaSettings = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  services.displayManager.sddm.wayland.compositor = "weston";

  programs.gamemode.enable = true;
  programs.coolercontrol.enable = true;
  services.hardware.openrgb.enable = true;

  environment.variables = {
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/3663bb6e-d508-409d-8fc3-2f245326fc0d";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F5B6-CD9C";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/d06f153e-f6ed-4c36-aabc-bde51625877e"; }
  ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
