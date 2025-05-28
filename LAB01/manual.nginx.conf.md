

## 📘 Manual: Inyectar `nginx.conf` en un Deployment de NGINX usando ConfigMap

### 🎯 Objetivo

Desplegar NGINX con una configuración personalizada (`nginx.conf`) proporcionada mediante un ConfigMap y montada en la ruta correcta mediante un volumen.

---

### 📝 1. Crear el archivo `nginx.conf`

Guarda tu configuración personalizada como `nginx.conf`:

```nginx
events {}

http {
  server {
    listen 80;
    location / {
      return 200 'Custom NGINX!';
    }
  }
}
```

---

### 🧱 2. Crear el ConfigMap

```bash
kubectl create configmap nginx-config \
  --from-file=nginx.conf=./nginx.conf
```

Puedes verificarlo con:

```bash
kubectl describe configmap nginx-config
```

---

### 🧩 3. Crear el Deployment de NGINX con volumen montado

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-custom
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-custom
  template:
    metadata:
      labels:
        app: nginx-custom
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
        volumeMounts:
        - name: config-volume
          mountPath: /etc/nginx/nginx.conf
          subPath: nginx.conf
        ports:
        - containerPort: 80
      volumes:
      - name: config-volume
        configMap:
          name: nginx-config
```

📌 **Importante**:

* `mountPath: /etc/nginx/nginx.conf` → sobreescribe el archivo de configuración principal de NGINX.
* `subPath: nginx.conf` → indica el nombre del archivo dentro del ConfigMap.

---

### 🚀 4. Aplicar el Deployment

```bash
kubectl apply -f nginx-deployment.yaml
```

---

### 📡 5. Probar acceso

Crea un Service para exponer el pod:

```bash
kubectl expose deployment nginx-custom \
  --name=nginx-custom-svc \
  --port=80 \
  --target-port=80
```

Y accede desde otro pod o con port-forward:

```bash
kubectl port-forward svc/nginx-custom-svc 8080:80
curl http://localhost:8080
```