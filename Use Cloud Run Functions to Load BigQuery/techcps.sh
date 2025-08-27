

gcloud auth list

export ZONE=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-zone])")

export REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])")

export PROJECT_ID=$(gcloud config get-value project)

gcloud config set compute/region $REGION

gcloud config set run/region $REGION
gcloud config set run/platform managed
gcloud config set eventarc/location $REGION

gcloud services enable \
  artifactregistry.googleapis.com \
  cloudfunctions.googleapis.com \
  cloudbuild.googleapis.com \
  eventarc.googleapis.com \
  run.googleapis.com \
  logging.googleapis.com \
  pubsub.googleapis.com

sleep 60


export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com" \
    --role="roles/eventarc.eventReceiver"

SERVICE_ACCOUNT="$(gcloud storage service-agent --project=$PROJECT_ID)"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:${SERVICE_ACCOUNT}" \
    --role='roles/pubsub.publisher'

cat > index.js <<EOF_CP
/**
* index.js Cloud Function - Avro on GCS to BQ
*/
const {Storage} = require('@google-cloud/storage');
const {BigQuery} = require('@google-cloud/bigquery');

const storage = new Storage();
const bigquery = new BigQuery();

exports.loadBigQueryFromAvro = async (event, context) => {
    try {
        // Check for valid event data and extract bucket name
        if (!event || !event.bucket) {
            throw new Error('Invalid event data. Missing bucket information.');
        }

        const bucketName = event.bucket;
        const fileName = event.name;

        // BigQuery configuration
        const datasetId = 'loadavro';
        const tableId = fileName.replace('.avro', ''); 

        const options = {
            sourceFormat: 'AVRO',
            autodetect: true, 
            createDisposition: 'CREATE_IF_NEEDED',
            writeDisposition: 'WRITE_TRUNCATE',     
        };

        // Load job configuration
        const loadJob = bigquery
            .dataset(datasetId)
            .table(tableId)
            .load(storage.bucket(bucketName).file(fileName), options);

        await loadJob;
        console.log(`Job ${loadJob.id} completed. Created table ${tableId}.`);

    } catch (error) {
        console.error('Error loading data into BigQuery:', error);
        throw error; 
    }
};

EOF_CP

gcloud storage buckets create gs://$PROJECT_ID --location=$REGION

bq mk -d  loadavro


npm install @google-cloud/storage @google-cloud/bigquery

sleep 90


#!/bin/bash

deploy_function() {
     gcloud functions deploy loadBigQueryFromAvro \
     --gen2 \
     --runtime nodejs20 \
     --source . \
     --region $REGION \
     --trigger-resource gs://$PROJECT_ID \
     --trigger-event google.storage.object.finalize \
     --memory=512Mi \
     --timeout=540s \
     --service-account=$PROJECT_NUMBER-compute@developer.gserviceaccount.com 
}
deploy_success=false

while [ "$deploy_success" = false ]; do
  if deploy_function; then
    echo "Function deployed successfully [https://www.youtube.com/@techcps]"
    deploy_success=true
  else
    echo "please subscribe to techcps [https://www.youtube.com/@techcps]"
    sleep 10
  fi
done


gcloud eventarc triggers list --location=$REGION

wget https://storage.googleapis.com/cloud-training/dataengineering/lab_assets/idegc/campaigns.avro

gcloud storage cp campaigns.avro gs://$PROJECT_ID

