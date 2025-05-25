# 🔐 Sesión 2 – Fase 1: Namespace y Roles de Lectura

## 🎯 Objetivo

Crear un namespace dedicado y establecer un Role de solo lectura sobre los pods del namespace, vinculado a una ServiceAccount.

---

## 📁 Recursos YAML

### 1. Namespace

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: seguridad
```

### 2. Role de solo lectura sobre Pods

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: seguridad
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list", "watch"]
```

### 3. ServiceAccount

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: lector-sa
  namespace: seguridad
```

### 4. RoleBinding asociado a la SA

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: lectura-pods
  namespace: seguridad
subjects:
- kind: ServiceAccount
  name: lector-sa
  namespace: seguridad
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

---

## 🧭 Pasos para aplicar los recursos

```bash
kubectl apply -f namespace.yaml
kubectl apply -f role-readonly.yaml
kubectl apply -f serviceaccount.yaml
kubectl apply -f rolebinding.yaml
```

O alternativamente, sin archivos intermedios:

```bash
kubectl create namespace seguridad
kubectl create role pod-reader \
  --verb=get --verb=list --verb=watch \
  --resource=pods -n seguridad
kubectl create serviceaccount lector-sa -n seguridad
kubectl create rolebinding lectura-pods \
  --role=pod-reader \
  --serviceaccount=seguridad:lector-sa \
  -n seguridad
```

---

## 🔍 Comprobación de permisos

```bash
kubectl auth can-i list pods \
  --as=system:serviceaccount:seguridad:lector-sa \
  -n seguridad
```

Debe devolver:

```bash
yes
```

---

## 🔥 Reto opcional

Intenta reutilizar el `RoleBinding` o el `Role` en otro namespace como `default`. Comprueba con:

```bash
kubectl auth can-i get pods \
  --as=system:serviceaccount:seguridad:lector-sa \
  -n default
```

Debe devolver:

```bash
no
```

Explicación: Los Roles y RoleBindings son **namespaced**, por lo tanto no se aplican fuera del namespace donde fueron definidos.

---

## ✅ Validación final

* El namespace `seguridad` existe y está activo.
* La `ServiceAccount` puede listar pods en su propio namespace.
* No tiene permisos fuera de él.
* El acceso está correctamente limitado según las reglas RBAC.

Puedes extender esto en la siguiente fase lanzando pods con esta ServiceAccount y haciendo pruebas desde dentro.
