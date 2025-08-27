

gcloud auth list

export REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])")


gcloud services enable cloudbuild.googleapis.com artifactregistry.googleapis.com


cat > quickstart.sh <<EOF_CP
#!/bin/sh
echo "Hello, world! The time is \$(date)."
EOF_CP


cat > Dockerfile <<EOF_CP
FROM alpine
COPY quickstart.sh /
CMD ["/quickstart.sh"]
EOF_CP


chmod +x quickstart.sh


gcloud artifacts repositories create quickstart-docker-repo --repository-format=docker \
    --location="$REGION" --description="Docker repository"


gcloud builds submit --tag "$REGION"-docker.pkg.dev/${DEVSHELL_PROJECT_ID}/quickstart-docker-repo/quickstart-image:tag1


cat > cloudbuild.yaml <<EOF_CP
steps:
- name: 'gcr.io/cloud-builders/docker'
  args: [ 'build', '-t', 'YourRegionHere-docker.pkg.dev/\$PROJECT_ID/quickstart-docker-repo/quickstart-image:tag1', '.' ]
images:
- 'YourRegionHere-docker.pkg.dev/\$PROJECT_ID/quickstart-docker-repo/quickstart-image:tag1'
EOF_CP

echo $REGION
sed -i "s/YourRegionHere/$REGION/g" cloudbuild.yaml

cat cloudbuild.yaml

gcloud builds submit --config cloudbuild.yaml


cat > quickstart.sh <<EOF_CP
#!/bin/sh
if [ -z "$1" ]
then
	echo "Hello, world! The time is $(date)."
	exit 0
else
	exit 1
fi
EOF_CP


cat > cloudbuild2.yaml <<EOF_CP
steps:
- name: 'gcr.io/cloud-builders/docker'
  args: [ 'build', '-t', 'YourRegionHere-docker.pkg.dev/\$PROJECT_ID/quickstart-docker-repo/quickstart-image:tag1', '.' ]
- name: 'YourRegionHere-docker.pkg.dev/\$PROJECT_ID/quickstart-docker-repo/quickstart-image:tag1'
  args: ['fail']
images:
- 'YourRegionHere-docker.pkg.dev/\$PROJECT_ID/quickstart-docker-repo/quickstart-image:tag1'
EOF_CP


sed -i "s/YourRegionHere/$REGION/g" cloudbuild2.yaml


cat cloudbuild2.yaml

gcloud builds submit --config cloudbuild2.yaml
