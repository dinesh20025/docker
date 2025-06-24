FROM ubuntu:latest

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)

# Use root user to install the prerequisites we need
USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    unzip \
    gnupg \
    software-properties-common  \
    zip \
    sudo \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Install Docker
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    lsb-release && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io && \
    rm -rf /var/lib/apt/lists/*

# Install python and system dependencies for cryptography
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-pip python3-wheel \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip && \
    pip install --no-cache-dir --upgrade cryptography azure-core

RUN python3 --version; \
    pip list

# Create a new non-root user and switch to it
USER 1003

# Agent specific
ENV docker=true
ENV agent_flavor=docker
