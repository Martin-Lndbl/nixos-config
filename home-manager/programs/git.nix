{ pkgs, ... }:

{
  programs.git = {

    enable = true;
    lfs.enable = true;
    userName = "martin-lndbl-GTL";
    userEmail = "lblsolutions@outlook.de";
    extraConfig.safe.directory = [
      "/D/docs/03_sem"
      "/D/docs/04_sem"
      "/D/docs/uni/ASP/task4-concurrency-Martin-Lndbl"
    ];
  };
}
