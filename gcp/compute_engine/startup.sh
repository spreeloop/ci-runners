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
curl -o actions-runner-linux-x64-2.290.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.290.1/actions-runner-linux-x64-2.290.1.tar.gz
echo "2b97bd3f4639a5df6223d7ce728a611a4cbddea9622c1837967c83c86ebb2baa  actions-runner-linux-x64-2.290.1.tar.gz" | shasum -a 256 -c
tar xzf ./actions-runner-linux-x64-2.290.1.tar.gz

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
git config --system --add safe.directory /runner-tmp/_tool/flutter/stable-3.3.10-x64
git config --global --add safe.directory /runner-tmp/_tool/flutter
git config --global --add safe.directory /runner-tmp/_tool/flutter/stable-3.3.10-x64

## Install and start runner service.
cd /runner || exit
./svc.sh install
./svc.sh start
