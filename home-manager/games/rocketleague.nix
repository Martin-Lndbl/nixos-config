{ pkgs, inputs, ... }:

{
  home.packages = with inputs.nix-gaming.packages.${pkgs.system}; [
    # rocket-league
    (rocket-league.override {
      location = "$HOME/.local/share/legendary/rocket-league";
    }
    )
  ];
}
