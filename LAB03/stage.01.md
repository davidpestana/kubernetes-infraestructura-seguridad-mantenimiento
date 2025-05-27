## 📈 Sesión 3 – Fase 1: Desplegar Prometheus + AlertManager (stack base)

### 🎯 Objetivo

Tener operativa una solución de monitorización básica en Kubernetes con **Prometheus** y **AlertManager**, para recopilar métricas y preparar futuras alertas.

---

### 🧰 Requisitos

* Clúster Kubernetes en ejecución (kind u otro)
* Espacio de trabajo limpio (namespace `monitoring`)
* Acceso a Internet para obtener manifests

---

### 🔧 Pasos

1. Crear un namespace para monitorización:

   ```bash
   kubectl create namespace monitoring
   ```

2. Aplicar el stack básico de Prometheus + AlertManager desde kube-prometheus:

   ```bash
   kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/kube-prometheus/main/manifests/setup
   sleep 10
   kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/kube-prometheus/main/manifests/
   ```

3. Verificar que los pods están corriendo:

   ```bash
   kubectl get pods -n monitoring
   ```

4. Exponer Prometheus y AlertManager (port-forward o ingress provisional):

   ```bash
   kubectl port-forward -n monitoring svc/prometheus-k8s 9090
   kubectl port-forward -n monitoring svc/alertmanager-main 9093
   ```

5. Acceder desde navegador a:

   * [http://localhost:9090](http://localhost:9090) → Prometheus
   * [http://localhost:9093](http://localhost:9093) → AlertManager

---

### 🔥 Retos

* **Crea un ServiceMonitor personalizado para monitorizar un Deployment propio**
  💡 *Tip:* Usa las etiquetas correctas en los pods y define `ServiceMonitor` con el mismo `selector`.

* **Verifica que Prometheus descubre automáticamente los servicios del clúster**
  💡 *Tip:* Ve a **Status → Targets** en la interfaz web de Prometheus.

* **Encuentra una métrica relevante de kubelet y grafícala**
  💡 *Tip:* Intenta con `container_cpu_usage_seconds_total` o `kube_pod_container_status_ready`.

---

### ✅ Validaciones

* Stack de monitorización desplegado y accesible por web
* Targets detectados en Prometheus
* Entendimiento básico del flujo Prometheus → AlertManager
