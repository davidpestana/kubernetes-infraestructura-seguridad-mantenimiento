# Laboratorio 03: Monitorización y gestión de alertas en Kubernetes

## 🎯 Objetivo general

Desplegar herramientas de monitorización y alertado (Prometheus, AlertManager), generar alertas básicas y analizar eventos mediante logs. El objetivo es comprender cómo observar el estado del clúster y reaccionar ante fallos.

## 🧰 Requisitos previos

* Clúster local en ejecución (kind o real)
* `kubectl`, `helm`, `stern` instalados
* Acceso a Internet desde los nodos para descarga de charts

---

## 🔬 Fases del laboratorio

### Fase 1: Despliegue del stack Prometheus + AlertManager

**🎯 Objetivo:** Tener Prometheus y AlertManager operativos en el clúster.

**🔧 Pasos:**

1. Añadir el repo de Helm:

   ```bash
   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
   helm repo update
   ```
2. Crear namespace:

   ```bash
   kubectl create namespace monitoring
   ```
3. Instalar Prometheus stack:

   ```bash
   helm install prom prometheus-community/kube-prometheus-stack -n monitoring
   ```
4. Esperar a que todos los pods estén en estado Running.

**🔥 Retos:**

* Verifica los endpoints de Prometheus y AlertManager con `kubectl port-forward`
* Accede a las interfaces web desde localhost

---

### Fase 2: Creación de alertas por estado de pods y uso de CPU

**🎯 Objetivo:** Aprender a crear reglas de alerta básicas en Prometheus.

**🔧 Pasos:**

1. Localiza el `prometheus-prometheus-rulefiles` ConfigMap generado.
2. Crea un nuevo archivo con reglas personalizadas:

   ```yaml
   groups:
   - name: custom.rules
     rules:
     - alert: HighPodRestart
       expr: rate(kube_pod_container_status_restarts_total[5m]) > 0.1
       for: 1m
       labels:
         severity: warning
       annotations:
         summary: "Alerta: Reinicios altos en pods"
         description: "{{ $labels.pod }} ha reiniciado más de una vez por minuto."
   ```
3. Aplica el archivo mediante un nuevo ConfigMap y reinicia Prometheus si es necesario.

**🔥 Retos:**

* Forzar una alerta haciendo que un pod falle
* Comprobar si aparece en AlertManager

---

### Fase 3: Simulación de condiciones anómalas

**🎯 Objetivo:** Generar condiciones que disparen las alertas.

**🔧 Pasos:**

1. Desplegar un pod que falle de forma intencional:

   ```bash
   kubectl run failer --image=busybox --restart=Never --command -- sh -c "exit 1"
   ```
2. Repetirlo o hacer loops para generar eventos frecuentes.

**🔥 Retos:**

* Dejar corriendo una carga que agote CPU o memoria
* Ver cómo reacciona Prometheus

---

### Fase 4: Revisión de logs y eventos con stern y kubectl

**🎯 Objetivo:** Ver los logs de pods con problemas y correlacionarlos con alertas.

**🔧 Pasos:**

1. Usar `stern` para ver logs en tiempo real:

   ```bash
   stern failer
   ```
2. Revisar eventos del pod:

   ```bash
   kubectl describe pod failer
   ```
3. Eliminar el pod para limpiar el entorno:

   ```bash
   kubectl delete pod failer
   ```

**🔥 Retos:**

* Comprobar timestamps de logs frente a tiempos de alerta
* Ver cómo se actualiza la interfaz de Prometheus

---

## ✅ Validaciones finales

* Prometheus y AlertManager están desplegados y accesibles
* Se han generado alertas personalizadas
* Se han producido fallos y correlacionado eventos/logs
* El alumno entiende cómo interpretar las métricas
