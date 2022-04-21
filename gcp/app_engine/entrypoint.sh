#!/usr/bin/env bash
set -eEuo pipefail

FLUTTER_SDK_VERSION="2.10.4"
OWNER="spreeloop"
REPO="place"
NAME="gcp-app-engine-elastic"
GITHUB_RUNNERS_TOKEN=$(gcloud secrets versions access latest --secret="GITHUB_RUNNERS_TOKEN")
TOKEN=$(curl -s -X POST -H "authorization: token ${GITHUB_RUNNERS_TOKEN}" "https://api.github.com/repos/${OWNER}/${REPO}/actions/runners/registration-token" | jq -r .token)

cleanup() {
  ./config.sh remove --token "${TOKEN}"
}

./config.sh \
  --url "https://github.com/${OWNER}/${REPO}" \
  --token "${TOKEN}" \
  --name "${NAME}" \
  --unattended \
  --work _work \
  --labels python,flutter,flutter-${FLUTTER_SDK_VERSION},gcp,app-engine

./runsvc.sh

cleanup
