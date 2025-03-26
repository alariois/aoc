#!/usr/bin/env bash

input_file="../../input.txt"
if [[ " $* " =~ [[:space:]](-e|--example)[[:space:]] ]]; then
  input_file="../../input.example.txt"
fi

echo "input_file $input_file"

input=$(< $input_file)

declare -A rules

check-number-pair() {
  local prev="$1"
  local current="$2"
  local rule_list="${rules[$current]}"

  # no need to check
  if [[ -z $rule_list ]]; then
    return 0
  fi

  for disallowed_number in $rule_list; do
    if (( prev == disallowed_number )); then
      return 1
    fi
  done

  return 0
}

result=0

check-update() {
  local update=("$@")
  local len="${#update[@]}"

  local i
  local j

  for ((i = 1; i < len; i++)); do
    local current="${update[$i]}"
    for ((j = 0; j < i; j++)); do
      local prev="${update[$j]}"
      if ! check-number-pair $prev $current; then
        return 0
      fi
    done
  done

  ((result+=update[len/2]))

  return 1
}

while read -r line; do
  # read rules
  while IFS='|' read -ra rule; do
    if [[ -z $rule ]]; then
      break
    fi
    rules[${rule[0]}]+="${rule[1]} "
  done

  # read updates
  while IFS=, read -ra update; do
    check-update "${update[@]}"
  done
done <<< "$input"

echo "Result: $result"
