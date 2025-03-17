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
  local i
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

is-report-safe-dampened() {
  if is-report-safe "$@"; then
    # great success with first try
    return 0
  fi

  local levels=("$@")
  local len=${#levels[@]}

  local i
  for (( i=0; i < len; i++ )); do
    local j=$((i+1))
    local damped_levels=(${levels[@]:0:i} ${levels[@]:j})
    # echo " from dampener ${levels[@]} remove $k - $j"

    if is-report-safe "${damped_levels[@]}"; then
      return 0
    fi
  done

  return 1
}

cnt_safe=0

while read -ra levels; do
  if is-report-safe-dampened "${levels[@]}"; then
    ((count++))
  fi
done < "${input_file}"

echo "Nr of safe reports: $count"
