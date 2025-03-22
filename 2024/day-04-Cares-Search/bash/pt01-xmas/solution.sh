#!/usr/bin/env bash

input_file="../../input.txt"
if [[ " $* " =~ [[:space:]](-e|--example)[[:space:]] ]]; then
  input_file="../../input.example.txt"
fi

input=$(< $input_file)

puzzle=()
height=0
char_count=0

while read -rn 1 line; do
  if [[ -z "$line" ]]; then
    ((height++))
    continue
  fi
  ((char_count++))
  puzzle+=("$line")
done <<< "$input"

width=$((char_count / height))
echo "Chars: $char_count"
echo "Size: $width x $height"

print-puzzle() {
  local x
  local y
  for ((y = 0; y < height; y++)); do
    for ((x = 0; x < width; x++)); do
      printf "${puzzle[x + y*height]}"
    done
    printf "\n"
  done
}

get-string() {
  local x=$1
  local y=$2
  local inc_x=$3
  local inc_y=$4
  local len=$5
  local i
  for ((i = 0; i < len; i++)); do
    if ((x < 0 || y < 0 || x >= width || y >= height)); then
      printf "\n"
      return 0
    fi

    local char="${puzzle[x + y*height]}"
    printf "$char"
    ((x+=inc_x))
    ((y+=inc_y))
  done
  printf "\n"
}

xmas_count=0

check-position() {
  local x=$1
  local y=$2
  local inc_x=$3
  local inc_y=$4
  local text="$(get-string $x $y $inc_x $inc_y 4)"
  if [[ "$text" == "XMAS" ]]; then
    ((xmas_count++))
  fi
}
check-puzzle() {
  for ((inc_x=-1; inc_x <= 1; inc_x++)); do
    for ((inc_y=-1; inc_y <= 1; inc_y++)); do
      if ((inc_x == 0 && inc_y == 0)); then
        continue
      fi
      check-position $x $y $inc_x $inc_y
    done
  done
}

for ((y = 0; y < height; y++)); do
  for ((x = 0; x < width; x++)); do
    char="${puzzle[x + y*height]}"
    if [[ "$char" == X ]]; then
      check-puzzle
    fi
  done
done

echo "XMAS COUNT: $xmas_count"
