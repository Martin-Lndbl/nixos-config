{ ... }:
{
  # Packages defined in ./pkgs, exposed as normal attributes of pkgs.
  additions = final: _prev: import ../pkgs { pkgs = final; };
}
