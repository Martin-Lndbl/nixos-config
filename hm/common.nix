{ outputs, ... }:
{
  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.nixpkgs-stable
    ]
    ++ outputs.overlays.modifications;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };
}
