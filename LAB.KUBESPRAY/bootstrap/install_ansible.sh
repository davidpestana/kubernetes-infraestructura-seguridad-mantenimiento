#!/bin/bash
set -eux

# Instala dependencias
sudo apt-get update
sudo apt-get install -y python3-pip git

# Instala Ansible
pip3 install --upgrade pip
pip3 install ansible

# Instala kubectl desde binario oficial
KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
curl -LO "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/


# Clona Kubespray
cd /home/vagrant
if [ ! -d kubespray ]; then
  git clone https://github.com/kubernetes-sigs/kubespray.git
  cd kubespray
  git checkout v2.24.0  # O la versión deseada
  pip3 install -r requirements.txt
fi

chown -R vagrant:vagrant /home/vagrant/kubespray
