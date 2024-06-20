{
  adrestia,
  mkBench,
  mkJob,
  mkSuite,
}: let
  bench = mkBench {
    name = "adrestia-bench";
    run = ''
      ${adrestia}/bin/adrestia -a $arrival_rate -l $num_loop -s $service_time -t $nr_threads
    '';
    parse = "tee";
  };

   logger = "tee";

  job1 = mkJob {
    inherit bench logger;
    name = "adrestia-job-1";
    args = {
      arrival_rate = 200;
      num_loop = 2000;
      service_time = 200;
      nr_threads = 1;
    };
  };

  job2 = mkJob {
    inherit bench logger;
    name = "adrestia-job-2";
    args = {
      arrival_rate = 200;
      num_loop = 2000;
      service_time = 200;
      nr_threads = 2;
    };
  };
in
  mkSuite {
    name = "adrestia-suite";
    jobs = [job1 job2];
  }
