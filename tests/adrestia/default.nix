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
    parse = ''
      input=$(</dev/stdin)

      wakeup_cost_single_us=$(echo "$input" | grep -oP 'wakeup cost \(single\): \K\d+')
      wakeup_cost_periodic_us=$(echo "$input" | grep -oP 'wakeup cost \(periodic, [0-9]+us\): \K\d+')

      json_output=$(cat <<EOF
      {
        "bench_name": "$BENCH_NAME",
        "job_name": "$JOB_NAME",
        "wakeup_cost_single_us": $wakeup_cost_single_us,
        "wakeup_cost_periodic_us": $wakeup_cost_periodic_us
      }
      EOF
      )

      echo "$json_output"
    '';
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
