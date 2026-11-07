{
  description = "Martin's NixOS and Home-Manager flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    hm.url = "github:nix-community/home-manager";
    hm.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    caelestia-shell.url = "github:caelestia-dots/shell";
    caelestia-shell.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      hm,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      inherit (nixpkgs) lib;

      forAllSystems = lib.genAttrs [ "x86_64-linux" ];
      specialArgs = { inherit inputs outputs; };

      mkNixos =
        extra:
        lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ./nixos/base.nix
            ./nixos/vpn.nix
            ./nixos/printer.nix
          ]
          ++ extra
          ++ [ ./nixos/wm/hyprland.nix ];
        };

      mkHome =
        {
          system ? "x86_64-linux",
          modules,
        }:
        hm.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = specialArgs;
          inherit modules;
        };

      # Full graphical workstation: shared home + hyprland stack + option modules.
      mkDesktop =
        extra:
        mkHome {
          modules = [
            ./hm/home.nix
            ./hm/hyprland
          ]
          ++ extra
          ++ import ./modules/hm;
        };

      # Headless remote: just the one host file, which pulls in the shared base.
      mkHeadless = file: mkHome { modules = [ file ]; };

      # TUM DOS cluster nodes. Every node runs the very same home, differing
      # only in architecture. Nothing generated is allowed into the shared NFS
      # $HOME, which is what lets all of these generations be valid at the same
      # time -- see hm/users/mrtn/dos-cluster.nix.
      dosCluster = {
        irene = "x86_64-linux";
        eliza = "aarch64-linux";
        steve = "x86_64-linux";
      };

      mkCluster =
        hostname: system:
        lib.nameValuePair "mrtn@${hostname}" (mkHome {
          inherit system;
          modules = [ ./hm/users/mrtn/dos-cluster.nix ];
        });
    in
    {
      packages = forAllSystems (system: import ./pkgs { pkgs = nixpkgs.legacyPackages.${system}; });

      overlays = import ./overlays { inherit inputs; };

      nixosConfigurations = {
        nix-nb = mkNixos [
          ./nixos/container/template.nix
          ./nixos/machines/nix-nb.nix
          ./nixos/wm/autologin.nix
        ];
        cronus = mkNixos [
          ./nixos/machines/cronus.nix
          ./nixos/wm/regreet.nix
          ./nixos/guest.nix
        ];
      };

      homeConfigurations = {
        "mrtn@nix-nb" = mkDesktop [ ./hm/users/mrtn/nix-nb.nix ];
        "mrtn@cronus" = mkDesktop [
          ./hm/games
          ./hm/users/mrtn/cronus.nix
        ];

        "mrtn@pyroeis" = mkHeadless ./hm/users/mrtn/pyroeis.nix;
        "ubuntu@aws" = mkHeadless ./hm/users/ubuntu/aws.nix;

        "mrtn@eos" = mkHome {
          system = "aarch64-linux";
          modules = [ ./hm/users/mrtn/eos.nix ];
        };
      }
      // lib.mapAttrs' mkCluster dosCluster;
    };
}
