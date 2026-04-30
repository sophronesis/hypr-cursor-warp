{
  description = "proportional cursor warping between hyprland monitors";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (system: pkgs: {
        default = pkgs.stdenvNoCC.mkDerivation {
          pname = "hypr-cursor-warp";
          version = "0.2.3";
          src = ./.;

          nativeBuildInputs = [ pkgs.makeWrapper ];
          buildInputs = [ pkgs.python3 ];

          dontBuild = true;
          dontConfigure = true;

          installPhase = ''
            runHook preInstall
            install -Dm755 hypr-cursor-warp $out/bin/hypr-cursor-warp
            patchShebangs $out/bin/hypr-cursor-warp
            runHook postInstall
          '';

          meta = with pkgs.lib; {
            description = "Proportional cursor warping between Hyprland monitors";
            homepage = "https://github.com/sophronesis/hypr-cursor-warp";
            license = licenses.mit;
            mainProgram = "hypr-cursor-warp";
            platforms = platforms.linux;
          };
        };
      });
    };
}
