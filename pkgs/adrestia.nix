{
  lib,
  stdenv,
  fetchFromGitHub,
  clang,
}:
stdenv.mkDerivation {
  pname = "adrestia";
  version = "git";

  src = fetchFromGitHub {
    owner = "mfleming";
    repo = "adrestia";
    rev = "HEAD";
    sha256 = "sha256-8N3wCuW0JuV1ZfldqfSkTWhqWS330Pf7Zq50WoVYfmU=";
  };

  buildInputs = [clang];

  buildPhase = ''
    export CC=clang
    export CFLAGS=""
    make
  '';

  installPhase = ''
    mkdir -p $out/bin/
    cp -r adrestia $out/bin/adrestia
  '';

  meta = {
    description = "A benchmark to test scheduler load balancer.";
    # license = lib.licenses.gpl2; # Assuming GPL-2.0 based on 'GPL'
    platforms = ["i686-linux" "x86_64-linux" "aarch64-linux"];
    # maintainers = with lib.maintainers; [  ];
  };
}
