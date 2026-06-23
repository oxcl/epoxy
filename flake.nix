{
  description = "Epoxy";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    somewm.url = "github:trip-zip/somewm";
  };

  outputs = { self, nixpkgs, flake-utils, somewm }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.cage = pkgs.cage;

        packages.default = pkgs.stdenv.mkDerivation {
          name = "epoxy";
          src = ./.;

          nativeBuildInputs = [
            pkgs.makeWrapper
          ];

          buildInputs = [
            pkgs.hyprland
            pkgs.foot
            pkgs.rofi-wayland
            pkgs.pi-coding-agent
          ];

          installPhase = ''
            mkdir -p $out/bin
            install -Dm755 epoxy.sh $out/bin/epoxy

            # Wrap the script so Hyprland and foot are available in PATH
            wrapProgram $out/bin/epoxy \
              --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.hyprland pkgs.foot pkgs.rofi-wayland pkgs.pi-coding-agent ]}
          '';

          meta = {
            description = "Epoxy - Hyprland wrapper";
            mainProgram = "epoxy";
          };
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [
            somewm.packages.${system}.somewm
          ];

          packages = [
            somewm.packages.${system}.somewm
            pkgs.cage
            pkgs.foot
            pkgs.lua5_4
            pkgs.lua-language-server
            pkgs.grim
            pkgs.wl-clipboard
            pkgs.rofi-wayland
            pkgs.pi-coding-agent
          ];

          shellHook = ''
            echo "epoxy dev shell loaded"
          '';
        };
      });
}
