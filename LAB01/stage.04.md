# Laboratorio 01 - Fase 4: Comparativa entre ReplicaSet, DaemonSet y StatefulSet

## 🎯 Objetivo

Comprender las diferencias operativas entre los tipos de controladores de despliegue: ReplicaSet, DaemonSet y StatefulSet.

## 🛠️ Descripción

Se desplegará un ejemplo de cada tipo de workload y se observará su comportamiento frente al escalado, ubicación en nodos y persistencia de identidad.

## 🔧 Pasos

### 1. Crear un namespace dedicado

```bash
kubectl create namespace workloads-test
```

### 2. Desplegar un ReplicaSet

```yaml
kubectl apply -n workloads-test -f - <<EOF
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: rs-demo
spec:
  replicas: 3
  selector:
    matchLabels:
      app: rs-demo
  template:
    metadata:
      labels:
        app: rs-demo
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
EOF
```

### 3. Desplegar un DaemonSet

```bash
kubectl apply -n workloads-test -f https://k8s.io/examples/controllers/daemonset.yaml
```

### 4. Desplegar un StatefulSet (requiere PVC)

```bash
kubectl apply -n workloads-test -f https://k8s.io/examples/controllers/statefulset.yaml
```

### 5. Observar diferencias

```bash
kubectl get pods -n workloads-test -o wide
kubectl describe rs rs-demo -n workloads-test
kubectl describe ds <daemonset-name> -n workloads-test
kubectl describe sts <statefulset-name> -n workloads-test
```

## 🔥 Retos

* **Escala el ReplicaSet a 5 pods y observa la distribución**
  🔧 *Tip:* `kubectl scale rs rs-demo --replicas=5 -n workloads-test`

* **Elimina un pod de DaemonSet y verifica que se recrea**
  🔧 *Tip:* Usa `kubectl delete pod <nombre>` y observa su recreación automática

* **Observa los nombres secuenciales en StatefulSet**
  🔧 *Tip:* Compara los nombres de los pods creados (`web-0`, `web-1`, etc.)

## ✅ Validaciones

* Se han desplegado los tres tipos de controlador
* Se han observado al menos 2 diferencias funcionales entre ellos
* Se ha escalado manualmente el ReplicaSet
* Se ha confirmado el comportamiento autorecuperable del DaemonSet
* Se ha validado el naming y persistencia del StatefulSet
