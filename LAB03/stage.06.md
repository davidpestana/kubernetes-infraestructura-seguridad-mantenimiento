### Fase 6: Correlación entre alertas y eventos

---

### 🎯 Objetivo

Establecer una relación clara entre los eventos del clúster, los logs de los pods y las alertas generadas por Prometheus para comprender el flujo de detección y diagnóstico.

---

### 🧰 Requisitos

* Alertas activas en Prometheus
* `kubectl`, `stern` y acceso a Prometheus/AlertManager
* Experiencia previa con eventos (`kubectl get events`)

---

### 🔧 Pasos

1. Visualizar las alertas disparadas:

   ```bash
   kubectl port-forward -n monitoring svc/prometheus-k8s 9090
   # Visitar http://localhost:9090 → pestaña Alerts
   ```

2. En paralelo, obtener eventos recientes del clúster:

   ```bash
   kubectl get events --sort-by=.metadata.creationTimestamp -A
   ```

3. Filtrar eventos del namespace `monitoring`:

   ```bash
   kubectl get events -n monitoring --sort-by=.metadata.creationTimestamp
   ```

4. Identificar eventos relacionados con fallos (`Failed`, `Unhealthy`, `Killing`, etc.)

5. Abrir AlertManager y comparar timestamps de alertas con los eventos:

   ```bash
   kubectl port-forward -n monitoring svc/alertmanager-main 9093
   # Visitar http://localhost:9093
   ```

6. Si aplica, revisar logs correlacionados:

   ```bash
   stern -n monitoring
   ```

---

### 🔥 Retos

* **Anota al menos una alerta y su evento correspondiente con timestamp exacto**
  💡 Puedes capturarlo con `kubectl describe pod` o en los eventos generales.

* **Relaciona una alerta por alta CPU con el evento de creación del pod que la provocó**
  💡 Observa si hay eventos tipo `Scheduled` justo antes de la alerta.

* **Detecta inconsistencias entre alertas y eventos**
  💡 Compara qué detecta primero el clúster: evento o métrica.

---

### ✅ Validaciones

* El alumno es capaz de trazar una alerta hasta su evento y log asociado
* Se han revisado alertas desde Prometheus y AlertManager
* Se ha comprendido cómo se alinean los distintos mecanismos de observabilidad
