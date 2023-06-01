{ pkgs }:

{
  enable = true;
  lfs.enable = true;
  userName = "martin-lndbl-GTL";
  userEmail = "lblsolutions@outlook.de";

  extraConfig.safe.directory = [
		"/D/docs/03_sem"
  ];
}
