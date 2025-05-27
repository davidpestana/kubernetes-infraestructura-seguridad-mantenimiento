### Fase 4: Uso de `kubectl top`, `describe` y `events`

---

### 🎯 Objetivo

Utilizar herramientas de inspección de recursos en Kubernetes para identificar cuellos de botella, anomalías de rendimiento y estados detallados de nodos y pods.

---

### 🧰 Requisitos

* Plugin `metrics-server` desplegado en el clúster
* `kubectl` configurado y con permisos
* Recursos de carga moderada (pods con CPU o memoria en uso)

---

### 🔧 Pasos

1. Ver métricas de uso de CPU y memoria por nodo:

   ```bash
   kubectl top nodes
   ```

2. Ver métricas de pods activos:

   ```bash
   kubectl top pods -A
   ```

3. Describir un pod para revisar configuración y estado:

   ```bash
   kubectl get pods -A
   kubectl describe pod <nombre> -n <namespace>
   ```

4. Obtener eventos recientes relacionados con un recurso:

   ```bash
   kubectl get events --sort-by=.metadata.creationTimestamp
   ```

5. Describir un nodo para analizar condiciones de disponibilidad:

   ```bash
   kubectl describe node <nombre-del-nodo>
   ```

---

### 🔥 Retos

* **Identifica el pod con mayor consumo de CPU y memoria en el clúster**
  💡 Usa `kubectl top pods -A | sort -k3 -n` para CPU y `-k4` para memoria.

* **Detecta un pod que no puede arrancar y revisa sus eventos**
  💡 Busca errores tipo `BackOff`, `Failed`, `CrashLoopBackOff`.

* **Relaciona una caída en rendimiento con los eventos y métricas del nodo afectado**
  💡 Compara los resultados de `kubectl top node` y `describe node`.

---

### ✅ Validaciones

* Se interpretan correctamente los resultados de `kubectl top`
* Se identifican eventos relevantes en pods y nodos
* Se obtiene una visión clara del estado del clúster a nivel de recursos y fallos recientes
