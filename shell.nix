{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {
  name = "elm_project";

  buildInputs = with elmPackages; [
    elm
    elm-format
    elm-review
    elm-test
    yarn
    nodePackages.parcel-bundler
  ];
}
