### Fase 4: Añadir reglas de alerta y testearlas

---

### 🎯 Objetivo

Definir reglas de alerta específicas para el microservicio desplegado y validar su funcionamiento forzando condiciones controladas que las disparen.

---

### 🧰 Requisitos

* Microservicio desplegado en el namespace `demo`
* Prometheus y AlertManager operativos
* Permisos para crear `PrometheusRule` en el namespace de monitorización

---

### 🔧 Pasos

1. Crear un archivo con la regla de alerta para reinicios frecuentes:

   ```yaml
   kubectl apply -n monitoring -f - <<EOF
   apiVersion: monitoring.coreos.com/v1
   kind: PrometheusRule
   metadata:
     name: demo-app-alerts
   spec:
     groups:
     - name: demo.rules
       rules:
       - alert: HighRestartRate
         expr: increase(kube_pod_container_status_restarts_total{namespace="demo"}[2m]) > 2
         for: 1m
         labels:
           severity: warning
         annotations:
           summary: "Reinicios excesivos en microservicio"
           description: "El pod {{ $labels.pod }} se ha reiniciado más de dos veces en 2 minutos"
   EOF
   ```

2. Provocar reinicios manuales:

   ```bash
   kubectl rollout restart deployment nginx-demo -n demo
   ```

3. Esperar al menos 1 minuto y verificar que la alerta aparece:

   * [http://localhost:9090](http://localhost:9090) → Alerts
   * [http://localhost:9093](http://localhost:9093) → AlertManager

4. Opcional: revisar métricas en Prometheus:

   ```promql
   increase(kube_pod_container_status_restarts_total{namespace="demo"}[2m])
   ```

5. Comprobar que AlertManager recibe y agrupa las notificaciones correctamente.

---

### 🔥 Retos

* **Modifica la expresión para que alerte solo si ocurre en pods con el label `app=nginx-demo`**
  💡 Añade `app="nginx-demo"` al filtro de la métrica.

* **Configura una alerta por fallo en `readinessProbe` o `CrashLoopBackOff`**
  💡 Usa `kube_pod_container_status_ready == 0`.

* **Simula un falso positivo e inspecciona cómo evitarlo con `for:` en la regla**
  💡 Ajusta el tiempo para evitar alertas transitorias.

---

### ✅ Validaciones

* La alerta se dispara correctamente al reiniciar los pods
* Se visualiza tanto en Prometheus como en AlertManager
* Se entiende cómo se construye y prueba una regla de alerta basada en métricas reales
