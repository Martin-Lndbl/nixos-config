{
  description = "Martin's NixOS and Home-Manager flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-24.11";

    # Home manager
    hm.url = "github:nix-community/home-manager";
    hm.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    envfs.url = "github:Mic92/envfs";
    envfs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      hm,
      stylix,
      envfs,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" ];

    in
    rec {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./pkgs { inherit pkgs; }
      );
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./shell.nix { inherit pkgs; }
      );

      overlays = import ./overlays { inherit inputs; };

      # -----------------------------------------------
      #                   nix-gt
      # -----------------------------------------------
      nixosConfigurations.nix-gt = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
        };
        modules = [
          envfs.nixosModules.envfs
          ./nixos/base.nix
          ./nixos/wireguard.nix
          ./nixos/printer.nix
          ./nixos/machines/nix-gt.nix
          ./nixos/wm/hyprland.nix
        ]
        ++ import ./modules/nixos;
      };
      homeConfigurations = {
        "mrtn@nix-gt" = hm.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
          };
          modules = [
            stylix.homeModules.stylix
            ./hm/home.nix
            ./hm/hyprland
            ./hm/users/mrtn/nix-gt.nix
          ]
          ++ import ./modules/hm;
        };
      };

      # -----------------------------------------------
      #                   nix-nb
      # -----------------------------------------------
      nixosConfigurations.nix-nb = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
        };
        modules = [
          envfs.nixosModules.envfs
          ./nixos/base.nix
          ./nixos/wireguard.nix
          ./nixos/printer.nix
          ./nixos/container/template.nix
          ./nixos/machines/nix-nb.nix
          ./nixos/wm/gnome.nix
        ]
        ++ import ./modules/nixos;
      };
      homeConfigurations = {
        "mrtn@nix-nb" = hm.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
          };
          modules = [
            stylix.homeModules.stylix
            ./hm/home.nix
            ./hm/hyprland
            ./hm/users/mrtn/nix-nb.nix
          ]
          ++ import ./modules/hm;
        };
      };

      # -----------------------------------------------
      #                   irene
      # -----------------------------------------------
      homeConfigurations = {
        "martinLi@irene" = hm.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./hm/users/martinLi/irene.nix
          ];
        };
      };

      # -----------------------------------------------
      #                   eos
      # -----------------------------------------------
      homeConfigurations = {
        "mrtn@eos" = hm.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./hm/users/mrtn/eos.nix
          ];
        };
      };

      # -----------------------------------------------
      #                   cronus
      # -----------------------------------------------
      nixosConfigurations.cronus = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
        };
        modules = [
          envfs.nixosModules.envfs
          ./nixos/base.nix
          ./nixos/wireguard.nix
          ./nixos/printer.nix
          ./nixos/machines/cronus.nix
          ./nixos/wm/gnome.nix
        ]
        ++ import ./modules/nixos;
      };
      homeConfigurations = {
        "mrtn@cronus" = hm.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
          };
          modules = [
            stylix.homeModules.stylix
            ./hm/home.nix
            ./hm/hyprland
            ./hm/users/mrtn/cronus.nix
          ]
          ++ import ./modules/hm;
        };
      };
    };
}
