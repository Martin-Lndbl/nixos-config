{ inputs, outputs, ... }: with inputs; {
  nix-nb = nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs outputs; };
    modules = [
      ./base.nix
      ./machines/nix-nb.nix

      # Choose any display / window - Manager
      ./display-manager/hyprland.nix
    ];
  };

  nix-gt = nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs outputs; };
    modules = [
      ./base.nix
      ./machines/nix-gt.nix

      # Choose any display / window - Manager
      ./display-manager/i3.nix
    ];
  };

}
