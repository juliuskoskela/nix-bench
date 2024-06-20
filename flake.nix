{
  description = "A flake for nix-bench, a benchmarking tool for Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    fu.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    fu,
  }: let
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin"];
  in
    fu.lib.eachSystem systems (
      system: let
        pkgs = import nixpkgs {inherit system;};
        lib = pkgs.callPackage ./lib {};
        benchPkgs = pkgs.callPackage ./pkgs {};
        tests = pkgs.callPackage ./tests {inherit benchPkgs; inherit (lib) mkBench mkJob mkSuite;};
      in {
        packages = {
          inherit (tests) foo adrestia;
        };
        formatter = pkgs.alejandra;
        devShells.default = pkgs.mkShell {
          buildInputs = [
            tests.foo
            tests.adrestia
          ];
        };
      }
    );
}
