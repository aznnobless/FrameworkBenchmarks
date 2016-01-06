#!/bin/bash

echo "포닉스 시작"

fw_depends elixir

echo "엘릭서 설치 완료"

# read prod.exs 
#sudo sed -i 's|localhost|'${DBHOST}'|g' config/prod.exs
sed -i 's|localhost|'${DBHOST}'|g' config/prod.exs

echo "데이터베이스 ::: ${DBHOST}"

sudo rm -rf _build deps

echo "리무브후"

export MIX_ENV=prod
mix local.hex --force
mix deps.get --force
mix compile --force

echo "포닉스 서버 시작!!"
elixir --detached -S mix phoenix.server

echo "포닉스 셋업파일 끝"
