{
  description = "Epoxy";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, flake-utils, hyprland }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        hyprland-pkg = hyprland.packages.${system}.hyprland;
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          name = "epoxy";
          src = ./.;

          propagatedBuildInputs = [
            hyprland-pkg
          ];

          installPhase = ''
            mkdir -p $out/bin

            cat > $out/bin/epoxy << 'SCRIPT'
#!/bin/sh
CONFIG_FILE="$HOME/.config/epoxy/hypr/hyprland.lua"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Config not found: $CONFIG_FILE"
  exit 1
fi

exec Hyprland -c "$CONFIG_FILE"
SCRIPT

            chmod +x $out/bin/epoxy
          '';

          meta = {
            description = "Epoxy - Hyprland wrapper";
            mainProgram = "epoxy";
          };
        };
      });
}
