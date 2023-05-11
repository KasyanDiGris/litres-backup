{
  inputs = {
    nixpkgs.url = github:Nixos/nixpkgs/release-22.11;
  };

  outputs = { self, nixpkgs }: 
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    litres-backup-package = pkgs.buildGoModule {
      pname = "litres-backup";
      version = "git";

      src = ./.;
      vendorHash = "sha256-IyM5+xPrkORQe40FB357a4XkLDr4HABbuvx9puHDHa8=";
    };
  in
  {
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [
        pkgs.go
        pkgs.gopls
      ];
    };

    packages."x86_64-linux".default = litres-backup-package;

    nixosModules = {
      default = {...}: {
        environment.systemPackages = [
          litres-backup-package
        ];
      };
    };
  };
}
