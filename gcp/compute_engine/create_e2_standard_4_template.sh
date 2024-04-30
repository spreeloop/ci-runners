#!/bin/bash

gcloud compute instance-templates create gh-runner-e2-standard-4-50gb-template \
    --project=spreeloop-ci-runners \
    --image-family=ubuntu-2004-lts \
    --image-project=ubuntu-os-cloud \
    --boot-disk-type=pd-balanced \
    --boot-disk-size=50GB \
    --machine-type=e2-standard-4 \
    --scopes=cloud-platform \
    --metadata-from-file=startup-script=startup.sh,shutdown-script=shutdown.sh
