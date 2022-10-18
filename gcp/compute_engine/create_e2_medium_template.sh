#!/bin/bash

gcloud compute instance-templates create gh-runner-e2-medium-50gb-template \
    --project=spreeloop-ci-runners \
    --image-family=ubuntu-1804-lts \
    --image-project=ubuntu-os-cloud \
    --boot-disk-type=pd-balanced \
    --boot-disk-size=50GB \
    --machine-type=e2-medium \
    --scopes=cloud-platform \
    --metadata-from-file=startup-script=startup.sh,shutdown-script=shutdown.sh
