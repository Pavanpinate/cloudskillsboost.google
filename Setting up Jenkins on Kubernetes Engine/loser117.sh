

gcloud auth list

pattern=(
"**********************************************************"
"**                 S U B S C R I B E  TO                **"
"**                      LOSER-GSC                       **"
"**                                                      **"
"**********************************************************"
)

export PROJECT_ID=$(gcloud config get-value project)

export PROJECT_ID=$DEVSHELL_PROJECT_ID

gcloud config set compute/zone $ZONE

git clone https://github.com/GoogleCloudPlatform/continuous-deployment-on-kubernetes.git

cd continuous-deployment-on-kubernetes

gcloud container clusters create jenkins-cd \
--num-nodes 2 --zone=$ZONE \
--scopes "https://www.googleapis.com/auth/projecthosting,cloud-platform"

gcloud container clusters list

gcloud container clusters get-credentials jenkins-cd

kubectl cluster-info

helm repo add jenkins https://charts.jenkins.io

helm repo update

helm upgrade --install -f jenkins/values.yaml myjenkins jenkins/jenkins
pattern=(
"**********************************************************"
"**                 S U B S C R I B E  TO                **"
"**                      LOSER-GSC                       **"
"**                                                      **"
"**********************************************************"
)


