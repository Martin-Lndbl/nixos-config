{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";

    # Neovim
    neovim.url = "github:Martin-Lndbl/nix-neovim-module";
    neovim.inputs.nixpkgs.follows = "nixpkgs";

    nix-colors.url = "github:Misterio77/nix-colors";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, neovim, nix-colors, ... }@inputs:
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

          # Choose any display / window - Manager
          ./nixos/display-manager/hyprland.nix
        ] ++ import ./modules/nixos;
      };
      homeConfigurations = {
        "mrtn@nix-gt" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            neovim.homeManagerModules.default
            hyprland.homeManagerModules.default
            ./home-manager/home.nix
            ./home-manager/hyprland
            {
              config.appearance.fontSize = 18;
              config.monitors.center = "DP-2";
              config.monitors.right = "DP-3";
            }
          ] ++ import ./modules/home-manager;
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

          # Choose any display / window - Manager
          ./nixos/display-manager/hyprland.nix
        ] ++ import ./modules/nixos;
      };
      homeConfigurations = {
        "mrtn@nix-nb" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            hyprland.homeManagerModules.default
            neovim.homeManagerModules.default
            nix-colors.homeManagerModules.default
            ./home-manager/home.nix
            ./home-manager/hyprland
            {
              config.appearance.wallpaper = "~/downloads/wallpaper/dodge.jpg";
              config.appearance.lockScreen = "~/downloads/wallpaper/nix.png";
              config.appearance.fontSize = 14;
              config.monitors.center = "eDP-1";
              config.monitors.right = "DP-1";
            }
          ] ++ import ./modules/home-manager;
        };
      };
    };
}
