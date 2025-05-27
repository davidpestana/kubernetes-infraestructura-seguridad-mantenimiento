### Fase 5: Introducir fallo controlado y revisar logs + métricas

---

### 🎯 Objetivo

Simular un fallo en el microservicio desplegado para comprobar la reacción del clúster, revisar los logs del pod y validar si las alertas y métricas reflejan correctamente el problema.

---

### 🧰 Requisitos

* Microservicio desplegado y accesible
* Stack de monitorización Prometheus + AlertManager operativo
* Acceso a `kubectl`, `stern`, y Prometheus

---

### 🔧 Pasos

1. Modificar el Deployment para provocar un fallo en el contenedor:

   ```bash
   kubectl patch deployment nginx-demo -n demo \
     --type=json -p='[{"op": "add", "path": "/spec/template/spec/containers/0/command", "value": ["sh", "-c", "exit 1"]}]'
   ```

2. Esperar que los pods entren en estado `CrashLoopBackOff`:

   ```bash
   kubectl get pods -n demo
   ```

3. Consultar los eventos generados:

   ```bash
   kubectl describe pod <nombre-del-pod> -n demo
   kubectl get events -n demo
   ```

4. Visualizar los logs con `kubectl logs` o `stern`:

   ```bash
   kubectl logs <nombre-del-pod> -n demo --previous
   stern nginx-demo -n demo
   ```

5. Comprobar si se dispara una alerta en Prometheus:

   * Ir a `http://localhost:9090/alerts`
   * Buscar condiciones relacionadas con `CrashLoopBackOff`, `container_restarts`, etc.

6. Revertir el cambio si se desea restaurar el servicio:

   ```bash
   kubectl rollout undo deployment nginx-demo -n demo
   ```

---

### 🔥 Retos

* **Configura una alerta basada en la métrica `kube_pod_container_status_restarts_total`**
  💡 Activa si un pod reinicia más de 3 veces en 5 minutos.

* **Compara los eventos y logs para ver qué parte detectó primero el fallo**
  💡 Usa `kubectl get events` ordenados por timestamp.

* **Crea un panel temporal en Prometheus que grafique los reinicios del pod**
  💡 Usa la expresión `rate(kube_pod_container_status_restarts_total[5m])`.

---

### ✅ Validaciones

* El fallo se refleja en el estado del pod y en los logs
* Los eventos capturan el error y lo relacionan con el ciclo de vida del contenedor
* Las métricas y alertas reflejan el problema de forma visible y trazable
