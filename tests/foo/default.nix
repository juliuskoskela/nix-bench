{
  stdenv,
  mkBench,
  mkJob,
  mkSuite,
}: let
  # Create a derivation to build the test binary
  testPkg = stdenv.mkDerivation {
    name = "test-bin";
    src = ./.;
    buildPhase = ''
      gcc $src/main.c
    '';
    installPhase = ''
      mkdir -p $out/bin
      cp a.out $out/bin/test-bin
    '';
  };

  # Create a test using mkTest
  test = mkBench {
    name = "test";
    run = "${testPkg}/bin/test-bin"; # Command to run the test binary
    parse = builtins.readFile ./parse.sh; # Script to parse the test output
  };

  # Create a logging command which receives the parsed output via stdin
  logger = "tee";

  # Create a job using mkJob
  job1 = mkJob {
    # Use the test and logger created earlier
    inherit test logger;
    name = "job-1";
    # Pass arguments (environment variables) to the test binary
    args = {
      NUM_ALLOCS = 1000;
      ALLOC_SIZE = 1024;
    };
  };

  # Create another job with different arguments
  job2 = mkJob {
    inherit test logger;
    name = "job-2";
    args = {
      NUM_ALLOCS = 1000;
      ALLOC_SIZE = 1024 * 1024;
    };
  };
in
  # Create a suite using mkSuite, containing the two jobs
  mkSuite {
    name = "foo";
    jobs = [job1 job2];
  }
