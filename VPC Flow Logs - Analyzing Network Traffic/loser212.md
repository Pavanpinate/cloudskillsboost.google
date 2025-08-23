
## 💡 Lab Link: [VPC Flow Logs - Analyzing Network Traffic - GSP212](https://www.cloudskillsboost.google/focuses/1236?parent=catalog)



---

### ⚠️ Disclaimer
- **This script and guide are provided for  the educational purposes to help you understand the lab services and boost your career. Before using the script, please open and review it to familiarize yourself with Google Cloud services. Ensure that you follow 'Qwiklabs' terms of service and YouTube’s community guidelines. The goal is to enhance your learning experience, not to bypass it.**

### ©Credit
- **DM for credit or removal request (no copyright intended) ©All rights and credits for the original content belong to Google Cloud [Google Cloud Skill Boost website](https://www.cloudskillsboost.google/)** 🙏

---

## 🚨Copy and run the below commands in Cloud Shell:

```
curl -LO raw.githubusercontent.com/Techcps/Google-Cloud-Skills-Boost/master/VPC%20Flow%20Logs%20Analyzing%20Network%20Traffic/techcps212.sh
sudo chmod +x techcps212.sh
./techcps212.sh
```

- **Sink Name: vpc-flows**

---

```
CP_IP=$(gcloud compute instances describe web-server --zone=$ZONE --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

export MY_SERVER=$CP_IP

for ((i=1;i<=50;i++)); do curl $MY_SERVER; done
```


### Congratulations, you're all done with the lab 😄

---

