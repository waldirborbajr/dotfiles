{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "nvchad-config";

  # Use the fetchFromGitHub function to install NvChad from my GitHub.
  src = pkgs.fetchFromGitHub {
    owner = "waldirborbajr";
    repo = "nvchad-config";
    rev = "8b6a7bf";
    sha256 = "sha256-vcvd3tH+HYJFuz4uoWBgkl4z/3h+hb8ZKZgrBgo+UnQ=";
  };

  # Specify the installation directory
  installPhase = ''
    mkdir -p $out/nvchad
    cp -r * $out/nvchad
  '';
}
