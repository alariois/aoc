#!/usr/bin/env bash

input_file="../../input.txt"
if [[ " $* " =~ [[:space:]](--example|-e)[[:space:]] ]]; then
  input_file="../../input.example.pt02.txt"
fi

input=$(< $input_file)

input="${input//\)/)$'\n'}"

mul_pattern='do\(\)$|don'\''t\(\)$|mul\(([0-9]{1,3}),([0-9]{1,3})\)$'

result=0
enabled=true
while read -r line; do
  if [[ $line =~ $mul_pattern ]]; then
    match="${BASH_REMATCH[0]}"
    if [[ "$match" == "do()" ]]; then
      enabled=true
    elif [[ "$match" == "don't()" ]]; then
      enabled=false
    elif $enabled; then
      a="${BASH_REMATCH[1]}"
      b="${BASH_REMATCH[2]}"
      ((result += a * b))
    fi
  fi
done <<< "$input"

echo "result: $result"
