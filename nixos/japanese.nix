{ pkgs, ... }:

{
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
    ];
  };

  fonts.packages = with pkgs; [
    noto-fonts-cjk
  ];

  environment.sessionVariables.GLFW_IM_MODULE = "ibus";
}
