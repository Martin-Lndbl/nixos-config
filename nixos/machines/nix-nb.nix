{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

let
  hideNode = name: {
    matches = [ { "node.name" = name; } ];
    actions.update-props."node.disabled" = true;
  };

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

  networking.hostName = "nix-nb";

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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "vmd"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/0d6b3afe-378c-40fe-811f-6bb7a68fa247";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C89E-0889";
    fsType = "vfat";
  };

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16 * 1024;
  }];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.sensor.iio.enable = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.upower.enable = true;

  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    intel-vaapi-driver
    libvdpau-va-gl
  ];
  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

  boot.extraModprobeConfig = lib.mkMerge [
    # idle audio card after one second
    "options snd_hda_intel power_save=1"
    # enable wifi power saving (keep uapsd off to maintain low latencies)
    "options iwlwifi power_save=1 uapsd_disable=1"
  ];
  services.thermald.enable = true;

  services.pipewire.wireplumber.extraConfig."51-audio-devices" = {
    "monitor.alsa.rules" = [
      (renameNode "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Speaker__sink" "Speakers")
      (renameNode "alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Mic1__source" "Mic")
      (hideNode "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__HDMI1__sink")
      (hideNode "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__HDMI2__sink")
      (hideNode "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__HDMI3__sink")
      (hideNode "alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Mic2__source")
    ];
  };

  services.udev.extraRules = lib.mkMerge [
    # autosuspend USB devices
    ''ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="auto"''
    # autosuspend PCI devices
    ''ACTION=="add", SUBSYSTEM=="pci", TEST=="power/control", ATTR{power/control}="auto"''
    # disable Ethernet Wake-on-LAN
    ''ACTION=="add", SUBSYSTEM=="net", NAME=="enp*", RUN+="${pkgs.ethtool}/sbin/ethtool -s $name wol d"''
  ];
}
