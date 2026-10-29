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

        bao-approle = pkgs.stdenvNoCC.mkDerivation {
          pname = "bao-approle";
          inherit version;
          src = ./bin;
          nativeBuildInputs = [ pkgs.makeWrapper ];
          installPhase = ''
            install -Dm755 bao-approle $out/bin/bao-approle
            wrapProgram $out/bin/bao-approle \
              --prefix PATH : ${
                pkgs.lib.makeBinPath [
                  pkgs.curl
                  pkgs.jq
                ]
              }
          '';
          meta.description = "Shared OpenBao AppRole login, token revocation and GitHub installation-token CLI";
        };

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

        run-ansible = pkgs.stdenvNoCC.mkDerivation {
          pname = "run-ansible";
          inherit version;
          src = ./scripts;
          nativeBuildInputs = [ pkgs.makeWrapper ];
          installPhase = ''
            install -Dm755 run-ansible $out/bin/run-ansible
            wrapProgram $out/bin/run-ansible \
              --prefix PATH : ${
                pkgs.lib.makeBinPath [
                  pkgs.coreutils
                  pkgs.curl
                  pkgs.gawk
                  pkgs.git
                  pkgs.gnugrep
                  pkgs.jq
                  pkgs.openssh
                ]
              }
          '';
          meta.description = "Run one ansible-playbook with an OpenBao-signed SSH certificate, a host-key pin and run checks";
        };
      in
      {
        packages = {
          inherit bao-approle flow-lock semaphore-run run-ansible;
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
