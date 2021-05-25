{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  yarnPkg = yarn2nix.mkYarnPackage {
    name = "yarn_project";
    packageJSON = ./package.json;
    unpackPhase = ":";
    src = null;
    yarnLock = ./yarn.lock;
    publishBinsFor = ["parcel-bundler"];
  };
in stdenv.mkDerivation {
  name = "elm_project";
  src = lib.cleanSource ./.;

  buildInputs = with elmPackages; [
    elm
    elm-format
    yarnPkg
    yarn
  ];

  patchPhase = ''
    rm -rf elm-stuff
    ln -sf ${yarnPkg}/node_modules .
  '';

  shellHook = ''
    ln -fs ${yarnPkg}/node_modules .
  '';

  configurePhase = pkgs.elmPackages.fetchElmDeps {
    elmPackages = import ./elm-srcs.nix;
    versionsDat = ./versions.dat;
  };

  installPhase = ''
    mkdir -p $out
    parcel build -d $out index.html
  '';
}
