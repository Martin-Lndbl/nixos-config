{ inputs, ... }:
{
  modifications = [
    # (import ./bash.nix)
    (import ./code.nix)
    (import ./discord.nix)
    (import ./waybar.nix)
  ];

  additions = final: _prev: import ../pkgs { pkgs = final; };

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
