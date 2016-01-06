#!/bin/bash

# Caution: "line 11 has flaw."
#   Below sed command will cause another travis-ci test failing in the future.
#   If you see that, you must doubt this command.
#   It must be original author's mistake.
#   I will fix this later with better solution.
#
#   dummy change
#
#   blee@techempower.com
#
echo "카우보이의 시작"
sed -i 's|"benchmarkdbpass", ".*", 3306|"benchmarkdbpass", "'"${DBHOST}"'", 3306|g' src/hello_world_app.erl

echo "얼렝설치전"
fw_depends erlang

echo "얼렝 설치완료"

rm -rf deps/* ebin/*
echo "쓸대없는것 정리후 컴파일시작준비중"
rebar get-deps
rebar compile

echo "프레임워크시작"
python --version
echo "=========="
erl -pa ebin deps/*/ebin +sbwt very_long +swt very_low -s hello_world -noshell -detached
