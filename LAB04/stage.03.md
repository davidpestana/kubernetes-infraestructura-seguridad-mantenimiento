### Fase 3: Simular fallo de nodo en entorno VM (Hyper-V)

---

### 🎯 Objetivo

Simular una situación de fallo en un nodo del clúster para observar cómo Kubernetes responde y maneja la alta disponibilidad mediante redistribución y reprogramación de pods.

---

### 🧰 Requisitos

* Clúster distribuido en VMs o entorno Hyper-V
* Mínimo 2 nodos configurados
* Acceso al hipervisor (Hyper-V, VirtualBox, Proxmox, etc.)

---

### 🔧 Pasos

1. Verificar distribución de pods por nodo:

   ```bash
   kubectl get pods -o wide
   ```

2. Identificar el nodo que se apagará:

   ```bash
   kubectl get nodes -o wide
   ```

3. Simular fallo: detener la VM del nodo seleccionado desde el hipervisor (no usar `kubectl drain`).

4. Esperar entre 30s y 2m y comprobar eventos:

   ```bash
   kubectl get nodes
   kubectl describe node <nombre-del-nodo>
   kubectl get pods -o wide
   ```

5. Verificar si los pods afectados han sido reprogramados en los nodos restantes.

6. Reiniciar la VM desde el hipervisor y comprobar si el nodo vuelve a estado `Ready`.

---

### 🔥 Retos

* **Simula el fallo de varios nodos simultáneamente y mide el impacto**
  💡 Observa si el clúster logra reprogramar los pods o si se bloquea por falta de capacidad.

* **Relaciona los eventos del clúster con las alertas disparadas por el fallo**
  💡 Usa `kubectl get events` y revisa Prometheus/AlertManager.

* **Crea un Deployment tolerante a fallos mediante PodDisruptionBudgets y replicas distribuidas**
  💡 Asegura que no todo quede en un único nodo.

---

### ✅ Validaciones

* Al detener un nodo, su estado pasa a `NotReady` o desaparece temporalmente
* Los pods del nodo fallido se reprograman en otros nodos (si hay capacidad)
* El nodo vuelve a estado `Ready` tras el reinicio
* Se observa el comportamiento de alta disponibilidad básico en Kubernetes
