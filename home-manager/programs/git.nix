{ pkgs, ... }:

{
  programs.git = {

    enable = true;
    lfs.enable = true;
    userName = "martin-lndbl-GTL";
    userEmail = "lblsolutions@outlook.de";
    extraConfig.safe.directory = [
      "/D/docs/uni/03_sem"
      "/D/docs/uni/04_sem"
      "/D/docs/uni/ASP/task4-concurrency-Martin-Lndbl"
      "/D/docs/uni/ASP/task5-memory-Martin-Lndbl"
      "/D/docs/uni/ASP/task6-sockets-Martin-Lndbl"
      "/D/docs/uni/ASP/task7-performance-Martin-Lndbl"
    ];
  };
}
