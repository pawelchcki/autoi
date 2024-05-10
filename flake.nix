{
  description = "docker-builder";
  nixConfig.bash-prompt-prefix = "\[d-b\] ";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";

    pyproject-nix.url = "github:nix-community/pyproject.nix";

    nix2containerPkg.url = "github:nlewo/nix2container";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    treefmt-nix,
    pyproject-nix,
    nix2containerPkg,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      project = pyproject-nix.lib.project.loadPyproject {
        projectRoot = ./.;
      };
      pkgs = nixpkgs.legacyPackages.${system};
      nix2container = nix2containerPkg.packages.${system}.nix2container;

      treefmt = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;

      devEnv = pkgs.buildEnv {
        name = "root";
        paths = [pkgs.bashInteractive pkgs.coreutils treefmt.config.build.wrapper pkgs.frida-tools];
        pathsToLink = ["/bin"];
      };
    in {
      packages = {
        ciContainer = nix2container.buildImage {
          copyToRoot = pkgs.buildEnv {
            name = "root";
            paths = [devEnv];
            pathsToLink = ["/bin"];
          };
        };
      };

      packages.default = devEnv;
      formatter = treefmt.config.build.wrapper;

      devShells.default =
        pkgs.mkShell
        {
          nativeBuildInputs = [];
          packages = [
            devEnv
          ];
        };
    });
}
