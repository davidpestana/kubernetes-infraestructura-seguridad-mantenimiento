### Fase 2: Crear ServiceAccount y RBAC para dicho servicio

---

### 🎯 Objetivo

Crear una cuenta de servicio dedicada al microservicio desplegado, y restringir sus permisos mediante roles RBAC para mejorar la seguridad del entorno.

---

### 🧰 Requisitos

* Microservicio desplegado (por ejemplo, `nginx-demo` en namespace `demo`)
* Acceso a `kubectl`
* Conocimientos básicos sobre `ServiceAccount`, `Role` y `RoleBinding`

---

### 🔧 Pasos

1. Crear una cuenta de servicio específica para la app:

   ```yaml
   kubectl apply -n demo -f - <<EOF
   apiVersion: v1
   kind: ServiceAccount
   metadata:
     name: nginx-sa
   EOF
   ```

2. Crear un rol con permisos mínimos (por ejemplo, solo lectura de pods):

   ```yaml
   kubectl apply -n demo -f - <<EOF
   apiVersion: rbac.authorization.k8s.io/v1
   kind: Role
   metadata:
     name: pod-reader
   rules:
   - apiGroups: [""]
     resources: ["pods"]
     verbs: ["get", "list"]
   EOF
   ```

3. Asociar la cuenta al rol mediante RoleBinding:

   ```yaml
   kubectl apply -n demo -f - <<EOF
   apiVersion: rbac.authorization.k8s.io/v1
   kind: RoleBinding
   metadata:
     name: read-pods
   subjects:
   - kind: ServiceAccount
     name: nginx-sa
     namespace: demo
   roleRef:
     kind: Role
     name: pod-reader
     apiGroup: rbac.authorization.k8s.io
   EOF
   ```

4. Editar el Deployment para usar la nueva cuenta de servicio:

   ```bash
   kubectl patch deployment nginx-demo -n demo \
     --type='json' -p='[{"op": "add", "path": "/spec/template/spec/serviceAccountName", "value": "nginx-sa"}]'
   ```

5. Verificar que los nuevos pods usan correctamente la cuenta:

   ```bash
   kubectl get pods -n demo -o jsonpath="{.items[*].spec.serviceAccountName}"
   ```

---

### 🔥 Retos

* **Crea un rol con permisos para listar `ConfigMap` y `Secrets` y pruébalo con otra cuenta**
  💡 Asegúrate de que no se mezclan permisos entre ServiceAccounts.

* **Ejecuta un pod temporal con esa cuenta y prueba el acceso mediante `kubectl exec`**
  💡 Usa `kubectl auth can-i list pods --as system:serviceaccount:demo:nginx-sa`.

* **Crea un Role que impida listar pods y comprueba el error al intentarlo desde dentro del contenedor**
  💡 Usa `curl localhost:8001/api/v1/pods` y revisa la respuesta 403.

---

### ✅ Validaciones

* La cuenta `nginx-sa` está en uso por los pods del Deployment
* Los permisos asignados se aplican correctamente
* El acceso a recursos no permitidos queda bloqueado según la configuración del Role
