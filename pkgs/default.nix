{pkgs, ...}:
with pkgs; {
  adrestia = callPackage ./adrestia.nix {};
}
