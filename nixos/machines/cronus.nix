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

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      AllowUsers = null;
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "thunderbolt"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

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

  console.keyMap = "de";

  system.stateVersion = lib.mkForce "24.11";

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    powerManagement.enable = false;
    gsp.enable = config.hardware.nvidia.open;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "575.57.08";
      sha256_64bit = "sha256-KqcB2sGAp7IKbleMzNkB3tjUTlfWBYDwj50o3R//xvI=";
      openSha256 = "sha256-DOJw73sjhQoy+5R0GHGnUddE6xaXb/z/Ihq3BKBf+lg=";
      settingsSha256 = "sha256-AIeeDXFEo9VEKCgXnY3QvrW5iWZeIVg4LBCeRtMs5Io=";
      persistencedSha256 = "";
      usePersistenced = true;
    };
  };

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
  };

  boot = {
    kernelParams = [
      # To allow cooler control
      "nvidia.NVreg_RestrictProfilingToAdminUsers=0"
      "nvidia.NVreg_UsePageAttributeTable=1"
      "nvidia_modeset.disable_vrr_memclk_switch=1"
      # for suspend/wakeup issues, recommended by https://wiki.hyprland.org/Nvidia/
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      # for wayland issues, but breaks tty
      # see https://github.com/NixOS/nixpkgs/issues/343774#issuecomment-2370293678
      # "initcall_blacklist=simpledrm_platform_driver_init"
    ];
  };

  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    egl-wayland
    nvidia-system-monitor-qt
  ];

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

  programs.coolercontrol.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # boot.initrd.systemd.enable = true;
  # virtualisation.xen.enable = true;
}
