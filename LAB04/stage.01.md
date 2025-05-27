### Fase 1: Marcar nodos como `cordon` y `uncordon`

---

### 🎯 Objetivo

Aprender a marcar nodos como no disponibles (`cordon`) y devolverlos a estado operativo (`uncordon`) sin eliminar pods existentes, preparando el entorno para operaciones de mantenimiento.

---

### 🧰 Requisitos

* Clúster con al menos 2 nodos (kind multi-node o clúster remoto)
* Acceso a `kubectl` con permisos suficientes

---

### 🔧 Pasos

1. Listar nodos disponibles:

   ```bash
   kubectl get nodes
   ```

2. Marcar un nodo como no programable (`cordon`):

   ```bash
   kubectl cordon <nombre-del-nodo>
   ```

3. Comprobar el estado del nodo:

   ```bash
   kubectl get nodes
   # Debe aparecer como "SchedulingDisabled"
   ```

4. Lanzar un nuevo pod y verificar que no se programa en el nodo cordonado:

   ```bash
   kubectl run testpod --image=nginx --restart=Never
   kubectl describe pod testpod
   ```

5. Volver a habilitar el nodo (`uncordon`):

   ```bash
   kubectl uncordon <nombre-del-nodo>
   ```

6. Confirmar que el nodo vuelve a estar disponible para scheduling:

   ```bash
   kubectl get nodes
   ```

---

### 🔥 Retos

* **Cordona todos los nodos excepto uno y lanza un deployment con 3 réplicas**
  💡 Observa cómo Kubernetes intenta asignarlos todos al único nodo disponible.

* **Consulta los eventos generados al cordonar/uncordonar**
  💡 Usa `kubectl get events` o `kubectl describe node`.

* **Crea un script que liste nodos y permita cordonarlos/uncordonarlos de forma selectiva**
  💡 Usa `kubectl get nodes -o name | xargs`.

---

### ✅ Validaciones

* El estado del nodo cambia correctamente entre `Ready` y `SchedulingDisabled`
* Los pods no se asignan a nodos cordonados
* El nodo vuelve a aceptar workloads tras el `uncordon`
