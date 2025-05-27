### Fase 6: Liberar espacio y verificar uso tras limpieza

---

### 🎯 Objetivo

Realizar tareas de limpieza en los nodos del clúster para liberar espacio ocupado por imágenes, contenedores detenidos y volúmenes efímeros, y comprobar el impacto real en el uso de disco.

---

### 🧰 Requisitos

* Clúster con acceso a los nodos (por ejemplo, nodos kind con `docker exec`)
* Permisos de administrador local para ejecutar comandos en los nodos
* `docker` o `crictl` instalado en los nodos

---

### 🔧 Pasos

1. Ver uso actual de disco:

   ```bash
   docker exec -it kind-worker df -h
   docker exec -it kind-worker du -sh /var/lib/docker
   ```

2. Listar imágenes existentes:

   ```bash
   docker exec -it kind-worker docker images
   ```

3. Ver contenedores detenidos:

   ```bash
   docker exec -it kind-worker docker ps -a
   ```

4. Eliminar contenedores detenidos e imágenes no utilizadas:

   ```bash
   docker exec -it kind-worker docker system prune -a -f
   ```

5. Verificar de nuevo el uso de disco tras la limpieza:

   ```bash
   docker exec -it kind-worker df -h
   docker exec -it kind-worker du -sh /var/lib/docker
   ```

---

### 🔥 Retos

* **Haz la limpieza en todos los nodos usando un script en bucle**
  💡 Usa `docker ps --format '{{.Names}}' | grep kind-` para iterar.

* **Detecta qué tipo de recursos estaban consumiendo más espacio antes de limpiar**
  💡 Usa `du -sh /var/lib/docker/*` dentro del nodo.

* **Compara el impacto de limpiar solo volúmenes frente a limpiar imágenes y contenedores**
  💡 Ejecuta limpiezas parciales y mide diferencia.

---

### ✅ Validaciones

* Se ha reducido el tamaño de `/var/lib/docker` tras limpieza
* Imágenes no utilizadas han sido eliminadas correctamente
* El alumno entiende qué puede eliminarse sin interrumpir servicios activos
