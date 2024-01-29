{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    fallbackpkgs.url = "github:nixos/nixpkgs/85f1ba3e51676fa8cc604a3d863d729026a6b8eb";

    # Home manager
    hm.url = "github:nix-community/home-manager";
    hm.inputs.nixpkgs.follows = "nixpkgs";

    # Nix Colors
    nix-colors.url = "github:Martin-Lndbl/nix-colors";
  };

  outputs = { self, nixpkgs, hm, neovim, nix-colors, ... }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
      ];
    in

    rec {
      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./pkgs { inherit pkgs; }
      );
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./shell.nix { inherit pkgs; }
      );

      overlays = import ./overlays { inherit inputs; };

      # -----------------------------------------------
      #                   nix-gt 
      # -----------------------------------------------
      nixosConfigurations.nix-gt = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };
        modules = [
          ./nixos/base.nix
          ./nixos/machines/nix-gt.nix
          ./nixos/wm/hyprland.nix
        ] ++ import ./modules/nixos;
      };
      homeConfigurations = {
        "mrtn@nix-gt" = hm.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            neovim.homeManagerModules.default
            nix-colors.homeManagerModules.default
            ./hm/home.nix
            ./hm/hyprland
            ./hm/users/mrtn/nix-gt.nix
          ] ++ import ./modules/hm;
        };
      };

      # -----------------------------------------------
      #                   nix-nb 
      # -----------------------------------------------
      nixosConfigurations.nix-nb = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };
        modules = [
          ./nixos/base.nix
          ./nixos/wireguard.nix
          ./nixos/machines/nix-nb.nix
          ./nixos/wm/hyprland.nix
        ] ++ import ./modules/nixos;
      };
      homeConfigurations = {
        "mrtn@nix-nb" = hm.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            neovim.homeManagerModules.default
            nix-colors.homeManagerModules.default
            ./hm/home.nix
            ./hm/hyprland
            ./hm/users/mrtn/nix-nb.nix
          ] ++ import ./modules/hm;
        };
      };
    };
}
