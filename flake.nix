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

        semaphore-run = pkgs.stdenvNoCC.mkDerivation {
          pname = "semaphore-run";
          inherit version;
          src = ./scripts;
          nativeBuildInputs = [ pkgs.makeWrapper ];
          installPhase = ''
            install -Dm755 semaphore-run $out/bin/semaphore-run
            wrapProgram $out/bin/semaphore-run \
              --prefix PATH : ${
                pkgs.lib.makeBinPath [
                  flow-lock
                  pkgs.curl
                  pkgs.jq
                ]
              }
          '';
          meta.description = "Managed Semaphore task dispatch (list, start, wait, log, stop) with the API token read from OpenBao";
        };
      in
      {
        packages = {
          inherit flow-lock semaphore-run;
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
