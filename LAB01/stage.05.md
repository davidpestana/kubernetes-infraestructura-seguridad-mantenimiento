# Laboratorio 01 - Fase 5: Uso de volúmenes `emptyDir` y PVC

## 🎯 Objetivo

Explorar el uso de volúmenes en Kubernetes, tanto efímeros (`emptyDir`) como persistentes (PVC), para entender su ciclo de vida y comportamiento.

## 🛠️ Descripción

Se creará un pod temporal con `emptyDir` para observar su comportamiento al reiniciar y eliminar. Luego se definirá un PersistentVolumeClaim para montar almacenamiento persistente en otro pod.

## 🔧 Pasos

### 1. Crear namespace

```bash
kubectl create namespace storage-test
```

### 2. Crear un pod con volumen `emptyDir`

```yaml
kubectl apply -n storage-test -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: emptydir-demo
spec:
  containers:
  - name: busybox
    image: busybox
    command: ["sh", "-c", "while true; do date >> /data/log.txt; sleep 5; done"]
    volumeMounts:
    - name: data
      mountPath: /data
  volumes:
  - name: data
    emptyDir: {}
EOF
```

### 3. Inspeccionar el contenido del volumen

```bash
kubectl exec -n storage-test emptydir-demo -- cat /data/log.txt
```

### 4. Eliminar el pod y volver a crearlo para observar que el contenido se pierde

---

### 5. Crear PVC y pod asociado

```yaml
kubectl apply -n storage-test -f - <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: demo-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
---
apiVersion: v1
kind: Pod
metadata:
  name: pvc-demo
spec:
  containers:
  - name: busybox
    image: busybox
    command: ["sh", "-c", "while true; do date >> /mnt/data/log.txt; sleep 5; done"]
    volumeMounts:
    - mountPath: "/mnt/data"
      name: data-vol
  volumes:
  - name: data-vol
    persistentVolumeClaim:
      claimName: demo-pvc
EOF
```

### 6. Verificar persistencia del volumen

```bash
kubectl exec -n storage-test pvc-demo -- cat /mnt/data/log.txt
kubectl delete pod pvc-demo
kubectl apply -n storage-test -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: pvc-demo-2
spec:
  containers:
  - name: busybox
    image: busybox
    command: ["sh", "-c", "cat /mnt/data/log.txt && sleep 3600"]
    volumeMounts:
    - mountPath: "/mnt/data"
      name: data-vol
  volumes:
  - name: data-vol
    persistentVolumeClaim:
      claimName: demo-pvc
EOF
```

## 🔥 Retos

* **Confirma visualmente que `emptyDir` se borra al reiniciar el pod**
  🔧 *Tip:* Observa el contenido antes y después de eliminar y recrear

* **Valida que el contenido del PVC se conserva al reemplazar el pod**
  🔧 *Tip:* El segundo pod debería mostrar las mismas fechas registradas

* **Intenta montar el PVC en dos pods a la vez y observa el resultado**
  🔧 *Tip:* Si el access mode es `ReadWriteOnce`, puede fallar

## ✅ Validaciones

* Se ha usado `emptyDir` y se ha demostrado su carácter efímero
* Se ha creado un PVC y usado en al menos dos pods
* Se ha verificado la persistencia de los datos
* Se ha comprendido el comportamiento de los modos de acceso
