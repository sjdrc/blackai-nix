{
  description = "NixOS configuration for black.ai";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*";

    kolide-launcher.url = "github:kolide/nix-agent/main";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
  in {
    packages = import ./packages {inherit nixpkgs;};

    nixosModules.blackai = {pkgs, ...}: {
      imports = [
        inputs.kolide-launcher.nixosModules.kolide-launcher
      ];

      # Enable vpn service
      services.tailscale.enable = true;

      # Enable machine compliance tool
      services.kolide-launcher.enable = true;

      # Enable antivirus
      services.clamav.daemon.enable = true;
      services.clamav.updater.enable = true;
      services.clamav.scanner.enable = true;

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
        stern # for @andrea-falco/lens-multi-pod-logs extension
        kubelogin-oidc
        (pkgs.google-cloud-sdk.withExtraComponents [pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin])
      ];
    };
  };
}
