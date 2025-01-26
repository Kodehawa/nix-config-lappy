{
  description = "NixOS System Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nix-gaming.url = "github:fufexan/nix-gaming";
  };

  outputs =
    {
      home-manager,
      nixpkgs,
      chaotic,
      nix-gaming,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations."Napoli" =
        let
          specialArgs = inputs;
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = inputs;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.kodehawa = import ./home-manager.nix;
            }
            chaotic.nixosModules.default
            nix-gaming.nixosModules.platformOptimizations
          ];
        in
        nixpkgs.lib.nixosSystem { inherit system specialArgs modules; };

      formatter."${system}" = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;
    };
}
