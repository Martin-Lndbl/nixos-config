{ inputs, ... }:
{
  # Packages defined in ./pkgs, exposed as normal attributes of pkgs.
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # Tweaks to packages that already exist in nixpkgs.
  modifications = _final: _prev: { };

  # `pkgs.stable.<name>` for anything that needs the last stable release.
  nixpkgs-stable = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };
}
