{ pkgs ? import <nixpkgs> {}
, ghc ? pkgs.ghc
}:

let
  ghc = ghc.withPackages(ps: with ps; [
    base
    haskell-discord
  ]);

in pkgs.haskell.lib.buildStackProject {
  pname = "Pipo";
  version = "0.1.0";

  inherit ghc;

  src = ./.;
}
