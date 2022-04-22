#!/bin/bash

gcloud compute instance-groups managed create runner-micro-group \
    --project=spreeloop-ci-runners \
    --size=2 \
    --base-instance-name=gce-runner \
    --template=gh-runner-micro-template \
    --zone=us-central1-a
