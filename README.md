# Prometheus2-grafana-dashboard
Default dashboard for Prometheus version 2.0 for Grafana

More info in [documentation](https://fusakla.github.io/Prometheus2-grafana-dashboard/)

### Updating the dashboard
There is a script to show difference between metrics 
of running Prometheus instance and those used by the dashboard.

1. Run the Prometheus instance for example `docker run -d -p 9090:9090 prom/prometheus:master`.
1. You need `curl` and `jq`, so please make sure you have those installed. 
1. Run the script `./inspect_metrics.sh`.
1. You should get an output with listing of differences.
