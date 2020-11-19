#!/bin/bash

TESTS_PATH="$1"

pushd $TESTS_PATH

mkdir sorted/pass sorted/fail -p

function run() {
  file=$1
  dir=${1/.pl/}
  dir=${dir/t\//}

  printf "%-40s" "$dir"

  timeout 15 ./driver.pl $file >& /dev/null

  if [[ $? != 0 ]];  then
    printf "%10s" "[FAIL]"
    mv obj_vlt/$dir sorted/fail/
  else
    printf "%10s" "[OK]"
    mv obj_vlt/$dir sorted/pass/
  fi
  echo
}

for file in $(ls t/t_*pl); do
  run $file
done

echo "================="
echo "= FAILING TESTS ="
echo "================="
ls -l sorted/fail/
echo "================="

popd $TESTS_PATH
