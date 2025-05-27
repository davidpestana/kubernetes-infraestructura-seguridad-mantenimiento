### Fase 2: Crear alertas por estado de pods y CPU

---

### 🎯 Objetivo

Configurar reglas de alerta en Prometheus para detectar condiciones críticas y recibirlas en AlertManager.

---

### 🧰 Requisitos

* Prometheus y AlertManager desplegados (Fase 1 completada)
* Acceso a editar `PrometheusRule` o agregar uno nuevo
* Conexión activa con el clúster

---

### 🔧 Pasos

1. Crear un archivo `example-alerts.yaml` con una regla básica:

   ```yaml
   apiVersion: monitoring.coreos.com/v1
   kind: PrometheusRule
   metadata:
     name: example-alerts
     namespace: monitoring
   spec:
     groups:
     - name: example.rules
       rules:
       - alert: HighPodCPU
         expr: rate(container_cpu_usage_seconds_total{container!="",namespace!="",pod!=""}[1m]) > 0.2
         for: 1m
         labels:
           severity: warning
         annotations:
           summary: "Pod high CPU usage"
           description: "Pod {{ $labels.pod }} is using high CPU"
   ```

2. Aplicar el archivo:

   ```bash
   kubectl apply -f example-alerts.yaml
   ```

3. Acceder a Prometheus → pestaña **Alerts** → comprobar que la alerta aparece como “inactive”.

4. Forzar la condición de CPU con un pod que haga trabajo intensivo:

   ```bash
   kubectl run cpu-loader --image=busybox --restart=Never -n monitoring -- /bin/sh -c "while true; do :; done"
   ```

5. Esperar más de 1 minuto y revisar si la alerta cambia a "firing".

6. Comprobar en [http://localhost:9093](http://localhost:9093) (AlertManager) si se recibe la alerta.

---

### 🔥 Retos

* **Ajustar la regla para que solo dispare en un namespace concreto**
  💡 Añade `namespace="mynamespace"` al selector `expr`.

* **Crear otra regla para detectar pods no ready**
  💡 Usa la métrica `kube_pod_container_status_ready == 0`.

* **Modificar la severidad y agrupar por aplicación**
  💡 Cambia `labels.severity` a `critical` y usa `labels.app`.

---

### ✅ Validaciones

* Alerta aparece en Prometheus en estado “pending” o “firing”
* AlertManager la recibe correctamente
* Se entiende la relación entre métricas, reglas y notificaciones
