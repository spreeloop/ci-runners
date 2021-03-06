#!/bin/bash
# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Get GITHUB_RUNNERS_TOKEN secret.
ORG="spreeloop"
NAME="${HOSTNAME}"
GITHUB_RUNNERS_TOKEN=$(gcloud secrets versions access latest --secret="GITHUB_RUNNERS_TOKEN")
TOKEN=$(curl -s -X POST -H "authorization: token ${GITHUB_RUNNERS_TOKEN}" "https://api.github.com/orgs/${ORG}/actions/runners/registration-token" | jq -r .token)

# Stop and uninstall the runner service.
cd /runner || exit
./svc.sh stop
./svc.sh uninstall

# Remove the runner configuration.
RUNNER_ALLOW_RUNASROOT=1 /runner/config.sh remove \
  --token "${TOKEN}"
