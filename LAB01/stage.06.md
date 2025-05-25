# Laboratorio 01 - Fase 6: Limpieza de imágenes y espacio

## 🎯 Objetivo

Aprender a identificar y liberar recursos consumidos en los nodos del clúster, tales como imágenes no usadas y espacio en disco ocupado por contenedores detenidos o volúmenes efímeros.

## 🧰 Requisitos previos

* Acceso a nodos del clúster vía `docker` o `nerdctl` (en kind es posible entrar a los nodos con `docker exec`)

## 🛠️ Descripción

Se inspeccionará el espacio ocupado en los nodos del clúster, se listarán imágenes locales, contenedores detenidos y volúmenes temporales, y se procederá a su limpieza cuando corresponda.

## 🔧 Pasos

1. Listar los nodos de kind:

   ```bash
   docker ps --format '{{.Names}}'
   ```

2. Acceder a un nodo worker:

   ```bash
   docker exec -it kind-worker bash
   ```

3. Comprobar uso de disco:

   ```bash
   df -h
   du -sh /var/lib/docker
   ```

4. Listar imágenes locales:

   ```bash
   crictl images
   # o dentro del nodo: docker images
   ```

5. Listar contenedores detenidos:

   ```bash
   crictl ps -a
   # o docker ps -a
   ```

6. Eliminar contenedores detenidos e imágenes no usadas:

   ```bash
   docker system prune -a
   ```

7. Salir del nodo:

   ```bash
   exit
   ```

## 🔥 Retos

* **Compara el tamaño del disco antes y después de hacer limpieza**
  💡 *Tip:* Ejecuta `df -h` y `du -sh` antes y después de `docker system prune`

* **Identifica imágenes duplicadas o sin uso aparente**
  💡 *Tip:* Usa `docker images` y busca etiquetas `<none>` o REPOSITORY vacío

* **Automatiza la limpieza en varios nodos con un script de shell**
  💡 *Tip:* Usa un bucle que itere sobre `docker ps --format '{{.Names}}'`

## ✅ Validaciones

* Se ha reducido el espacio ocupado en `/var/lib/docker`
* Se han eliminado contenedores y/o imágenes que no estaban en uso
* El alumno comprende qué datos pueden eliminarse sin afectar el clúster en ejecución
