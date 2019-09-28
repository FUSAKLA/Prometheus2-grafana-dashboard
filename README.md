# Prometheus 2.0 Grafana dashboard
Dashboard aiming on operating multiple Prometheus instances.
It should give you generic view of your monitoring cluster status
but also in case of any issues provide deep insight into Prometheus internal metrics.

Most of the graphs are grouped into rows thematically, which are collapsed so they won't be loaded until you expand them.
Bear in mind that some of those could be more query intensive so better try them out on smaller time range first.

**Github repository [https://github.com/FUSAKLA/Prometheus2-grafana-dashboard](https://github.com/FUSAKLA/Prometheus2-grafana-dashboard)**

## Installation
There are two ways to install this dashboard

   1. Copy the [`JSON` definition](https://raw.githubusercontent.com/FUSAKLA/Prometheus2-grafana-dashboard/master/dashboard/prometheus2-dashboard.json)
      of dashboard and paste it in the Import dialog in Grafana
   1. Load the dashboard directly form Grafana.com website using dashboard ID `3681`
      or on link https://grafana.com/dashboards/3681


### Provisioning
If you use [dashboard provisioning](https://grafana.com/docs/administration/provisioning/#dashboards),
there is unfortunately [an issue with loading the dashboard which uses variables](https://github.com/grafana/grafana/issues/10786).
This could cause issues such as `unexpected character inside braces: '$'`. Hopefully this will get fixed in Grafana soon.
Until then you need to modify the manifest and replace the `VAR_DATASOURCE` and `VAR_CUSTOM_LABEL_NAME` on your own.
Sorry for the inconvenience :/


## Usage
- The constant type variable `custom_label_name` allows you to identify the Prometheus instance by additional label. By default it's identified by `instance` and `job` (default value of the custom label).
- Queries using `increase` or `rate` use the interval variable `Aggregation interval` as a range vector selector. Title of graph should always show the interval value.
- All panels which describes latency mostly shows quantile. This is controlled by the variable `Quantile` so make use of it.
- Some panels uses time interval override to longer value, this can be controlled by the `Long term interval` variable.
- Beware that some collapsed rows could be query expensive on the datasource (depends on complexity of observed Prometheus config or number of those instances). Better make sure to pick only one particular
    instance before expanding those rows.


## Screenshots
![Top of dashboard with main info](https://grafana.com/api/dashboards/3681/images/6907/image "Top of dashboard with main info")

![Numebr of requests and latencies](https://grafana.com/api/dashboards/3681/images/6910/image "Numebr of requests and latencies")

![Resources usage data](https://grafana.com/api/dashboards/3681/images/6911/image "Resources usage data")

![Service discovery metrics](https://grafana.com/api/dashboards/3681/images/6909/image "Service discovery metrics")

![Network usage data](https://grafana.com/api/dashboards/3681/images/6908/image "Network usage data")




## Updating the dashboard
There is a script to show difference between metrics 
of running Prometheus instance and those used by the dashboard.

1. Run the Prometheus instance for example `docker run -d -p 9090:9090 prom/prometheus:master`.
1. You need `curl` and `jq`, so please make sure you have those installed. 
1. Run the script `./inspect_metrics.sh`.
1. You should get an output with listing of differences.

## Issues and contributing
If you encounter any issues with the dashboard or would like to enhance it anyhow,
please raise an issue on the github repo and I'd be happy to discuss it!
