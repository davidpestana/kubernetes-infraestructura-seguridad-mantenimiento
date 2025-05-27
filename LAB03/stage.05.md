### Fase 5: Introducir errores intencionados y analizar logs

---

### 🎯 Objetivo

Provocar fallos controlados en aplicaciones o componentes del clúster para observar cómo se reflejan en los logs y comprobar la eficacia de las alertas configuradas.

---

### 🧰 Requisitos

* Stack de monitorización desplegado
* Aplicación con probes configurados o servicios sensibles a fallos
* Acceso a `kubectl`, `stern` y a la interfaz de Prometheus/AlertManager

---

### 🔧 Pasos

1. Desplegar un pod con una `readinessProbe` o `livenessProbe` que fallará:

   ```yaml
   kubectl apply -n monitoring -f - <<EOF
   apiVersion: v1
   kind: Pod
   metadata:
     name: probe-failure
   spec:
     containers:
     - name: fail
       image: nginx
       readinessProbe:
         httpGet:
           path: /nope
           port: 80
         initialDelaySeconds: 3
         periodSeconds: 5
   EOF
   ```

2. Esperar unos minutos y verificar que el pod no está “Ready”:

   ```bash
   kubectl get pod probe-failure -n monitoring
   ```

3. Ver logs de la sonda fallida con:

   ```bash
   kubectl describe pod probe-failure -n monitoring
   stern probe-failure -n monitoring
   ```

4. Comprobar si se ha disparado alguna alerta relacionada (estado de pod, readiness, etc.)

5. Simular una carga alta de CPU para forzar alertas anteriores:

   ```bash
   kubectl run stress --image=busybox --restart=Never -n monitoring -- sh -c "while true; do :; done"
   ```

6. Inspeccionar el comportamiento del clúster y los logs de `kubelet`, Prometheus, o de los pods afectados.

---

### 🔥 Retos

* **Provoca un fallo de `CrashLoopBackOff` modificando el comando de arranque**
  💡 Usa `command: ["sh", "-c", "exit 1"]` en un pod.

* **Introduce errores HTTP simulando fallos en rutas `/healthz`**
  💡 Despliega nginx y configura una probe a una ruta inexistente.

* **Monitorea el estado de los pods afectados por los errores desde los logs en tiempo real**
  💡 Usa `stern` y compara timestamps con las alertas.

---

### ✅ Validaciones

* El error es detectado en logs (`stern` o `kubectl describe`)
* El estado del pod cambia visiblemente (`NotReady`, `CrashLoopBackOff`, etc.)
* Las alertas se disparan o se reflejan como “firing” en Prometheus y AlertManager
