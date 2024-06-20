input=$(</dev/stdin)

num_allocs=$(echo "$input" | grep -oP 'num_allocs: \K\d+')
num_deallocs=$(echo "$input" | grep -oP 'num_deallocs \K\d+')
bytes=$(echo "$input" | grep -oP 'bytes: \K\d+')
seconds=$(echo "$input" | grep -oP 'seconds: \K[\d.]+')

# BENCH_NAME and JOB_NAME are environment variables set by the runner

json_output=$(cat <<EOF
{
	"bench_name": "$BENCH_NAME",
	"job_name": "$JOB_NAME",
	"num_allocs": $num_allocs,
	"num_deallocs": $num_deallocs,
	"bytes": $bytes,
	"seconds": $seconds
}
EOF
)

echo "$json_output"

