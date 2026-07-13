{
  description = "dryvist homelab contracts — inventory schema, port constants, and non-IaC mutation tooling";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        version = (builtins.fromJSON (builtins.readFile ./.release-please-manifest.json)).".";

        flow-lock = pkgs.stdenvNoCC.mkDerivation {
          pname = "flow-lock";
          inherit version;
          src = ./bin;
          nativeBuildInputs = [ pkgs.makeWrapper ];
          installPhase = ''
            install -Dm755 flow-lock $out/bin/flow-lock
            install -Dm755 deployment-json $out/bin/deployment-json
            wrapProgram $out/bin/flow-lock \
              --prefix PATH : ${
                pkgs.lib.makeBinPath [
                  pkgs.curl
                  pkgs.jq
                ]
              }
            wrapProgram $out/bin/deployment-json \
              --prefix PATH : ${
                pkgs.lib.makeBinPath [
                  pkgs.awscli2
                  pkgs.jq
                  pkgs.check-jsonschema
                ]
              }
          '';
          meta.description = "Global homelab flow lease + gated credential injection (and the locked deployment.json helper)";
        };
      in
      {
        packages = {
          inherit flow-lock;
          default = flow-lock;
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            bashInteractive
            shellcheck
            bats
            jq
            curl
            awscli2
            check-jsonschema
            yamllint
          ];
        };
      }
    );
}
