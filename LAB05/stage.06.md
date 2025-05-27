### Fase 6: Evaluar el estado del clúster y elaborar informe final

---

### 🎯 Objetivo

Realizar una revisión integral del entorno Kubernetes tras aplicar configuraciones de seguridad, monitorización y mantenimiento, generando un informe con evidencias técnicas del estado del clúster.

---

### 🧰 Requisitos

* Todas las fases anteriores completadas
* `kubectl`, `stern`, acceso a Prometheus y AlertManager
* Herramientas de exportación: Markdown, PDF, YAML, o capturas según el caso

---

### 🔧 Pasos

1. Comprobar estado de todos los recursos en el namespace `demo`:

   ```bash
   kubectl get all -n demo
   ```

2. Verificar que no hay pods en estado de error:

   ```bash
   kubectl get pods -A | grep -v Running
   ```

3. Revisar si hay alertas activas en Prometheus:

   ```bash
   kubectl port-forward -n monitoring svc/prometheus-k8s 9090
   # Navegar a http://localhost:9090/alerts
   ```

4. Consultar si AlertManager ha recibido notificaciones recientes:

   ```bash
   kubectl port-forward -n monitoring svc/alertmanager-main 9093
   # Navegar a http://localhost:9093
   ```

5. Revisar eventos recientes relevantes:

   ```bash
   kubectl get events --sort-by=.metadata.creationTimestamp -A | tail -n 20
   ```

6. Generar informe manual (estructura recomendada):

   * Descripción de entorno (nodos, namespaces, pods)
   * Estado de pods y servicios
   * Políticas aplicadas (RBAC, NetworkPolicies)
   * Alertas configuradas y su estado
   * Logs y eventos asociados a incidencias
   * Valoración final y propuestas de mejora

---

### 🔥 Retos

* **Captura y documenta una alerta real con sus métricas y logs relacionados**
  💡 Incluye timestamps, outputs de `kubectl`, y prints de Prometheus.

* **Haz una tabla comparativa entre el estado inicial del clúster y el final tras todas las fases**
  💡 Puedes mostrar diferencias en seguridad, visibilidad y resiliencia.

* **Entrega el informe como si fuera una auditoría técnica para validación externa**
  💡 Asegura trazabilidad de cada acción y evidencia.

---

### ✅ Validaciones

* El clúster está libre de errores visibles y tiene políticas activas
* Las alertas están bien configuradas y se han probado
* El informe refleja el trabajo hecho en seguridad, observabilidad y mantenimiento del microservicio y su entorno
