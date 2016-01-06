#!/bin/bash

# Caution: "line 11 has flaw."
#   Below sed command will cause another travis-ci test failing in the future.
#   If you see that, you must doubt this command.
#   It must be original author's mistake.
#   I will fix this later with better solution.
#
#   blee@techempower.com
#
sed -i 's|"benchmarkdbpass", ".*", 3306|"benchmarkdbpass", "'"${DBHOST}"'", 3306|g' src/hello_world_app.erl

fw_depends erlang

rm -rf deps/* ebin/*
rebar get-deps
rebar compile

erl -pa ebin deps/*/ebin +sbwt very_long +swt very_low -s hello_world -noshell -detached
