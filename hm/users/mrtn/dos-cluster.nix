# Shared setup for the TUM DOS cluster nodes (irene, eliza, steve).
#
# $HOME is a small NFS share mounted on *every* node, while / -- and with it
# both /nix and /scratch -- is node-local. Home-manager writes symlinks into
# the store, so any generated file left in $HOME is valid on exactly the node
# that built it and dangling on all the others; that is what used to make the
# nodes take turns owning the dotfiles. To keep every node's generation valid
# at the same time, nothing generated may live in $HOME, so the XDG
# directories and the shell dotfiles are all redirected into /scratch. No
# hostname is needed in those paths: /scratch is node-local already, and
# keeping the hostname out is what lets the same-architecture nodes build
# byte-identical generations.
#
# What stays in the shared $HOME is a handful of hand-written stubs. Their
# contents are node-independent, so they are written once, in one place, and
# then serve every node forever:
#
#   ~/.bashrc                  sources /scratch/mrtn/.bashrc
#   ~/.bash_profile            sources /scratch/mrtn/.bash_profile
#   ~/.profile                 sources /scratch/mrtn/.profile
#   ~/.ssh/config              Include /scratch/mrtn/.ssh/config
#   ~/scratch              ->  /scratch
#   ~/.config/systemd      ->  /scratch/mrtn/.config/systemd
#   ~/.config/environment.d -> /scratch/mrtn/.config/environment.d
#   ~/.local               ->  /scratch/mrtn/.local
#
# The symlinks are not conveniences:
#
#  * ~/scratch -- home-manager has no prefix match for /scratch against
#    home.homeDirectory, so it strips the leading slash and writes every path
#    below *through* $HOME. Without this symlink it would create a real
#    ~/scratch on the quota'd NFS home.
#  * ~/.config/systemd, ~/.config/environment.d -- `systemd --user` builds its
#    unit search path at startup and does not see XDG_CONFIG_HOME
#    (`systemd-analyze --user unit-paths` lists ~/.config/systemd/user
#    verbatim), so the units have to be reachable under the literal path.
#  * ~/.local -- for the tools that hardcode it rather than reading
#    XDG_STATE_HOME / XDG_DATA_HOME.
#
# The three shell stubs guard their source with `if [ -r ... ]`, so a node that
# has not been switched yet -- or one whose /scratch has been wiped, this being
# scratch space -- falls back to a plain shell instead of erroring on every
# login. ssh ignores a missing Include target by itself.
#
# Bootstrapping a node that has never been switched -- the activation script
# picks the generation profile out of the environment, so the directory has to
# exist before the first run:
#
#   mkdir -p /scratch/mrtn/.local/state/nix/profiles
#   XDG_STATE_HOME=/scratch/mrtn/.local/state \
#     nix run github:nix-community/home-manager -- \
#       switch --flake ~/.config/nixos-config

{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Node-local, so every node gets its own copy of all of this without the
  # configuration having to know which node it is on.
  scratch = "/scratch/${config.home.username}";
in
{
  imports = [ ../headless.nix ];

  home.packages = with pkgs; [
    btop
    mdcat
    claude-code
  ];

  services.ssh-agent.enable = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."*".addKeysToAgent = "yes";
  };

  xdg = {
    enable = true;
    userDirs.enable = false;
    userDirs.createDirectories = false;
    cacheHome = "${scratch}/.cache";
    configHome = "${scratch}/.config";
    dataHome = "${scratch}/.local/share";
    stateHome = "${scratch}/.local/state";
  };

  # The files with no XDG location to be moved to; $HOME keeps the stubs
  # listed above in their place.
  home.file =
    lib.genAttrs
      [
        ".bashrc"
        ".bash_profile"
        ".profile"
        ".ssh/config"
      ]
      (name: {
        target = "${scratch}/${name}";
      });
}
