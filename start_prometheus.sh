#!/bin/bash

config_good="conf.good.yml"
tmp_config="$config_good.tmp"


for config_file in $config_good "first.rules"; do
  if [ -e "$config_file" ] && [ ! "$1" == "-f" ]; then
    continue
  fi
  echo "Downloading config/testdata/$config_file from Prometheus GIT repository."
  curl -so "$config_file" "https://raw.githubusercontent.com/prometheus/prometheus/master/config/testdata/$config_file"
  if [ "$config_file" == "$config_good" ]; then
    echo "Applying modifications to the $config_good file"
    sed -i 's/localhost:9191/demo.robustperception.io:9090/g' $config_good
    sed -i 's/evaluation_interval: 30s/evaluation_interval: 10s/g' $config_good
    sed -E 's/^(\s+)(read_recent: [a-z]+)(\s*)$/\1\2\3\n\1remote_timeout: 0s\3/g' conf.good.yml > $tmp_config
    grep -vE '[a-z]_file:.*' $tmp_config > $config_good
    rm $tmp_config
  fi
done

printf '\n'

if [ "$1" == "-f" ]; then
  echo "Stopping already running ptometheus instance"
  docker kill prometheus-test &>/dev/null
fi

echo "Starting testing prometheus instance http://localhost:9090, to stop it run 'docker kill prometheus-test'."
docker run --rm -d --name prometheus-test -p 9090:9090 -v "$PWD":/test prom/prometheus:master --config.file=/test/$config_good
