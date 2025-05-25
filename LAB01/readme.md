# 🧭 Sesión 1: Infraestructura básica Kubernetes

**Duración:** 3 horas
**Modalidad:** Presencial
**Objetivo general:** Comprender y poner en marcha un clúster Kubernetes local con `kind`, explorar sus componentes básicos y familiarizarse con las estructuras fundamentales de despliegue y almacenamiento.

---

## 🔧 Requisitos previos

* Docker funcionando correctamente
* `kind`, `kubectl` instalados
* VS Code con extensiones recomendadas (Kubernetes, YAML)
* Entorno Linux o Windows con WSL2 habilitado

---

## 🔬 Fases del laboratorio

### 🔹 Fase 1: Clúster con kind

**🎯 Objetivo:** Crear un clúster local con `kind` y validar su disponibilidad.
**🧱 Scaffold:** archivo `kind-config.yaml` básico
**🧭 Pasos:**

1. Crear archivo de configuración para kind con 1 nodo
2. Lanzar clúster `kind create cluster --config kind-config.yaml`
3. Validar con `kubectl get nodes` y `kubectl cluster-info`
   **🔥 Reto:** Adaptar el archivo para añadir un nodo worker adicional
   **✅ Validación:** Dos nodos listados y estado `Ready`

---

### 🔹 Fase 2: Exploración con `kubectl`

**🎯 Objetivo:** Familiarizarse con el plano de control, nodos y objetos por defecto.
**🧭 Pasos:**

1. Usar `kubectl get all --all-namespaces`
2. Explorar `kubectl api-resources`, `kubectl explain pod`
3. Observar namespaces con `kubectl get ns`
   **🔥 Reto:** Identificar cuál es el objeto que representa el plano de control
   **✅ Validación:** Explicación verbal o escrita de qué recursos existen al arrancar

---

### 🔹 Fase 3: Conectividad entre pods (`busybox`)

**🎯 Objetivo:** Verificar conectividad entre pods y uso de DNS interno
**🧭 Pasos:**

1. Lanzar dos pods `busybox` con terminal activo
2. Ejecutar `nslookup`, `ping`, `wget` entre ellos
3. Probar comunicación entre namespaces
   **🔥 Reto:** Identificar el nombre DNS completo (`FQDN`) de un pod
   **✅ Validación:** Comunicación exitosa y comandos ejecutados

---

### 🔹 Fase 4: ReplicaSet / DaemonSet / StatefulSet

**🎯 Objetivo:** Comparar los controladores de replicación y comportamiento por nodo/pod
**🧭 Pasos:**

1. Crear un ReplicaSet con 2 réplicas
2. Desplegar un DaemonSet con pod por nodo
3. Probar un StatefulSet y observar nombres
   **🔥 Reto:** Forzar reinicio de un pod de StatefulSet y verificar persistencia de nombre
   **✅ Validación:** Descripción clara de diferencias entre los 3 controladores

---

### 🔹 Fase 5: Volúmenes (`emptyDir`, PVC)

**🎯 Objetivo:** Montar volúmenes en pods para persistencia temporal y con PVC
**🧭 Pasos:**

1. Desplegar pod con volumen `emptyDir`
2. Crear un PVC y usarlo en un Deployment
3. Escribir datos dentro del volumen
   **🔥 Reto:** Eliminar el pod y verificar si el volumen persiste según el tipo
   **✅ Validación:** Entender qué tipo de volumen mantiene datos tras borrado

---

### 🔹 Fase 6: Limpieza de imágenes y espacio

**🎯 Objetivo:** Entender el consumo de recursos en nodos y limpieza
**🧭 Pasos:**

1. Conectarse al contenedor del nodo con `docker exec`
2. Ver uso de disco con `df -h`, `du`
3. Limpiar imágenes `docker image prune`
   **🔥 Reto:** Detectar qué recursos ocupan más espacio y cómo liberar
   **✅ Validación:** Evidencia de recuperación de espacio tras la limpieza

---

## 🧠 Reflexión final de la sesión

* ¿Qué tipo de controlador usarías para una app con base de datos?
* ¿Qué implicaciones tiene perder un pod en relación con el almacenamiento?
* ¿Por qué es importante comprender las diferencias entre pods y volúmenes temporales o persistentes?

---

## 📁 Archivos recomendados por fase

* `kind-config.yaml`
* `replicaset.yaml`, `daemonset.yaml`, `statefulset.yaml`
* `pod-emptydir.yaml`, `pvc-deployment.yaml`
* `busybox.yaml`

---

## ✅ Comprobación de conocimientos al final de sesión

* ¿Qué diferencias clave existen entre ReplicaSet y StatefulSet?
* ¿Qué significa que un pod esté en estado `CrashLoopBackOff`?
* ¿Cómo acceder a los logs de un pod que acaba de morir?
* ¿Para qué sirve `emptyDir` y cuándo no es suficiente?
