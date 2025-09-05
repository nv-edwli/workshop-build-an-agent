#!/bin/bash

sudo -i -u ubuntu bash << 'EOF'
readonly GIT_REPO=https://github.com/nv-edwli/workshop-build-an-agent
readonly TARGET_BRANCH=develop
readonly TARGET_APPLICATION=DevX-Lab

# Download NVIDIA AI Workbench
mkdir -p $HOME/.nvwb/bin
curl -L https://workbench.download.nvidia.com/stable/workbench-cli/$(curl -L -s https://workbench.download.nvidia.com/stable/workbench-cli/LATEST)/nvwb-cli-$(uname)-$(uname -m) --output $HOME/.nvwb/bin/nvwb-cli
chmod +x $HOME/.nvwb/bin/nvwb-cli
ln -sf $HOME/.nvwb/bin/nvwb-cli $HOME/.nvwb/bin/nvwb

# Install NVIDIA AI Workbench
sudo $HOME/.nvwb/bin/nvwb-cli install --noninteractive --accept --docker --drivers --uid 1000 --gid 1000
export PATH="$HOME/.nvwb/bin:$PATH"

# Clone workshop, avoid default branch build
nvwb activate local
nvwb clone project $GIT_REPO --context local
nvwb switch-branch $TARGET_BRANCH --context local --project $HOME/nvidia-workbench/*-build-an-agent
nvwb build --context local --project $HOME/nvidia-workbench/*-build-an-agent
nvwb start $TARGET_APPLICATION --context local --project $HOME/nvidia-workbench/*-build-an-agent
EOF
