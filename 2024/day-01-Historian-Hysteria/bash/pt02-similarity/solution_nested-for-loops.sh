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
  # echo "$num1 and $num2"
done < "${input_file}"

len=${#lhs[@]}
accum=0
for ((i = 0; i < len; i++)); do
  count=0
  left=${lhs[$i]}
  for ((j = 0; j < len; j++)); do
    right=${rhs[$j]}
    if [[ left -eq right ]]; then
      ((count++))
    fi
  done
  # echo "$left appears $count times"
  ((accum += count * left))
done

echo "result: $accum"

