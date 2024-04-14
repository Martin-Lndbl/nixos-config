{ inputs, ... }:
{
  modifications = [
    # (import ./bash.nix)
    (import ./code.nix)
    (import ./discord.nix)
    (import ./trilium.nix)
    (import ./waybar.nix)
  ];

  additions = final: _prev: import ../pkgs { pkgs = final; };

  nixpkgs-stable = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
