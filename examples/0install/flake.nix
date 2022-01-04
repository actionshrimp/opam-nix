{
  description =
    "Build a package from opam-repository, using the non-system compiler";
  inputs.opam-nix.url = "github:tweag/opam-nix";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = { self, opam-nix, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: {
      legacyPackages = let
        inherit (opam-nix.lib.${system}) queryToScope;
        scope = queryToScope { } {
          "0install" = null;
          # The following line forces opam to choose the compiler from opam instead of the nixpkgs one
          ocaml-base-compiler = null;
        };
      in scope;

      defaultPackage = self.legacyPackages.${system}."0install";
    });
}