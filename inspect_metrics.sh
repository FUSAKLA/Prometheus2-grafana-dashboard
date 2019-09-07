#!/bin/bash

DASHBOARD_FILE=${DASHBOARD_FILE:-"./dashboard/prometheus2-dashboard.json"}
DASHBOARD_METRICS_PREFIXES="prometheus|go|process|scrape"
PROMETHEUS_URL=${PROMETHEUS_URL:-"http://localhost:9090"}
METRICS_SELECTOR='{instance="localhost:9090", __name__!~"up"}'

if [ -z "$PROMETHEUS_URL" ]; then
  echo "You have to specify the PROMETHEUS_URL variable"
  exit 1
fi

if [ ! $(command -v jq) ];then
  echo "you need jq tool installed"
  exit 1
fi

prometheus_metrics=$(curl -s "$PROMETHEUS_URL/api/v1/series" --data-urlencode "match[]=$METRICS_SELECTOR" | jq -r '[.data[].__name__] | unique | .[]')
dashboard_metrics=$(grep -Eo "($DASHBOARD_METRICS_PREFIXES)_[a-z]+_[a-z_]+" "$DASHBOARD_FILE")

echo "Checking for Prometheus metrics not used in the dashboard:"
for metric_name in $prometheus_metrics; do
  if grep -q "$metric_name" "$DASHBOARD_FILE"; then
    continue
  fi
  echo "  - $metric_name"
done

printf '\n\n\n'

echo "Checking for Prometheus metrics used in the dashboard but not exposed by the Prometheus:"
for metric_name in $dashboard_metrics; do
  if echo "$prometheus_metrics" | grep -q "$metric_name"; then
    continue
  fi
  echo "  - $metric_name"
done
