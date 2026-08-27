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

      # Every machine gets the same base and window-manager stack; `extra` is the
      # hardware/role remainder. Order matters: list-valued options (systemPackages
      # and friends) merge in module order, so keep `extra` in the middle.
      mkNixos =
        extra:
        lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ./nixos/base.nix
            ./nixos/wireguard.nix
            ./nixos/printer.nix
          ]
          ++ extra
          ++ [
            ./nixos/wm/hyprland.nix
            ./nixos/wm/gnome.nix
            ./nixos/wm/sddm.nix
          ]
          ++ import ./modules/nixos;
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
      mkDesktop = extra: mkHome {
        modules = [
          ./hm/home.nix
          ./hm/hyprland
        ]
        ++ extra
        ++ import ./modules/hm;
      };

      # Headless remote: just the one host file, which pulls in the shared base.
      mkHeadless = file: mkHome { modules = [ file ]; };
    in
    {
      packages = forAllSystems (system: import ./pkgs { pkgs = nixpkgs.legacyPackages.${system}; });

      overlays = import ./overlays { inherit inputs; };

      nixosConfigurations = {
        nix-nb = mkNixos [
          ./nixos/container/template.nix
          ./nixos/machines/nix-nb.nix
        ];
        cronus = mkNixos [ ./nixos/machines/cronus.nix ];
      };

      homeConfigurations = {
        "mrtn@nix-nb" = mkDesktop [ ./hm/users/mrtn/nix-nb.nix ];
        "mrtn@cronus" = mkDesktop [
          ./hm/games
          ./hm/users/mrtn/cronus.nix
        ];

        "mrtn@irene" = mkHeadless ./hm/users/mrtn/irene.nix;
        "mrtn@eliza" = mkHeadless ./hm/users/mrtn/eliza.nix;
        "mrtn@pyroeis" = mkHeadless ./hm/users/mrtn/pyroeis.nix;
        "ubuntu@aws" = mkHeadless ./hm/users/ubuntu/aws.nix;

        "mrtn@eos" = mkHome {
          system = "aarch64-linux";
          modules = [ ./hm/users/mrtn/eos.nix ];
        };
      };
    };
}
