## Laboratorio 01 - Fase 6: Servicios y Balanceo de Carga para Deployments

### 📁 Estructura sugerida
```
lab-01-fase-6/
├── 01-deployment.yaml
├── 02-service-clusterip.yaml
├── 03-pod-curl.yaml
```

---

### 📄 01-deployment.yaml
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deploy
  namespace: deploy-test
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
```

---

### 📄 02-service-clusterip.yaml
```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  namespace: deploy-test
spec:
  type: ClusterIP
  selector:
    app: nginx
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
```

---

### 📄 03-pod-curl.yaml
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: curl
  namespace: deploy-test
spec:
  restartPolicy: Never
  containers:
  - name: curl
    image: curlimages/curl
    command: [ "sleep", "3600" ]
```

---

### 🧪 Comandos prácticos
```bash
# Crear namespace si no existe
kubectl create namespace deploy-test

# Aplicar los manifests
kubectl apply -f 01-deployment.yaml
kubectl apply -f 02-service-clusterip.yaml
kubectl apply -f 03-pod-curl.yaml

# Acceder al pod curl
kubectl exec -it curl -n deploy-test -- sh

# Desde dentro del pod:
curl nginx-service

# Observar balanceo
kubectl logs -l app=nginx -n deploy-test --tail=5
```

---

### 🔥 Retos

1. **Convertir el Service a NodePort**
   - Editar el archivo del service:
     ```yaml
     type: NodePort
     ```
   - Aplicar de nuevo:
     ```bash
     kubectl apply -f 02-service-clusterip.yaml
     kubectl get svc -n deploy-test
     ```

2. **Agregar `add_header` en NGINX**  
   Usar imagen custom o ConfigMap con:
   ```nginx
   server {
       listen 80;
       location / {
           add_header X-Pod-Name "$hostname";
           root /usr/share/nginx/html;
           index index.html;
       }
   }
   ```

---

### ✅ Validaciones
- El servicio responde internamente con `curl nginx-service`
- Logs muestran peticiones distribuidas entre réplicas
- Acceso interno por DNS funciona correctamente

