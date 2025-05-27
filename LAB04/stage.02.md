### Fase 2: Drenar nodo y observar redistribución de pods

---

### 🎯 Objetivo

Aprender a realizar el drenado de un nodo para evacuar sus pods de forma segura y observar cómo Kubernetes reubica automáticamente los workloads en otros nodos disponibles.

---

### 🧰 Requisitos

* Clúster con al menos 2 nodos
* Workloads en ejecución (Deployment o ReplicaSet con varias réplicas)
* Acceso a `kubectl` con privilegios de administración

---

### 🔧 Pasos

1. Identificar el nodo a drenar:

   ```bash
   kubectl get nodes
   ```

2. Observar qué pods están corriendo en ese nodo:

   ```bash
   kubectl get pods -o wide
   ```

3. Drenar el nodo:

   ```bash
   kubectl drain <nombre-del-nodo> --ignore-daemonsets --delete-emptydir-data
   ```

4. Comprobar que los pods han sido reprogramados en otros nodos:

   ```bash
   kubectl get pods -o wide
   ```

5. Volver a habilitar el nodo (si se desea):

   ```bash
   kubectl uncordon <nombre-del-nodo>
   ```

---

### 🔥 Retos

* **Lanza un Deployment con 5 réplicas y observa cómo se redistribuyen tras el drenado**
  💡 Usa `kubectl get pods -o wide` antes y después para comparar nodos asignados.

* **Detecta qué pods no se reprograman automáticamente y por qué**
  💡 Algunos pods con `emptyDir`, sin controller, o con nodos específicos pueden fallar.

* **Simula un mantenimiento parcial marcando como `cordon` antes de `drain`**
  💡 Esto evita que se programen nuevos pods mientras se evacúan los existentes.

---

### ✅ Validaciones

* El nodo ha sido drenado sin errores y los pods se han reubicado correctamente
* Los DaemonSets no se han eliminado durante el proceso
* El nodo puede volver a estar operativo tras `uncordon` y `kubectl get nodes` muestra estado `Ready`
