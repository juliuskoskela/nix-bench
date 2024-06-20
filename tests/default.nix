{
  pkgs,
  benchPkgs,
  mkBench,
  mkJob,
  mkSuite,
}: {
  foo = pkgs.callPackage ./foo {inherit mkBench mkJob mkSuite;};
  adrestia = pkgs.callPackage ./adrestia {inherit (benchPkgs) adrestia; inherit mkBench mkJob mkSuite;};
}
