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
set -eEuo pipefail

# Install pre-requisites (for Secrets, Fastlane, Flutter).
add-apt-repository ppa:git-core/ppa -y
apt-get -yqq update
apt-get -yqq install \
  jq \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  build-essential \
  curl \
  git \
  unzip \
  xz-utils \
  zip \
  libglu1-mesa

# Install Docker.
# Source: https://docs.docker.com/engine/install/ubuntu/
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list >/dev/null
apt-get update
apt-get -yqq install docker-ce

# Setup runner for Github actions.
ORG="spreeloop"
NAME="${HOSTNAME}"
GITHUB_RUNNERS_TOKEN=$(gcloud secrets versions access latest --secret="GITHUB_RUNNERS_TOKEN")
TOKEN=$(curl -s -X POST -H "authorization: token ${GITHUB_RUNNERS_TOKEN}" "https://api.github.com/orgs/${ORG}/actions/runners/registration-token" | jq -r .token)

## Download runner software.
mkdir /runner && cd /runner
curl -o actions-runner-linux-x64-2.316.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.316.0/actions-runner-linux-x64-2.316.0.tar.gz
echo "64a47e18119f0c5d70e21b6050472c2af3f582633c9678d40cb5bcb852bcc18f  actions-runner-linux-x64-2.316.0.tar.gz" | shasum -a 256 -c
tar xzf ./actions-runner-linux-x64-2.316.0.tar.gz

RUNNER_ALLOW_RUNASROOT=1 /runner/config.sh \
  --url "https://github.com/${ORG}" \
  --token "${TOKEN}" \
  --name "${NAME}" \
  --unattended \
  --replace \
  --work "/runner-tmp" \
  --labels gcp,compute-engine,e2-medium

# Ignore ownership issues on the flutter directory.
git config --system --add safe.directory /runner-tmp/_tool/flutter

## Install and start runner service.
cd /runner || exit
./svc.sh install
./svc.sh start
