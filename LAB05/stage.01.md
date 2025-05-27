### Fase 1: Desplegar microservicio ejemplo (nginx o api demo)

---

### 🎯 Objetivo

Realizar el despliegue de una aplicación sencilla en Kubernetes como microservicio base sobre el que aplicar configuraciones de seguridad, monitorización y mantenimiento.

---

### 🧰 Requisitos

* Clúster Kubernetes funcional
* Namespace de trabajo: `demo`
* Imagen disponible en DockerHub (por ejemplo `nginx` o una API demo)

---

### 🔧 Pasos

1. Crear el namespace `demo`:

   ```bash
   kubectl create namespace demo
   ```

2. Desplegar una aplicación simple (nginx):

   ```yaml
   kubectl apply -n demo -f - <<EOF
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: nginx-demo
   spec:
     replicas: 2
     selector:
       matchLabels:
         app: nginx-demo
     template:
       metadata:
         labels:
           app: nginx-demo
       spec:
         containers:
         - name: nginx
           image: nginx:1.25
           ports:
           - containerPort: 80
   EOF
   ```

3. Exponer la aplicación con un Service:

   ```yaml
   kubectl apply -n demo -f - <<EOF
   apiVersion: v1
   kind: Service
   metadata:
     name: nginx-service
   spec:
     selector:
       app: nginx-demo
     ports:
     - protocol: TCP
       port: 80
       targetPort: 80
   EOF
   ```

4. Comprobar que los pods están corriendo:

   ```bash
   kubectl get pods -n demo -o wide
   kubectl get svc -n demo
   ```

5. (Opcional) Acceder desde fuera con port-forward:

   ```bash
   kubectl port-forward svc/nginx-service -n demo 8080:80
   # Navega a http://localhost:8080
   ```

---

### 🔥 Retos

* **Despliega una imagen distinta como API demo (por ejemplo, `hashicorp/http-echo`)**
  💡 Reemplaza la imagen y añade argumentos para definir la respuesta.

* **Añade una `readinessProbe` y una `livenessProbe` al pod**
  💡 Usa HTTP GET en la raíz `/` del contenedor nginx.

* **Prueba a escalar manualmente el deployment a 5 réplicas y verifica balanceo**
  💡 Usa `kubectl scale deployment nginx-demo --replicas=5 -n demo`

---

### ✅ Validaciones

* La app se despliega correctamente y responde a peticiones
* Hay al menos dos pods activos y balanceados por el Service
* El alumno puede acceder al servicio desde el navegador vía `port-forward`
