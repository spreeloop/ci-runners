FROM ubuntu:18.04

ENV RUNNER_VERSION=2.290.1
ENV FLUTTER_SDK_VERSION=2.10.4

RUN useradd -m actions
RUN apt-get -yqq update && apt-get install -yqq curl jq wget git

# Install Python3.8.
RUN apt-get install -yqq python
ENV PATH $PATH:/usr/local/bin/python
RUN python --version

# Install gcloud CLI.
## Download the gcloud package.
RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz

## Install the package
RUN mkdir -p /usr/local/gcloud \
  && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
  && /usr/local/gcloud/google-cloud-sdk/install.sh --quiet

## Add the package path to local.
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

# Install Dart, FVM & Flutter.
RUN apt-get install -yqq apt-transport-https ca-certificates gnupg unzip
RUN wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/dart.gpg
RUN echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | tee /etc/apt/sources.list.d/dart_stable.list
RUN apt-get -yqq update && apt-get install dart
ENV PATH $PATH:$HOME/.pub-cache/bin
RUN dart pub global activate fvm
ENV PATH $PATH:$HOME/fvm/default/bin
RUN $HOME/.pub-cache/bin/fvm install ${FLUTTER_SDK_VERSION}
RUN $HOME/.pub-cache/bin/fvm global ${FLUTTER_SDK_VERSION}

RUN \
  LABEL="$(curl -s -X GET 'https://api.github.com/repos/actions/runner/releases/latest' | jq -r '.tag_name')" \
  RUNNER_VERSION="$(echo ${latest_version_label:1})" \
  cd /home/actions && mkdir actions-runner && cd actions-runner \
  && wget https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
  && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

WORKDIR /home/actions/actions-runner
RUN chown -R actions ~actions && /home/actions/actions-runner/bin/installdependencies.sh

USER actions
COPY entrypoint.sh .
COPY runsvc.sh .
ENTRYPOINT ["./entrypoint.sh"]
