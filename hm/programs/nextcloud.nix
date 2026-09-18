{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.nextcloud-client;

  accountId = "1";
  serverUrl = "https://nextcloud.lndbl.de";
  davUser = "martin";
  webflowUser = davUser;

  wallpaperAlias = "wallpaper";
  wallpaperLocal = "${config.xdg.userDirs.pictures}/wallpaper";
  wallpaperRemote = "/Wallpapers";

  account = "${accountId}\\";
  folder = "${account}Folders\\${wallpaperAlias}\\";
in
{
  home.packages = [ cfg.package ];

  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

  systemd.user.services.nextcloud-client.Service.ExecStartPre = [
    "${pkgs.wait-for-pyroeis}/bin/wait-for-pyroeis"
  ];

  # The client rewrites this on every settings change, see modules/hm.
  xdg.mutableConfigFiles = [ "Nextcloud/nextcloud.cfg" ];

  xdg.configFile."Nextcloud/nextcloud.cfg".text = ''
    [General]
    clientVersion=${cfg.package.version}
    confirmExternalStorage=true
    desktopEnterpriseChannel=stable
    isVfsEnabled=false
    launchOnSystemStartup=false
    monoIcons=false
    moveToTrash=false
    newBigFolderSizeLimit=500
    notifyExistingFoldersOverLimit=false
    optionalServerNotifications=true
    promptDeleteAllFiles=false
    showCallNotifications=true
    showChatNotifications=true
    showQuotaWarningNotifications=true
    stopSyncingExistingFoldersOverLimit=false
    updateChannel=stable
    useNewBigFolderSizeLimit=true

    [Accounts]
    version=13
    ${account}version=13
    ${account}authType=webflow
    ${account}url=${serverUrl}
    ${account}dav_user=${davUser}
    ${account}webflow_user=${webflowUser}
    ${folder}localPath=${wallpaperLocal}/
    ${folder}targetPath=${wallpaperRemote}
    ${folder}journalPath=.sync_${wallpaperAlias}.db
    ${folder}paused=false
    ${folder}ignoreHiddenFiles=true
    ${folder}virtualFilesMode=off
    ${folder}version=2

    [Nextcloud]
    autoUpdateCheck=true
  '';

  home.activation.nextcloudWallpaperDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p ${lib.escapeShellArg wallpaperLocal}
  '';

  home.activation.nextcloudDropXdgAutostart = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run rm -f "$HOME/.config/autostart/Nextcloud.desktop"
  '';
}
