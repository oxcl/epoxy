{
  description = "Epoxy";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          name = "epoxy";
          src = ./.;

          nativeBuildInputs = [
            pkgs.makeWrapper
          ];

          buildInputs = [
            pkgs.hyprland
            pkgs.foot
          ];

          installPhase = ''
            mkdir -p $out/bin
            install -Dm755 epoxy.sh $out/bin/epoxy

            # Wrap the script so Hyprland and foot are available in PATH
            wrapProgram $out/bin/epoxy \
              --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.hyprland pkgs.foot ]}
          '';

          meta = {
            description = "Epoxy - Hyprland wrapper";
            mainProgram = "epoxy";
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.hyprland
            pkgs.foot
            pkgs.lua5_4
            pkgs.lua-language-server
            pkgs.grim
            pkgs.wl-clipboard
          ];

          shellHook = ''
            echo "epoxy dev shell loaded"
          '';
        };
      });
}
