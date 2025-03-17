#!/usr/bin/env bash

input_file="../../input.txt"
if [[ " $* " =~ [[:space:]](--example|-e)[[:space:]] ]]; then
  echo "Using example input file";
  input_file="../../input.example.txt";
fi

count=0
while read -r line; do
  # echo "------ LINE: $line"
  index=0
  ok=true
  sign=0
  for nr in $line; do
    if (( index == 0 )); then
      sign=0
    else
      diff=$((nr - prev));
      diffabs="${diff#-}"

      if (( index == 1 || sign == 0 )); then
        if (( diff == 0 )); then
          sign = 0
        elif (( diff > 0 )); then
          sign=1
        else
          sign=-1
        fi
      fi

      # echo "diff NR: $diff sign: $sign abs: $diffabs";

      if ((diffabs > 3)); then
        echo "Diff to big for line $line"
        ok=false
      fi

      if ((diffabs == 0)); then
        echo "No diff for line $line"
        ok=false
      fi

      if ((sign != 0)); then
        if ((sign > 0)); then
          if ((diff < 0)); then
            echo "Wrong sign for line $line";
            ok=false
          fi
        else
          if ((diff > 0)); then
            echo "Wrong sign for line $line";
            ok=false
          fi
        fi
      fi
    fi
    prev=$nr
    ((index++))
  done

  if [[ $ok == true ]]; then
    ((count++))
  fi
  # echo "@@@@@@@ LINE: $line ok: $ok count=$count"
done < "${input_file}"

echo "Safe reports count: $count"

