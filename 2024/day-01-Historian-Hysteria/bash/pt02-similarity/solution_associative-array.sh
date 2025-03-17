#!/usr/bin/env bash

input_file="../../input.txt"
if [[ " $* " =~ [[:space:]](--example|-e)[[:space:]] ]]; then
  echo "Using example input file";
  input_file="../../input.example.txt";
fi

lhs=()
rhs=()

while read -r num1 num2; do
  lhs+=("$num1")
  rhs+=("$num2")
done < "${input_file}"

declare -A count_map

len=${#rhs[@]}

for ((i = 0; i < len; i++)); do
  right=${rhs[$i]}
  ((count_map[${right}]++))
done

accum=0

for ((i = 0; i < len; i++)); do
  left=${lhs[$i]}
  ((accum += left * count_map[${left}]))
done

echo "result: $accum"

