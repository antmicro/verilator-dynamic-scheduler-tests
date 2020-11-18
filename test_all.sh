#!/usr/bin/env bash

rm -rf out

TESTS=$(ls tests/)

#echo $TESTS

TOTAL=0
PASSED=0

function line() {
printf "=%.0s" {0..80}
echo
}

line
printf "Starting test suite\n"
line

for TEST in $TESTS; do
  TOTAL=$((TOTAL + 1))

  ./test.sh "tests/$TEST" 2>&1 > /dev/null

  if [[ $? -eq 0 ]]; then
    printf "%-50s %30s\n" "$TEST" "OK"
    PASSED=$((PASSED + 1))
  else
    printf "%-50s %30s\n" "$TEST" "FAIL"
  fi
done

line
printf "%-50s %30s\n" "TOTAL" "$PASSED/$TOTAL"

if [[ "$PASSED" == "$TOTAL" ]]; then
  printf "%-50s %30s\n" "RESULT" "SUCCESS"
  line
  exit 0
else
  printf "%-50s %30s\n" "RESULT" "FAILURE"
  line
  exit 1
fi
