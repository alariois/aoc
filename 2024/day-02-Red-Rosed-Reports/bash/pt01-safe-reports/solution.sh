#!/usr/bin/env bash

input_file="../../input.txt"
if [[ " $* " =~ [[:space:]](--example|-e)[[:space:]] ]]; then
input_file="../../input.example.txt"
fi

is-report-safe() {
  local levels=("$@")
  # assume at least two levels in a report
  local levels_ascending=$((levels[0] < levels[1]))

  local len="${#levels[@]}"
  for (( i=0; i < len-1; i++)); do
    local current=${levels[i]}
    local next=${levels[i+1]}
    if ((next == current)); then
      # echo "ERR: $next = $current ${levels[@]}"
      return 1
    fi

    local ascending=$((current < next))
    if (( levels_ascending != ascending )); then
      # echo "ERR: sign flipped sign ${levels[@]}"
      return 1;
    fi

    local diff=$((current - next))
    local dist=${diff#-}
    if (( dist < 1 || dist > 3 )); then
      # echo "ERR: distance out of bounds ($dist) ${levels[@]}"
      return 1;
    fi
  done

  return 0
}

cnt_safe=0

while read -ra levels; do
  if is-report-safe "${levels[@]}"; then
    ((count++))
  fi
done < "${input_file}"

echo "Nr of safe reports: $count"
