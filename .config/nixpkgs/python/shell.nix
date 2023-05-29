with (import <nixpkgs> {});
let
  py-pkg = python-packages: with python-packages; [
    pandas
    requests
    # other python packages you want
  ];
  python-pkg = python3.withPackages py-pkg;
in
mkShell {
  buildInputs = [
    python-pkg
  ];
}
