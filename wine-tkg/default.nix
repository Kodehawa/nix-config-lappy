{
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages = [
    inputs.nix-gaming.packages.${pkgs.system}.wine-tkg
  ];
}
