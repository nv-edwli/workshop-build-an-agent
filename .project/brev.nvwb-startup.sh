#!/bin/bash

sudo -i -u ubuntu bash << 'EOF'
# Download NVIDIA AI Workbench
mkdir -p $HOME/.nvwb/bin
curl -L https://workbench.download.nvidia.com/stable/workbench-cli/$(curl -L -s https://workbench.download.nvidia.com/stable/workbench-cli/LATEST)/nvwb-cli-$(uname)-$(uname -m) --output $HOME/.nvwb/bin/nvwb-cli
chmod +x $HOME/.nvwb/bin/nvwb-cli
ln -sf $HOME/.nvwb/bin/nvwb-cli $HOME/.nvwb/bin/nvwb

# Install NVIDIA AI Workbench
sudo $HOME/.nvwb/bin/nvwb-cli install --noninteractive --accept --docker --drivers --uid 1000 --gid 1000
export PATH="$HOME/.nvwb/bin:$PATH"

# Clone and build workshop
nvwb activate local
nvwb clone project https://github.com/nv-edwli/workshop-build-an-agent --context local
EOF