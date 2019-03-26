#!/bin/bash 

## crea un cluster en gke 
##
set -euo pipefail

export CLUSTER=conjur-cluster
export ZONE=us-central1-a

gcloud container clusters create "$CLUSTER" --zone "$ZONE"
gcloud container clusters get-credentials "$CLUSTER" --zone "$ZONE"
