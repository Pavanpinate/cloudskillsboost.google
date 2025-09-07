### Enhance Scalability Using Managed Instance Groups


### ⚠️ Disclaimer
- **This script and guide are provided for  the educational purposes to help you understand the lab services and boost your career. Before using the script, please open and review it to familiarize yourself with Google Cloud services. Ensure that you follow 'Qwiklabs' terms of service and YouTube’s community guidelines. The goal is to enhance your learning experience, not to bypass it.**

### ©Credit
- **DM for credit or removal request (no copyright intended) ©All rights and credits for the original content belong to Google Cloud [Google Cloud Skill Boost website](https://www.cloudskillsboost.google/)** 🙏


* Replace `[enter region]` with region given


```
gcloud compute instance-groups managed create dev-instance-group --template=dev-instance-template --size=1 --region=[enter region] && gcloud compute instance-groups managed set-autoscaling dev-instance-group --region=[enter region] --min-num-replicas=1 --max-num-replicas=3 --target-cpu-utilization=0.6 --mode=on


```



