# Curso: Kubernetes - Infraestructura, Seguridad y Mantenimiento

**Duración total:** 15 horas
**Número de sesiones:** 5 (4 presenciales + 1 remota)
**Perfil destinatario:** Técnicos de sistemas e ingenieros con conocimientos básicos o nulos en Kubernetes

## 🎯 Objetivo general

Proporcionar a los asistentes una base sólida sobre la gestión de infraestructura en Kubernetes, poniendo el foco en la seguridad, la monitorización y el mantenimiento de clústeres. A través de prácticas reales, se capacitará a los participantes para aplicar conocimientos directamente en entornos de producción.

## 🧰 Requisitos mínimos para realizar los laboratorios

* Acceso a un clúster Kubernetes funcional (se utilizará kind)
* En Windows, disponer de WSL2 habilitado y Docker Desktop o Rancher Desktop
* Herramientas: `kubectl`, acceso SSH si aplica, Visual Studio Code, Lens
* Acceso a Prometheus + AlertManager (puede ser compartido)

---

## 🧪 Laboratorios por sesión

### 🧭 Sesión 1: Introducción a la infraestructura de Kubernetes

**Temas:** Fundamentos del clúster, gestión de workloads y almacenamiento

* **Fase 1:** Despliegue del clúster local con kind
* **Fase 2:** Exploración inicial de recursos con kubectl
* **Fase 3:** Networking básico entre pods (busybox)
* **Fase 4:** Comparativa entre ReplicaSet, DaemonSet y StatefulSet
* **Fase 5:** Uso de volúmenes: `emptyDir` y PVC
* **Fase 6:** Limpieza de imágenes y espacio

---

### 🔐 Sesión 2: Gestión de usuarios y seguridad por namespaces

**Temas:** ServiceAccounts, RBAC, NetworkPolicies

* **Fase 1:** Crear namespace y roles de solo lectura
* **Fase 2:** Crear ServiceAccount limitada y asociarla a un pod
* **Fase 3:** Pruebas de acceso a recursos según permisos
* **Fase 4:** Aplicar NetworkPolicies entre pods según etiquetas
* **Fase 5:** Validar conectividad antes y después de aplicar reglas
* **Fase 6:** Comprobación de auditoría básica con `kubectl auth can-i`

---

### 📈 Sesión 3: Monitorización y gestión de alertas

**Temas:** Prometheus, AlertManager, logs y resolución de fallos

* **Fase 1:** Desplegar Prometheus + AlertManager (stack base)
* **Fase 2:** Crear alertas por estado de pods y CPU
* **Fase 3:** Probar notificaciones y simular condiciones
* **Fase 4:** Acceso a logs con `kubectl logs` y `stern`
* **Fase 5:** Introducir errores intencionados y analizar logs
* **Fase 6:** Correlación entre alertas y eventos

---

### 🛠️ Sesión 4: Mantenimiento y comportamiento del clúster

**Temas:** Drenado de nodos, rescheduling, uso de recursos

* **Fase 1:** Marcar nodos como `cordon` y `uncordon`
* **Fase 2:** Drenar nodo y observar redistribución de pods
* **Fase 3:** Simular fallo de nodo en entorno VM (Hyper-V)
* **Fase 4:** Uso de `kubectl top`, `describe` y `events`
* **Fase 5:** Identificar pods con recursos mal definidos
* **Fase 6:** Liberar espacio y verificar uso tras limpieza

---

### 🧪 Sesión 5 (remota): Repaso integral y validación práctica

**Temas:** Caso práctico final, buenas prácticas y resolución de dudas

* **Fase 1:** Desplegar microservicio ejemplo (nginx o api demo)
* **Fase 2:** Crear ServiceAccount y RBAC para dicho servicio
* **Fase 3:** Aplicar NetworkPolicy para segmentar acceso
* **Fase 4:** Añadir reglas de alerta y testearlas
* **Fase 5:** Introducir fallo controlado y revisar logs + métricas
* **Fase 6:** Evaluar el estado del clúster y elaborar informe final

---

## 📝 Examen final (15 min)

10 preguntas tipo test para validar los conocimientos clave adquiridos.

---

Para cada fase de laboratorio, consulta los documentos específicos en este repositorio.
