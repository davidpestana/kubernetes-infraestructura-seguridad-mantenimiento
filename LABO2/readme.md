# 🔐 Sesión 2: Seguridad por Namespaces

**Duración:** 3 horas
**Modalidad:** Presencial
**Objetivo general:** Introducir conceptos de aislamiento, control de acceso y políticas de red en Kubernetes utilizando namespaces, roles, ServiceAccounts y NetworkPolicies.

---

## 🔧 Requisitos previos

* Clúster funcionando (por ejemplo, creado con kind)
* `kubectl` configurado y operativo
* Conocimientos básicos de YAML y comandos previos

---

## 🔬 Fases del laboratorio

### 🔹 Fase 1: Namespace y roles de lectura

**🎯 Objetivo:** Crear un namespace y limitar permisos a solo lectura
**🧭 Pasos:**

1. Crear un nuevo namespace: `kubectl create ns seguridad`
2. Crear un Role con permisos `get`, `list`, `watch` sobre pods
3. Asociar un RoleBinding a un usuario ficticio o ServiceAccount
   **🔥 Reto:** Aplicar el Role en otro namespace y verificar que falla
   **✅ Validación:** Comprobación con `kubectl auth can-i` desde la cuenta limitada

---

### 🔹 Fase 2: ServiceAccount + pod limitado

**🎯 Objetivo:** Lanzar un pod con una ServiceAccount restringida
**🧭 Pasos:**

1. Crear una ServiceAccount en el namespace `seguridad`
2. Asignarle el Role con permisos limitados
3. Desplegar un pod usando esa ServiceAccount
   **🔥 Reto:** Comprobar qué puede y no puede hacer desde el pod
   **✅ Validación:** Evidencia mediante ejecución de `kubectl` o `curl`

---

### 🔹 Fase 3: Pruebas de acceso

**🎯 Objetivo:** Verificar que las restricciones están activas
**🧭 Pasos:**

1. Entrar al pod con `kubectl exec`
2. Intentar acceder a otros recursos: `/api`, `/api/v1/namespaces/default/pods`
3. Probar con `curl`, `wget`, `nslookup`
   **🔥 Reto:** Detectar qué endpoints están permitidos
   **✅ Validación:** Acceso fallido o denegado desde el pod a recursos no autorizados

---

### 🔹 Fase 4: NetworkPolicies por etiquetas

**🎯 Objetivo:** Restringir la comunicación entre pods según etiquetas
**🧭 Pasos:**

1. Desplegar dos pods con etiquetas distintas
2. Aplicar una NetworkPolicy que bloquee todo por defecto
3. Permitir solo tráfico desde pods con etiqueta `access: granted`
   **🔥 Reto:** Añadir una excepción temporal a la política
   **✅ Validación:** Solo los pods con etiqueta permitida pueden comunicarse

---

### 🔹 Fase 5: Validación de conectividad

**🎯 Objetivo:** Comprobar efectos de las NetworkPolicies
**🧭 Pasos:**

1. Ejecutar `ping`, `curl`, `wget` entre pods
2. Modificar etiquetas y verificar impacto
3. Observar eventos con `kubectl describe`
   **🔥 Reto:** Encontrar vía de escape o bypass posible
   **✅ Validación:** Cambios en etiquetas provocan cambio en accesos

---

### 🔹 Fase 6: Auditoría con `kubectl auth can-i`

**🎯 Objetivo:** Verificar quién puede hacer qué en el clúster
**🧭 Pasos:**

1. Ejecutar `kubectl auth can-i` con distintos usuarios y ServiceAccounts
2. Probar operaciones en distintos namespaces
3. Documentar permisos efectivos
   **🔥 Reto:** Detectar permisos heredados o inesperados
   **✅ Validación:** Informe claro de capacidades por rol y namespace

---

## 🧠 Reflexión final de la sesión

* ¿Qué diferencias hay entre un Role y un ClusterRole?
* ¿Qué ocurre si una NetworkPolicy bloquea el tráfico DNS?
* ¿Cómo auditarías los accesos a recursos sensibles en un entorno real?

---

## 📁 Archivos recomendados por fase

* `role-readonly.yaml`, `rolebinding.yaml`
* `serviceaccount.yaml`, `pod-restricted.yaml`
* `networkpolicy-denyall.yaml`, `networkpolicy-allow-access.yaml`

---

## ✅ Comprobación de conocimientos al final de sesión

* ¿Cuál es el objetivo de usar ServiceAccounts en lugar de usuarios normales?
* ¿Qué implicaciones tiene definir una NetworkPolicy sin reglas de ingreso?
* ¿Cómo verificas los permisos de un pod sin acceso a `kubectl`?
* ¿En qué situaciones usarías ClusterRole en lugar de Role?
