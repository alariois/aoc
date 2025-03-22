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

check-puzzle() {
  local diagpos="$(get-string $((x-1)) $((y-1)) 1 1 3)"
  local diagneg="$(get-string $((x-1)) $((y+1)) 1 -1 3)"
  if [[ ("$diagpos" == "MAS" || "$diagpos" == "SAM") && ("$diagneg" == "MAS" || "$diagneg" == "SAM") ]]; then
    ((xmas_count++))
    return 0
  fi
}

for ((y = 0; y < height; y++)); do
  for ((x = 0; x < width; x++)); do
    char="${puzzle[x + y*height]}"
    if [[ "$char" == A ]]; then
      check-puzzle
    fi
  done
done

echo "XMAS COUNT: $xmas_count"
