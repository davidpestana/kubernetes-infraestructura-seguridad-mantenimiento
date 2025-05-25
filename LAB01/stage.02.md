# Laboratorio 01 - Fase 2: Exploración inicial de recursos con kubectl

## 🎯 Objetivo

Familiarizarse con el uso de `kubectl` para explorar y comprender los recursos básicos de Kubernetes en un clúster funcional.

## 🛠️ Descripción

Se utilizará `kubectl` para consultar recursos como nodos, pods, namespaces, servicios, eventos y descripciones detalladas. Este conocimiento es esencial para todo administrador de Kubernetes.

## 🔧 Pasos

1. Ver los nodos disponibles:

   ```bash
   kubectl get nodes -o wide
   ```

2. Inspeccionar los namespaces activos:

   ```bash
   kubectl get namespaces
   ```

3. Ver todos los pods en todos los namespaces:

   ```bash
   kubectl get pods --all-namespaces
   ```

4. Ver todos los servicios en todos los namespaces:

   ```bash
   kubectl get svc --all-namespaces
   ```

5. Explorar objetos en el namespace `kube-system`:

   ```bash
   kubectl get all -n kube-system
   ```

6. Obtener detalles de un pod (ajusta el nombre al que veas en tu entorno):

   ```bash
   kubectl describe pod <nombre-del-pod> -n kube-system
   ```

7. Ver los eventos recientes del clúster:

   ```bash
   kubectl get events --sort-by=.metadata.creationTimestamp
   ```

## 🔥 Retos

* **Encuentra cuántos pods hay corriendo en el namespace `kube-system`**
  🔧 *Tip:* Usa `kubectl get pods -n kube-system`

* **Describe el pod que tiene `controller` en su nombre y localiza su nodo**
  🔧 *Tip:* Usa `kubectl get pods -n kube-system` y luego `kubectl describe pod <pod>`

* **Investiga qué hace el pod llamado `coredns`**
  🔧 *Tip:* Busca en la descripción o en los logs del pod usando `kubectl logs`

## ✅ Validaciones

* Puedes ver el estado de todos los pods y servicios
* Localizas y describes un pod específico correctamente
* Obtienes eventos recientes ordenados por hora
* Entiendes el rol de al menos un componente del sistema como `coredns`
