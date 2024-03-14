# HomeManager configuration
This directory contains my [HomeManager](https://github.com/nix-community/home-manager) config, supported by some self-written modules in `../modules/hm`.

> [!NOTE]
> This is a highly opinionated solution for a generic problem and might not be the right approach for your use case.

## Structure
Distictions between host and user config happens in `../flake.nix`. There user- and device-specific modules containing settings for window-manager, wallpaper, fontsize, etc. can be pieced together.

* `colorschemes` containing custom colorschemes not part of [nix-colors](https://github.com/Misterio77/nix-colors) flake-input.
* `games` for game-specific config.
* `hyprland` can be selected as window-manager if `../nixos/wm/hyprland.nix` is active in the nixos config.
* `i3` can be selectd as together with `../nixos/wm/i3.nix` if you want to stick with x11.
* `programs` contains programs for independent of the used display protocol, user or host.
* `users` for storing user-specific options, including secrets handled by [sops-nix](https://github.com/Mic92/sops-nix)

## Dependencies
You are welcome to copy parts of my config to build your own. Be aware, however, that while it is designed to work out-of-the-box, by copying parts of the config, you might need to look into the following dependencies:
* `nix-colors` is a HomeManager module designed to help with theming. A lot of programs rely on `config.colorscheme` to be present.
* `$XDG_RUNTIME_DIR/secrets/` is the directory `sops-nix` puts api-keys, etc. Make sure to have the right keys at the right place or change the config accordingly.
* Make sure to also check out my modules
