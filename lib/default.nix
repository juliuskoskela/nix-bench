{
  lib,
  writeShellScriptBin,
}: let
  mkBench = {
    name,
    run,
    parse,
  }: let
    runBin = writeShellScriptBin "run" run;
    parseBin = writeShellScriptBin "parse" parse;
    bin = "${runBin}/bin/run | ${parseBin}/bin/parse";
  in {
    inherit name bin;
  };

  mkJob = {
    name,
    test,
    logger,
    args ? {},
  }: let
    argsList = lib.mapAttrsToList (name: value: {inherit name value;}) args;
    argsString = lib.strings.concatStringsSep "\n" (map (arg: "export ${arg.name}=\"${toString arg.value}\"") argsList);
  in
    writeShellScriptBin name ''
      ${argsString}
      ${test.bin} | ${logger}
    '';

  mkSuite = {
    name,
    jobs,
  }: let
    jobsString = lib.strings.concatStringsSep "\n" (map (job: "${job}/bin/${job.name}") jobs);
  in
    writeShellScriptBin name jobsString;
in {
  inherit mkBench mkJob mkSuite;
}
