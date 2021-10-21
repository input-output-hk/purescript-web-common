{
  description = "JSON helpers for code generated with PureScript Bridge";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    easy-purescript-nix-source = {
      url = "github:justinwoo/easy-purescript-nix";
      flake = false;
    };
    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, easy-purescript-nix-source, gitignore }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ]
      ( system:
        let
          pkgs = import nixpkgs { inherit system; };
          inherit (gitignore.lib) gitignoreSource;
          spagoPkgs = import ./spago-packages.nix { inherit pkgs; };
          getGlob = pkg: ''".spago/${pkg.name}/${pkg.version}/src/**/*.purs"'';
          spagoSources =
            builtins.toString
              (builtins.map getGlob (builtins.attrValues spagoPkgs.inputs));
          easy-ps = import easy-purescript-nix-source { inherit pkgs; };
          purescriptMarkdown =
            pkgs.stdenv.mkDerivation {
              name = "purescript-bridge-json-helpers";
              buildInputs = [
                spagoPkgs.installSpagoStyle
              ];
              nativeBuildInputs = with easy-ps; [
                psa
                purs
                spago
              ];
              src = gitignoreSource ./.;
              unpackPhase = ''
                cp $src/spago.dhall .
                cp $src/packages.dhall .
                cp -r $src/src .
                install-spago-style
                '';
              buildPhase = ''
                set -e
                echo building project...
                psa compile --strict --censor-lib ${spagoSources} ./src/**/*.purs
                echo done.
                '';
              installPhase = ''
                mkdir $out
                mv output $out/
                '';
            };
          clean = pkgs.writeShellScriptBin "clean" ''
            set -e
            echo cleaning project...
            rm -rf .spago .spago2nix output
            echo removed .spago
            echo removed .spago2nix
            echo removed output
            echo done.
            '';
        in
          {
            packages = { inherit purescriptMarkdown; };
            defaultPackage = purescriptMarkdown;
            devShell = pkgs.mkShell {
              buildInputs = with easy-ps; [
                clean
                psa
                purescript-language-server
                purs
                purs-tidy
                spago
                spago2nix
              ];
            };
          }
      );
}
