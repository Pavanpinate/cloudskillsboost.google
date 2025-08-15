
gcloud auth list

export ZONE=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-zone])")

export PROJECT_ID=$(gcloud config get-value project)

gcloud config set project "$PROJECT_ID"

gcloud compute ssh gcelab2 --project=$PROJECT_ID --zone=$ZONE --quiet --command "sudo apt install -y nginx"

gcloud compute firewall-rules list

gcloud compute firewall-rules create default-allow-http --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server

gcloud compute instances add-tags gcelab2 --tags http-server --zone $ZONE

gcloud compute firewall-rules list --filter=ALLOW:'80'

gcloud compute instances list --filter='tags:http-server'

curl http://$(gcloud compute instances list --filter=name:gcelab2 --format='value(EXTERNAL_IP)')

