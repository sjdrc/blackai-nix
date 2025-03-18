{nixpkgs, ...}: let
  pkgs = import nixpkgs {system = "x86_64-linux";};
in {
  openlens = pkgs.callPackage ./openlens.nix {};
}
