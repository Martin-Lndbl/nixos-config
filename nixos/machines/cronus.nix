{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

let
  renameNode = name: label: {
    matches = [ { "node.name" = name; } ];
    actions.update-props = {
      "node.description" = label;
      "node.nick" = label;
    };
  };
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  networking.hostName = "cronus";

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
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "kvm-amd" ];
  boot.kernelParams = [
    "nvidia.NVreg_RestrictProfilingToAdminUsers=0"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    "rd.udev.event_timeout=10"
    "udev.event_timeout=30"
    # Steam's HTTP client threads take bus_lock traps continuously (thousands
    # per session). The kernel default only rate-limits the logging, the trap
    # itself still stalls the thread each time.
    "split_lock_detect=off"
  ];

  # asus-ec-sensors logs "Concurrent access to the ACPI EC" on every read
  # coolercontrold triggers (~60/min); nothing serializes the EC against the
  # firmware here, and mutex_path=:GLOBAL_LOCK doesn't help either. Its
  # channels (MB/VRM temps, CPU_Opt tach) are unused - CPU temp is k10temp.
  boot.blacklistedKernelModules = [ "asus_ec_sensors" ];

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

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    powerManagement.enable = true;
    gsp.enable = config.hardware.nvidia.open;
    nvidiaSettings = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  # UCM exposes every jack as a permanent node. ACP instead collapses each card
  # into one sink/source and picks the profile by jack detection, so empty jacks
  # drop out on their own and reappear when something is plugged in.
  services.pipewire.wireplumber.extraConfig."51-audio-devices" = {
    "monitor.alsa.rules" = [
      {
        matches = [ { "device.name" = "~alsa_card\\..*"; } ];
        actions.update-props."api.alsa.use-ucm" = false;
      }
      (renameNode "alsa_output.usb-Generic_USB_Audio-00.analog-stereo" "Speakers")
      (renameNode "alsa_input.usb-Generic_USB_Audio-00.analog-stereo" "Mic")
      # Really capture device 0; the card has no digital capture at all.
      (renameNode "alsa_input.usb-Generic_USB_Audio-00.iec958-stereo" "Analog In")
      (renameNode "alsa_output.usb-Kingston_HyperX_Virtual_Surround_Sound_00000000-00.analog-stereo" "HyperX")
      (renameNode "alsa_input.usb-Kingston_HyperX_Virtual_Surround_Sound_00000000-00.analog-stereo" "HyperX")
      (renameNode "alsa_input.usb-046d_HD_Pro_Webcam_C920_66AD175F-02.analog-stereo" "Webcam")
      (renameNode "alsa_output.usb-Sony_Interactive_Entertainment_DualSense_Wireless_Controller-00.analog-surround-40" "DualSense")
      # The pad has one capture path. ACP names it analog-stereo while the
      # headset jack reads connected and iec958-stereo once it does not, so both
      # spellings need the rename to keep the label stable across replug.
      (renameNode "alsa_input.usb-Sony_Interactive_Entertainment_DualSense_Wireless_Controller-00.analog-stereo" "DualSense")
      (renameNode "alsa_input.usb-Sony_Interactive_Entertainment_DualSense_Wireless_Controller-00.iec958-stereo" "DualSense")
    ];
  };

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
