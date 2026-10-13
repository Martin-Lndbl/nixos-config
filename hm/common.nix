{ outputs, ... }:
{
  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config.allowUnfree = true;
  };

  home.sessionVariables.CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1";
}
