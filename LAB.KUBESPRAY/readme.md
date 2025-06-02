## Laboratorio 01: Despliegue de clúster Kubernetes con Kubespray

🎯 **Objetivo general**

Desplegar un clúster de Kubernetes de 3 nodos usando Kubespray desde una máquina de control (nodo Ansible), empleando máquinas virtuales creadas con Vagrant.

---

🧰 **Requisitos previos**

- Vagrant y VirtualBox instalados
- Git, curl, Python3 y pip en el sistema host
- Conexión a Internet

---

🛠️ **Archivos proporcionados**

- `Vagrantfile` con definición de:
  - Nodo de control (Ansible): 192.168.56.10
  - Nodo Kubernetes 1: 192.168.56.11
  - Nodo Kubernetes 2: 192.168.56.12
  - Nodo Kubernetes 3: 192.168.56.13

---

🔬 **Fases del laboratorio**

### Fase 1: Provisionamiento de máquinas virtuales

🎯 **Objetivo:** Tener todas las VMs disponibles con conectividad entre sí.

🔧 **Pasos:**

1. Iniciar el entorno:

```bash
vagrant up
```

2. Verificar conectividad entre nodos:

```bash
vagrant ssh ansible
ping -c 3 node1
ping -c 3 node2
ping -c 3 node3
```

🔥 **Reto:** Cambiar el Vagrantfile para usar Ubuntu 20.04 y reducir RAM a 1024 MiB por nodo.

---

### Fase 2: Instalación de herramientas en el nodo de control

🎯 **Objetivo:** Preparar el nodo Ansible con Kubespray, Ansible y kubectl.

🔧 **Pasos (en `provision/ansible.sh` o manualmente dentro de la VM):**

```bash
sudo apt-get update
sudo apt-get install -y python3-pip git curl
pip3 install --upgrade pip
pip3 install ansible

# Instalar kubectl (última versión)
KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
curl -LO "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Clonar Kubespray y preparar entorno
cd /home/vagrant
git clone https://github.com/kubernetes-sigs/kubespray.git
cd kubespray
git checkout v2.24.0
pip3 install -r requirements.txt
cp -rfp inventory/sample inventory/mycluster
```

🔥 **Reto:** Automatizar toda esta fase en el script `provision/ansible.sh`.

---

### Fase 3: Configuración del inventario de Kubespray

🎯 **Objetivo:** Configurar el archivo `inventory/mycluster/hosts.yaml` con las IPs de los nodos.

🔧 **Ejemplo de archivo:**

```yaml
all:
  hosts:
    node1:
      ansible_host: 192.168.56.11
    node2:
      ansible_host: 192.168.56.12
    node3:
      ansible_host: 192.168.56.13
  children:
    kube_control_plane:
      hosts:
        node1:
    kube_node:
      hosts:
        node2:
        node3:
    etcd:
      hosts:
        node1:
        node2:
        node3:
    k8s_cluster:
      children:
        kube_control_plane:
        kube_node:
```

🔥 **Reto:** Configurar `kubeconfig_localhost: false` para que el `admin.conf` se copie al nodo de control.

---

### Fase 4: Despliegue del clúster con Ansible

🎯 **Objetivo:** Ejecutar Kubespray para desplegar Kubernetes.

🔧 **Pasos:**

```bash
cd /home/vagrant/kubespray
ansible-playbook -i inventory/mycluster/hosts.yaml -u vagrant --become cluster.yml
```

📝 Añadir `--private-key=~/.ssh/id_rsa` si estás fuera de Vagrant.

🔥 **Reto:** Usar etiquetas para repetir solo partes fallidas: `--tags=kubernetes-apps`

---

### Fase 5: Acceso al clúster con kubectl

🎯 **Objetivo:** Validar que `kubectl` puede interactuar con el clúster.

🔧 **Pasos:**

```bash
mkdir -p ~/.kube
cp /home/vagrant/kubespray/inventory/mycluster/artifacts/admin.conf ~/.kube/config
kubectl get nodes
```

🔥 **Reto:** Acceder desde el host usando `scp` para traer `admin.conf` desde la VM.

---

✅ **Validaciones finales**

- `vagrant ssh ansible` → `kubectl get nodes` devuelve los 3 nodos.
- El clúster tiene roles bien definidos (control plane, worker).
- Se ha desplegado sin errores.
- Puedes lanzar un pod y exponer un servicio.