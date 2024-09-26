#!/bin/bash

gcloud compute instance-templates create gh-runner-e2-medium-50gb-sep-e-2024 \
    --project=spreeloop-ci-runners \
    --image-family=ubuntu-2204-lts \
    --image-project=ubuntu-os-cloud \
    --boot-disk-type=pd-balanced \
    --boot-disk-size=50GB \
    --machine-type=e2-medium \
    --scopes=https://www.googleapis.com/auth/cloud-platform \
    --service-account=gh-runners@spreeloop-ci-runners.iam.gserviceaccount.com \
    --metadata-from-file=startup-script=startup.sh,shutdown-script=shutdown.sh
