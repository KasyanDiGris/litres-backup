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
      version = "0.0.0";

      src = ./.;
      vendorHash = "sha256-5LO+Mq2dOwXYmciLkvxDUg6L5n0kHVUWI6rq9v3Gvvs=";
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
