# Focal missing package for gcloud.
# FROM ubuntu:focal
FROM ubuntu:bionic
MAINTAINER Grow SDK Authors <hello@grow.io>

ARG grow_version
RUN echo "Grow: $grow_version"

# Set environment variables.
ENV TERM=xterm
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt-get update \
  && apt-get install -y --no-install-recommends curl ca-certificates software-properties-common \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Source and install.
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
  && echo "deb http://packages.cloud.google.com/apt cloud-sdk-$(lsb_release -c -s) main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
  && add-apt-repository ppa:deadsnakes/ppa \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    python3.8 python3-pip python3-setuptools python3-all-dev python3-lxml python3-libxml2 \
    nodejs build-essential zip libc6 nano \
    libyaml-dev libffi-dev libxml2-dev libxslt-dev libssl-dev \
    git ssh google-cloud-sdk ruby ruby-dev yarn \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Update npm and install packages.
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/`curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")'`/install.sh | bash \
  && . ~/.bashrc \
  && npm install -g npm@latest \
  && yarn global add node-sass \
  && yarn global add gulp \
  && yarn cache clean

# Install Grow.
RUN pip3 install --no-cache-dir --upgrade wheel \
  && pip3 install --no-cache-dir grow==$grow_version

# Install ruby bundle.
RUN gem install bundler

# Confirm versions that are installed.
RUN echo "Grow: `grow --version`" \
  && echo "Node: `node -v`" \
  && echo "NPM: `npm -v`" \
  && echo "NVM: `nvm --version`" \
  && echo "Yarn: `yarn --version`" \
  && echo "Gulp: `gulp -v`" \
  && echo "GCloud: `gcloud -v`" \
  && echo "Ruby: `ruby -v`"
