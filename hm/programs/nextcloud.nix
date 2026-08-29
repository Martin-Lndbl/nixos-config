{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.nextcloud-client;

  # The account id is the [Accounts] group name in nextcloud.cfg. The keychain
  # entry holding the login token is keyed on "<dav_user>:<url>/:<id>"
  # (AbstractCredentials::keychainKey), so changing this id logs the account
  # out. It stays at the id the account got when it was first added.
  accountId = "1";
  serverUrl = "https://nextcloud.lndbl.de";
  davUser = "martin";
  # AbstractCredentials::keychainKey() keys the stored token on this value,
  # case-sensitively. It has to match dav_user exactly: the client itself
  # saves the token under the lowercase dav_user after a successful login,
  # so a differently-cased webflow_user here makes the *next* cold start's
  # keychain lookup miss and forces a fresh login every time nextcloud.cfg
  # gets rewritten (force = true below resets it on every rebuild).
  webflowUser = davUser;

  # caelestia picks its wallpapers straight out of this directory, see
  # programs.caelestia.settings.paths.wallpaperDir in ../hyprland/caelestia.nix.
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

  # Same pyroeis race as thunderbird/feishin in hm/hyprland/hyprland.nix.
  systemd.user.services.nextcloud-client.Service.ExecStartPre = [
    "${pkgs.wait-for-pyroeis}/bin/wait-for-pyroeis"
  ];

  # Mirrors what the client writes itself, so it round-trips cleanly:
  # AccountManager::saveAccountHelper produces the "<id>\..." keys and
  # FolderDefinition::save the "<id>\Folders\<alias>\..." ones.
  #
  # No credentials in here: authType=webflow means the client sends us through
  # the Nextcloud login flow in the browser whenever the keychain holds no
  # valid token for the account, and stores the token it gets back. Anything
  # the client discovers at runtime (server version, colours, window geometry)
  # is deliberately left out rather than pinned to a stale value.
  # launchOnSystemStartup is false because the systemd user service above owns
  # startup; letting the client also drop an XDG autostart entry double-launches
  # it.
  xdg.configFile."Nextcloud/nextcloud.cfg" = {
    force = true;
    text = ''
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
  };

  # The sync folder has to exist before the client will touch it.
  home.activation.nextcloudWallpaperDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p ${lib.escapeShellArg wallpaperLocal}
  '';

  # The client rewrites nextcloud.cfg at runtime, so it cannot stay a read-only
  # store symlink. Same trick as caelestiaMutableConfig: nix owns the content,
  # the copy is what the client gets to scribble on until the next activation.
  home.activation.nextcloudMutableConfig = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    f="$HOME/.config/Nextcloud/nextcloud.cfg"
    if [ -L "$f" ]; then
      target=$(readlink -f "$f")
      run rm "$f"
      run cp "$target" "$f"
      run chmod u+w "$f"
    fi
  '';

  # Left behind by an earlier launchOnSystemStartup=true; it would start a
  # second client next to the systemd user service.
  home.activation.nextcloudDropXdgAutostart = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run rm -f "$HOME/.config/autostart/Nextcloud.desktop"
  '';
}
