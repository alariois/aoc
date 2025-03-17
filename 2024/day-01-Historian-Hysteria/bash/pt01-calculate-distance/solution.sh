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
  echo "$num1 and $num2"
done < "${input_file}"

mapfile -t leftsorted < <(printf '%d\n' "${lhs[@]}" | sort)
mapfile -t rightsorted < <(printf '%d\n' "${rhs[@]}" | sort)

len=${#lhs[@]}
# printf "len = $len\n"

accum=0

for ((i = 0; i < len; i++)); do
  left=${leftsorted[$i]}
  right=${rightsorted[$i]}
  diff=$((left - right))
  dist=${diff#-}
  ((accum += dist))
done

printf "final total: %d\n" ${accum}
