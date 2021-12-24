let
  pkgs = import <nixpkgs> { };
  opam-nix = import ../. pkgs;
  repos = {
    default = pkgs.fetchFromGitHub (pkgs.lib.importJSON ./opam-repository.json);
    # Only uses the source, not the derivation itself
    opam2json = opam-nix.makeOpamRepo (pkgs.ocamlPackages.callPackage ../opam2json.nix {}).src;
  };
  scope = opam-nix.queryToScope { inherit repos pkgs; } {
    opam2json = null;
    ocaml = "4.12.1";
  };
  overlay = self: super: { };

in scope.overrideScope' overlay
