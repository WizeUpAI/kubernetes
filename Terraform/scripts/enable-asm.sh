#!/bin/bash
PROJECT_ID=$1
CLUSTER_NAME=$2
CLUSTER_LOCATION=$3

gcloud services enable mesh.googleapis.com --project=$PROJECT_ID

gcloud container clusters get-credentials $CLUSTER_NAME --region $CLUSTER_LOCATION --project $PROJECT_ID

curl https://storage.googleapis.com/csm-artifacts/asm/asmcli > asmcli
chmod +x asmcli

./asmcli install   --project_id $PROJECT_ID   --cluster_name $CLUSTER_NAME   --cluster_location $CLUSTER_LOCATION   --output_dir asm-output   --enable_all   --ca mesh_ca