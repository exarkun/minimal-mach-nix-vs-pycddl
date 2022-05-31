let
  sources = import ./nix/sources.nix;
  nixpkgs = import sources."nixos-unstable" { };
in
nixpkgs.mkShell {
  name = "flake-shell";
  buildInputs = [
    nixpkgs.nixUnstable
  ];
}
