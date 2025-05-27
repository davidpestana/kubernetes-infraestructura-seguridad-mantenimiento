### Fase 4: Acceso a logs con `kubectl logs` y `stern`

---

### 🎯 Objetivo

Aprender a acceder y explorar los logs de los pods en Kubernetes utilizando `kubectl logs` y `stern`, con el fin de diagnosticar comportamientos y correlacionarlos con alertas.

---

### 🧰 Requisitos

* Clúster con pods en ejecución
* `kubectl` y `stern` instalados
* Permisos para acceder al namespace `monitoring` o donde estén los pods

---

### 🔧 Pasos

1. Ver logs de un pod individual con `kubectl logs`:

   ```bash
   kubectl get pods -n monitoring
   kubectl logs -n monitoring <nombre-del-pod>
   ```

2. Ver logs de un contenedor concreto dentro de un pod (si hay varios):

   ```bash
   kubectl logs -n monitoring <pod> -c <container>
   ```

3. Ver logs anteriores a un reinicio:

   ```bash
   kubectl logs -n monitoring <pod> --previous
   ```

4. Instalar `stern` (si no está disponible):

   ```bash
   brew install stern  # macOS
   sudo apt install stern  # Linux (si está en repositorio)
   ```

5. Seguir logs en tiempo real de todos los pods con cierto label:

   ```bash
   stern -n monitoring app=prometheus
   ```

6. Filtrar por contenido específico:

   ```bash
   stern -n monitoring -l app=alertmanager | grep error
   ```

---

### 🔥 Retos

* **Identifica un error real o warning en los logs de Prometheus**
  💡 Revisa las líneas con `grep error`, `grep warn`, etc.

* **Analiza los logs justo después de provocar una alerta de CPU**
  💡 Comprueba si hay correlación temporal con lo mostrado en Prometheus.

* **Compara los logs normales vs `--previous` tras reiniciar un pod manualmente**
  💡 Usa `kubectl delete pod <pod>` y luego `logs --previous`.

---

### ✅ Validaciones

* Se puede acceder a los logs de pods con `kubectl logs`
* `stern` permite seguir múltiples pods en paralelo
* Se identifican eventos o errores relacionados con alertas disparadas previamente
