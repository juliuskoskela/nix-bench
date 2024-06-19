{
  pkgs,
  mkBench,
  mkJob,
  mkSuite,
}: let
  foo = pkgs.callPackage ./foo {inherit mkBench mkJob mkSuite;};
in {
  inherit foo;
}
