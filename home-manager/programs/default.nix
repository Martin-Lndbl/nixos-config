{ config, pkgs, ... }:
{
  home-manager.enable = true;

  neovim.baseConfiguration = {
    enable = true;
    colorscheme = "spacecamp_transparent";
  };

  git = import ./git.nix {
    inherit pkgs;
  };

  ssh = import ./ssh.nix {
	inherit pkgs;
  };

  bash = import ./bash {
    inherit pkgs;
  };

  vscode = import ./vscode.nix {
	inherit pkgs;
  };

  firefox = import ./firefox.nix {
	inherit pkgs;
  };

  alacritty = import ./alacritty.nix {
	inherit pkgs;
  };

  swaylock = import ./swaylock.nix {
	inherit pkgs;
  };

  waybar = import ./waybar {
    inherit pkgs;
  };

   direnv.enable = true;
}
