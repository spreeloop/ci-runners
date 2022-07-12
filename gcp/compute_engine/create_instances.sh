#!/bin/bash

gcloud compute instance-groups managed create runner-e2-medium-group \
    --project=spreeloop-ci-runners \
    --size=2 \
    --base-instance-name=gce-runner \
    --template=gh-runner-e2-medium-template \
    --zone=us-central1-a
