#!/usr/bin/env bash
set -eEuo pipefail

ORG="spreeloop"
NAME="gae-runner-elastic"
GITHUB_RUNNERS_TOKEN=$(gcloud secrets versions access latest --secret="GITHUB_RUNNERS_TOKEN")

TOKEN=$(curl -s -X POST -H "authorization: token ${GITHUB_RUNNERS_TOKEN}" "https://api.github.com/orgs/${ORG}/actions/runners/registration-token" | jq -r .token)

cleanup() {
  ./config.sh remove --token "${TOKEN}"
}

./config.sh \
  --url "https://github.com/${ORG}" \
  --token "${TOKEN}" \
  --name "${NAME}" \
  --unattended \
  --work _work \
  --labels gcp,app-engine,standard

./runsvc.sh

cleanup
