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

  folders = {
    wallpaper = {
      local = "${config.xdg.userDirs.pictures}/wallpaper";
      remote = "/Wallpapers";
    };
    garmin-music = {
      local = "${config.xdg.userDirs.music}/garmin";
      remote = "/Fitness/Garmin/Music";
    };
  };

  account = "${accountId}\\";

  folderConfig = lib.concatStrings (
    lib.mapAttrsToList (
      alias: f:
      let
        folder = "${account}Folders\\${alias}\\";
      in
      ''
        ${folder}localPath=${f.local}/
        ${folder}targetPath=${f.remote}
        ${folder}journalPath=.sync_${alias}.db
        ${folder}paused=false
        ${folder}ignoreHiddenFiles=true
        ${folder}virtualFilesMode=off
        ${folder}version=2
      ''
    ) folders
  );
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
    ${folderConfig}

    [Nextcloud]
    autoUpdateCheck=true
  '';

  home.activation.nextcloudSyncDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    lib.concatMapStrings (f: ''
      run mkdir -p ${lib.escapeShellArg f.local}
    '') (lib.attrValues folders)
  );

  home.activation.nextcloudDropXdgAutostart = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run rm -f "$HOME/.config/autostart/Nextcloud.desktop"
  '';
}
