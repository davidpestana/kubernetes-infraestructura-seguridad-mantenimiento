### Fase 3: Probar notificaciones y simular condiciones

---

### 🎯 Objetivo

Validar que las alertas configuradas en Prometheus se propagan correctamente a AlertManager y probar la reacción ante condiciones reales o simuladas.

---

### 🧰 Requisitos

* Reglas de alerta activas (Fase 2 completada)
* Prometheus y AlertManager accesibles localmente
* Conocimiento básico de `kubectl`, métricas y pods en ejecución

---

### 🔧 Pasos

1. Comprobar si las alertas configuradas están en estado `firing`:

   ```bash
   kubectl port-forward -n monitoring svc/prometheus-k8s 9090
   # Accede a http://localhost:9090 → Alerts
   ```

2. Confirmar que AlertManager recibe las notificaciones:

   ```bash
   kubectl port-forward -n monitoring svc/alertmanager-main 9093
   # Accede a http://localhost:9093
   ```

3. Simular un fallo: eliminar un pod del sistema o dejarlo sin readiness

   ```bash
   kubectl delete pod cpu-loader -n monitoring
   ```

4. Lanzar un pod con `readinessProbe` que falle:

   ```yaml
   kubectl apply -n monitoring -f - <<EOF
   apiVersion: v1
   kind: Pod
   metadata:
     name: failing-probe
   spec:
     containers:
     - name: web
       image: nginx
       readinessProbe:
         httpGet:
           path: /fail
           port: 80
         initialDelaySeconds: 5
         periodSeconds: 5
   EOF
   ```

5. Esperar que Prometheus detecte el cambio y dispare alertas basadas en readiness o estado de contenedor.

---

### 🔥 Retos

* **Simula una condición de `OutOfMemory` matando un proceso**
  💡 Lanza un pod con consumo de memoria creciente.

* **Crea una regla para alertar si el número de pods en CrashLoopBackOff es mayor que 0**
  💡 Usa la métrica `kube_pod_container_status_restarts_total`.

* **Prueba con una regla basada en `kube_node_status_condition` para detectar nodos no listos**
  💡 Usa `kube_node_status_condition{condition="Ready",status="false"}`.

---

### ✅ Validaciones

* Las alertas cambian automáticamente de estado al simular condiciones
* AlertManager refleja el estado y detalles de la alerta
* Se ha generado al menos una condición realista que dispara la lógica definida en las reglas
