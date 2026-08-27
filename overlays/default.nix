{ inputs, ... }:
{
  modifications = [ ];

  additions = final: _prev: import ../pkgs { pkgs = final; };

  nixpkgs-stable = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
