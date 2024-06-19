input=$(</dev/stdin)

num_allocs=$(echo "$input" | grep -oP 'num_allocs: \K\d+')
num_deallocs=$(echo "$input" | grep -oP 'num_deallocs \K\d+')
bytes=$(echo "$input" | grep -oP 'bytes: \K\d+')
seconds=$(echo "$input" | grep -oP 'seconds: \K[\d.]+')

json_output=$(cat <<EOF
{
	"num_allocs": $num_allocs,
	"num_deallocs": $num_deallocs,
	"bytes": $bytes,
	"seconds": $seconds
}
EOF
)

echo "$json_output"

