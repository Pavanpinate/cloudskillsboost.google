



---

### ⚠️ Disclaimer
- **This script and guide are provided for  the educational purposes to help you understand the lab services and boost your career. Before using the script, please open and review it to familiarize yourself with Google Cloud services. Ensure that you follow 'Qwiklabs' terms of service and YouTube’s community guidelines. The goal is to enhance your learning experience, not to bypass it.**

### ©Credit
- **DM for credit or removal request (no copyright intended) ©All rights and credits for the original content belong to Google Cloud [Google Cloud Skill Boost website](https://www.cloudskillsboost.google/)** 🙏

---

### 🚨Copy and run the below commands in Cloud Shell:

```
curl -LO raw.githubusercontent.com/Techcps/Google-Cloud-Skills-Boost/master/Running%20a%20Dedicated%20Ethereum%20RPC%20Node%20in%20Google%20Cloud/techcps1116.sh
sudo chmod +x techcps1116.sh
./techcps1116.sh
```
---

### 💡 After scoring `90/100` in the lab, run the below commands and follow the video instructions

```
export ZONE=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-zone])")

gcloud compute instances stop eth-mainnet-rpc-node --project=$DEVSHELL_PROJECT_ID --zone=$ZONE && gcloud compute instances set-machine-type eth-mainnet-rpc-node --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type=n2-standard-4 && gcloud compute instances start eth-mainnet-rpc-node --project=$DEVSHELL_PROJECT_ID --zone=$ZONE
```

### Congratulations, you're all done with the lab 😄

---

