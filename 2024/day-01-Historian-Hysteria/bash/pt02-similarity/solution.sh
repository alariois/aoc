#!/usr/bin/env bash

input_file="../../input.txt"
if [[ " $* " =~ [[:space:]](--example|-e)[[:space:]] ]]; then
  echo "Using example input file";
  input_file="../../input.example.txt";
fi

lhs=()
declare -A count_map;

while read -r left right; do
  lhs+=("${left}")
  ((count_map[$right]++))
done < "${input_file}"

result=0

for left in "${lhs[@]}"; do
  ((result += left * count_map[$left]))
done

echo "result = $result"
