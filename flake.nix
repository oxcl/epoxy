{
  description = "Epoxy";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    somewm.url = "github:trip-zip/somewm";
  };

  outputs = { self, nixpkgs, somewm }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        name = "epoxy";
        src = ./.;

        nativeBuildInputs = [ pkgs.makeWrapper ];

        buildInputs = [
          pkgs.hyprland
          pkgs.foot
          pkgs.rofi
          pkgs.pi-coding-agent
        ];

        installPhase = ''
          mkdir -p $out/bin
          install -Dm755 epoxy.sh $out/bin/epoxy
          wrapProgram $out/bin/epoxy \
            --prefix PATH : ${pkgs.lib.makeBinPath [
              pkgs.hyprland pkgs.foot pkgs.rofi pkgs.pi-coding-agent
            ]}
        '';

        meta = {
          description = "Epoxy - Hyprland wrapper";
          mainProgram = "epoxy";
        };
      };

      devShells.${system}.default = pkgs.mkShell {
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
          pkgs.rofi
          pkgs.pi-coding-agent
        ];

        shellHook = ''
          echo "epoxy dev shell loaded"
        '';
      };
    };
}
