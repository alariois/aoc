#!/usr/bin/env bash

input_file="../../input.txt"
if [[ " $* " =~ [[:space:]](--example|-e)[[:space:]] ]]; then
  input_file="../../input.example.txt"
fi

input=$(< $input_file)

input="${input//\)/)$'\n'}"

mul_pattern='mul\(([0-9]{1,3}),([0-9]{1,3})\)'

result=0
while read -r line; do
  if [[ $line =~ $mul_pattern ]]; then
    a="${BASH_REMATCH[1]}"
    b="${BASH_REMATCH[2]}"
    ((result += a * b))
  fi
done <<< "$input"

echo "result: $result"
