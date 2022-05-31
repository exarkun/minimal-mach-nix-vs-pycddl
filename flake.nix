{
  description = "Tahoe-LAFS, free and open decentralized data store";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs?rev=838eefb4f93f2306d4614aafb9b2375f315d917f";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.mach-nix = {
    flake = false;
    url = "github:DavHau/mach-nix?rev=26f06e415a74dc10727cf9c9a40c83b635238900";
  };
  inputs.pypi-deps-db = {
    flake = false;
    url = "github:DavHau/pypi-deps-db?rev=95ce01d992e28ef713df86e2bebe505a51c59244";
  };

  outputs = { self, nixpkgs, flake-utils, mach-nix, pypi-deps-db }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      version = builtins.substring 0 8 self.lastModifiedDate;

      packages = {
        default = pkgs.callPackage ./default.nix {
            mach-nix = pkgs.callPackage mach-nix {
              inherit pypi-deps-db;
              python = "python38";
            };
        };
      };
    });
}
