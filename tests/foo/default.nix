{
  stdenv,
  mkBench,
  mkJob,
  mkSuite,
}: let
  # Create a derivation to build the test binary
  benchPkg = stdenv.mkDerivation {
    name = "foo-pkg";
    src = ./.;
    buildPhase = ''
      gcc $src/main.c
    '';
    installPhase = ''
      mkdir -p $out/bin
      cp a.out $out/bin/${benchPkg.name}
    '';
  };

  # Create a benchmark using mkBench
  bench = mkBench {
    name = "foo-bench";
    # Command to run the benchmark binary
    run = "${benchPkg}/bin/foo-pkg";
    # Script to parse the test output
    parse = builtins.readFile ./parse.sh; 
  };

  # Create a logging command which receives the parsed output via stdin. In
  # this case, we use the 'tee' command to log the output directly to the
  # console, but we could also log it to a file or a database.
  logger = "tee";

  # Create a job using mkJob
  job1 = mkJob {
    # Use the test and logger created earlier
    inherit bench logger;
    name = "foo-job-1";
    # Pass arguments (environment variables) to the test binary
    args = {
      NUM_ALLOCS = 1000;
      ALLOC_SIZE = 1024;
    };
  };

  # Create another job with different arguments
  job2 = mkJob {
    inherit bench logger;
    name = "foo-job-2";
    args = {
      NUM_ALLOCS = 1000;
      ALLOC_SIZE = 1024 * 1024;
    };
  };
in
  # Create a suite using mkSuite, containing the two jobs
  mkSuite {
    name = "foo-suite";
    jobs = [job1 job2];
  }
