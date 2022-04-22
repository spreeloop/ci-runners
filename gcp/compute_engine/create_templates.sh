#!/bin/bash

gcloud compute instance-templates create gh-runner-micro-template \
    --project=spreeloop-ci-runners \
    --image-family=ubuntu-1804-lts \
    --image-project=ubuntu-os-cloud \
    --boot-disk-type=pd-ssd \
    --boot-disk-size=10GB \
    --machine-type=e2-micro \
    --scopes=cloud-platform \
    --metadata-from-file=startup-script=startup.sh,shutdown-script=shutdown.sh
