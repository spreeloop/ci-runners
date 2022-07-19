#!/bin/bash

gcloud compute instance-templates create gh-runner-e2-small-template \
    --project=spreeloop-ci-runners \
    --image-family=ubuntu-1804-lts \
    --image-project=ubuntu-os-cloud \
    --boot-disk-type=pd-ssd \
    --boot-disk-size=20GB \
    --machine-type=e2-small \
    --scopes=cloud-platform \
    --metadata-from-file=startup-script=startup.sh,shutdown-script=shutdown.sh
