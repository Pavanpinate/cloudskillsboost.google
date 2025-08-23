

gcloud auth list

export ZONE=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-zone])")

export REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])")


gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE


gcloud container clusters list

gcloud container clusters describe rbac-demo-cluster --zone=$ZONE --format="value(legacyAbac.enabled)"

gcloud iam service-accounts list

gcloud compute instances list


cat > cp.sh <<'EOF_CP'
sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin

echo "export USE_GKE_GCLOUD_AUTH_PLUGIN=True" >> ~/.bashrc

source ~/.bashrc

export ZONE=$(gcloud container clusters list --format="value(location)" --filter="name=rbac-demo-cluster")
echo $ZONE

gcloud container clusters get-credentials rbac-demo-cluster --zone "$ZONE"

kubectl apply -f ./manifests/rbac.yaml

EOF_CP

gcloud compute scp cp.sh gke-tutorial-admin:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

gcloud compute ssh gke-tutorial-admin --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command="bash /tmp/cp.sh"



sleep 10


gcloud compute ssh gke-tutorial-owner --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command='
  sudo apt-get install -y google-cloud-sdk-gke-gcloud-auth-plugin &&
  echo "export USE_GKE_GCLOUD_AUTH_PLUGIN=True" >> ~/.bashrc &&
  source ~/.bashrc &&
  export ZONE=$(curl -s "http://metadata.google.internal/computeMetadata/v1/instance/zone" -H "Metadata-Flavor: Google" | awk -F'/' "{print \$NF}") &&
  gcloud container clusters get-credentials rbac-demo-cluster --zone "$ZONE" &&
  kubectl create -n dev -f ./manifests/hello-server.yaml &&
  kubectl create -n prod -f ./manifests/hello-server.yaml &&
  kubectl create -n test -f ./manifests/hello-server.yaml
'

sleep 10

gcloud compute ssh gke-tutorial-auditor --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command='
  sudo apt-get install -y google-cloud-sdk-gke-gcloud-auth-plugin &&
  echo "export USE_GKE_GCLOUD_AUTH_PLUGIN=True" >> ~/.bashrc &&
  source ~/.bashrc &&
  gcloud container clusters get-credentials rbac-demo-cluster --zone "$ZONE" &&
  kubectl get pods -l app=hello-server --all-namespaces ||
  kubectl get pods -l app=hello-server --namespace=dev &&
  kubectl get pods -l app=hello-server --namespace=test ||
  kubectl get pods -l app=hello-server --namespace=prod ||
  kubectl create -n dev -f manifests/hello-server.yaml ||
  kubectl delete deployment -n dev -l app=hello-server ||
  true
'

sleep 10

gcloud compute ssh gke-tutorial-admin --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command='
  kubectl apply -f manifests/pod-labeler.yaml &&
  kubectl get pods -l app=pod-labeler &&
  kubectl describe pod -l app=pod-labeler | tail -n 20 &&
  kubectl logs -l app=pod-labeler &&
  kubectl get pod -o yaml -l app=pod-labeler &&
  kubectl apply -f manifests/pod-labeler-fix-1.yaml &&
  kubectl get deployment pod-labeler -o yaml
'

sleep 10


gcloud logging read 'protoPayload.methodName="io.k8s.core.v1.pods.patch"' \
  --format="table(timestamp, protoPayload.authenticationInfo.principalEmail, protoPayload.resourceName)"


sleep 10

gcloud compute ssh gke-tutorial-admin --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command='
  kubectl get pods -l app=pod-labeler &&
  kubectl logs -l app=pod-labeler &&
  kubectl get rolebinding pod-labeler -o yaml &&
  kubectl get role pod-labeler -o yaml &&
  kubectl apply -f manifests/pod-labeler-fix-2.yaml'

