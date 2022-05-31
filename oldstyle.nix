let
  pkgs = import (fetchTarball https://github.com/NixOS/nixpkgs/archive/838eefb4f93f2306d4614aafb9b2375f315d917f.tar.gz) { };

  pypiDataRev = "b141b074f7afa044035880cffa32bb7fa4708264";

  mach-nix = import (pkgs.fetchFromGitHub {
    owner = "DavHau";
    repo = "mach-nix";
    rev = "26f06e415a74dc10727cf9c9a40c83b635238900";
    hash = "sha256:0c9w1gsw7k6agb7z42z87qswhrgs2762xh9lw5800rb88p1js82h";
  }) { inherit pypiDataRev; python = "python39"; };

  pycddl = pkgs.python39.pkgs.callPackage ./pycddl.nix { };
in
mach-nix.mkPython {
  requirements = ''
    pycddl
  '';
  providers.pycddl = "nixpkgs";
  overridesPre = [
    (
      self: super: {
        inherit pycddl;
      }
    )
  ];
 }
