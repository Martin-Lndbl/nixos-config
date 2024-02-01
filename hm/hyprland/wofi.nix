{ pkgs, config, ... }:

{
  programs.wofi.enable = true;

  xdg.configFile."wofi/style.css".text = with config.colorscheme.palette; ''
    window { background: unset; }
    flowboxchild { outline-width: 0; }
    #outer-box {
      background-color: #${base01};
      opacity: 0.85;
      border: 1px solid #${base07};
      border-radius: 24px;
      margin: 5px 5px 10px;
      padding: 5px 5px 10px;
    }
    #input {
      background-color: #${base02};
      opacity: 0.85;
      border: none;
      border-radius: 16px;
      color: #${base07};
      margin: 5px;
    }
    #inner-box {
      background-color: #${base01};
      opacity: 0.85;
      border: none;
      border-radius: 16px;
      margin: 5px;
    }
    #scroll {
      border: none;
      margin: 0px;
    }
    #text {
      color: #${base07};
      margin: 5px;
    }
    #text:selected {
      color: #${base08};
    }
    #entry { border-radius: 16px; }
    #entry:selected {
      background-color: #${base02};
    }
  '';
}
