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
  webflowUser = "Martin";
  keychainUser = "${davUser}:${serverUrl}/:${accountId}";

  # gnome-keyring's Secret Service item registration lags a couple of seconds
  # behind PAM unlocking the collection at login (a duplicate daemon spawns
  # and re-registers items -- see "asked to register item ... already
  # registered" in the journal), so the client can start before its stored
  # token is actually readable and fall back to a fresh webflow login.
  waitForSecret = pkgs.writeShellApplication {
    name = "wait-for-nextcloud-secret";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.libsecret
    ];
    text = ''
      have_secret() {
        timeout 2 secret-tool lookup server Nextcloud user "${keychainUser}" type plaintext >/dev/null 2>&1
      }

      waited=0
      while ! have_secret && [ "$waited" -lt 15 ]; do
        sleep 1
        waited=$((waited + 1))
      done
    '';
  };

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

  systemd.user.services.nextcloud-client.Service.ExecStartPre = [
    # Same pyroeis race as thunderbird/feishin in hm/hyprland/hyprland.nix.
    "${pkgs.wait-for-pyroeis}/bin/wait-for-pyroeis"
    "${waitForSecret}/bin/wait-for-nextcloud-secret"
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
