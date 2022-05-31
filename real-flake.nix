let
  # The Python version used by the default package
  defaultPythonVersion = "python37";

  # The Python versions for which packages are available
  supportedPythonVersions = ["python37" "python38" "python39" "python310" ];

  # Construct the name of the package for a given version of Python
  # str -> str
  packageName = pythonVersion: "tahoe-lafs-${pythonVersion}";

  # Add a default package to a package set, pointing at one of the other
  # packages.
  # str -> set -> set
  addDefault = defaultVersion: packages: packages // {
    # The default package for 'nix build'. This makes sense if the flake
    # provides only one package or there is a clear "main" package.
    default = packages.${packageName defaultVersion};
  };

  # Create packages for all of the given Python versions.  The mach-nix
  # derivation to use to build the packages is the 2nd argument.
  #
  # nixpkgs -> derivation -> [str] -> set
  packageForVersions = pkgs: mach-nix-src: pythonVersions: builtins.foldl' (
    accum: pyVersion: accum // {
      ${packageName pyVersion} = pkgs.callPackage ./default.nix {
        mach-nix = pkgs.callPackage mach-nix-src { python = pyVersion; };
      };
    }) {} pythonVersions;
in
{
  description = "Tahoe-LAFS, free and open decentralized data store";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs?rev=838eefb4f93f2306d4614aafb9b2375f315d917f";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.mach-nix.url = "github:DavHau/mach-nix";

  outputs = { self, nixpkgs, flake-utils, mach-nix }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      version = builtins.substring 0 8 self.lastModifiedDate;

      packages = addDefault defaultPythonVersion (
        packageForVersions pkgs mach-nix supportedPythonVersions
      );

      apps = {
        default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/tahoe";
        };
      };

      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          python37
          python38
          python39
          python310
        ];
      };
    });
}
