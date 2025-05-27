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




## Laboratorio 01 - Fase 4.1: Comportamiento de los Deployments – Update y Rollback

🎯 **Objetivo**
Comprender cómo funcionan los `Deployment` en Kubernetes, incluyendo su capacidad de actualización declarativa, rollout progresivo, y rollback automático/manual.

🛠️ **Descripción**
Se desplegará un `Deployment` básico de NGINX. Se simulará una actualización correcta y otra fallida para comprobar los mecanismos de rollback. Se observará el rollout status y los eventos generados durante el proceso.

🔧 **Pasos**

1. **Crear un namespace dedicado**  
```bash
kubectl create namespace deploy-test
```

2. **Desplegar un Deployment inicial**  
```bash
kubectl apply -n deploy-test -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deploy
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
        ports:
        - containerPort: 80
EOF
```

3. **Validar estado del Deployment**  
```bash
kubectl rollout status deployment/nginx-deploy -n deploy-test
kubectl get pods -n deploy-test -o wide
```

4. **Actualizar la versión del contenedor (pase exitoso)**  
```bash
kubectl set image deployment/nginx-deploy nginx=nginx:1.25.3 -n deploy-test
kubectl rollout status deployment/nginx-deploy -n deploy-test
```

5. **Introducir un error en la imagen (simular fallo)**  
```bash
kubectl set image deployment/nginx-deploy nginx=nginx:doesnotexist -n deploy-test
kubectl rollout status deployment/nginx-deploy -n deploy-test
```

6. **Ver estado del rollout fallido**  
```bash
kubectl describe deployment nginx-deploy -n deploy-test
kubectl get rs -n deploy-test
```

7. **Ejecutar un rollback manual al estado anterior**  
```bash
kubectl rollout undo deployment/nginx-deploy -n deploy-test
kubectl rollout status deployment/nginx-deploy -n deploy-test
```

🔥 **Retos**

- Escala el `Deployment` a 5 réplicas  
  🔧 Tip:  
  ```bash
  kubectl scale deployment nginx-deploy --replicas=5 -n deploy-test
  ```

- Simula un fallo de despliegue (imagen inexistente) y comprueba los eventos generados  
  🔧 Tip:  
  ```bash
  kubectl describe deployment nginx-deploy -n deploy-test | grep -i event -A 10
  ```

- Realiza un rollback y verifica que los pods vuelven a un estado funcional  
  🔧 Tip:  
  ```bash
  kubectl rollout undo deployment/nginx-deploy -n deploy-test
  ```

✅ **Validaciones**

- Se ha desplegado correctamente un `Deployment` con 3 réplicas
- Se ha realizado una actualización de versión exitosa
- Se ha introducido un error que impide el despliegue correcto
- Se ha detectado el fallo y ejecutado un rollback
- Se ha escalado el Deployment y verificado el estado de los pods

