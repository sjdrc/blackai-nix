{
  description = "NixOS configuration for black.ai";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    packages.openlens = pkgs.callPackage ./packages/openlens.nix {};

    nixosModules.blackai = {pkgs, ...}: {
      # Enable vpn service
      services.tailscale.enable = true;

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
        enableBashIntegration = true;
      };

      environment.systemPackages = with pkgs; [
        # General tools
        slack
        # Development
        openlens
        kubectl
        stern # for @andrea-falco/lens-multi-pod-logs extension
        kubelogin-oidc
      ];
    };
  };
}
