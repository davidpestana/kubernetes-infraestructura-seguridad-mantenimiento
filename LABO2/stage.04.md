# 🔐 Sesión 2 – Fase 4: NetworkPolicies por etiquetas

## 🎯 Objetivo

Restringir la comunicación entre pods utilizando etiquetas y NetworkPolicies en el namespace `seguridad`.

---

## 📁 Recursos YAML

### 1. Pods etiquetados

```yaml
# pod-frontend.yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-frontend
  namespace: seguridad
  labels:
    app: frontend
spec:
  containers:
  - name: busybox
    image: busybox
    command: ["sh", "-c", "sleep 3600"]
---
# pod-backend.yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-backend
  namespace: seguridad
  labels:
    app: backend
spec:
  containers:
  - name: busybox
    image: busybox
    command: ["sh", "-c", "sleep 3600"]
```

### 2. NetworkPolicy que bloquea todo por defecto

```yaml
# deny-all.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
  namespace: seguridad
spec:
  podSelector: {}
  policyTypes:
  - Ingress
```

### 3. NetworkPolicy que permite acceso solo desde pods con etiqueta `access: granted`

```yaml
# allow-from-granted.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-from-granted
  namespace: seguridad
spec:
  podSelector:
    matchLabels:
      app: backend
  ingress:
  - from:
    - podSelector:
        matchLabels:
          access: granted
```

---

## 🧭 Pasos detallados

1. **Crear los pods:**

```bash
kubectl apply -f pod-frontend.yaml
kubectl apply -f pod-backend.yaml
```

2. **Probar conectividad inicial:**

```bash
kubectl exec -it pod-frontend -n seguridad -- sh
wget -O - pod-backend.seguridad.svc.cluster.local
```

(debería funcionar antes de aplicar la política)

3. **Aplicar la NetworkPolicy restrictiva:**

```bash
kubectl apply -f deny-all.yaml
```

4. **Comprobar que la comunicación está bloqueada:**

```bash
kubectl exec -it pod-frontend -n seguridad -- sh
wget -O - pod-backend.seguridad.svc.cluster.local
```

(esto debería fallar ahora)

5. **Añadir etiqueta `access: granted` al pod `pod-frontend`:**

```bash
kubectl label pod pod-frontend -n seguridad access=granted
```

6. **Aplicar la NetworkPolicy que permite acceso desde pods etiquetados:**

```bash
kubectl apply -f allow-from-granted.yaml
```

7. **Probar de nuevo la conexión:**

```bash
kubectl exec -it pod-frontend -n seguridad -- sh
wget -O - pod-backend.seguridad.svc.cluster.local
```

(ahora debería funcionar)

---

## 🔥 Reto opcional

* Crea un tercer pod sin etiqueta y comprueba que no puede acceder al backend.
* Modifica dinámicamente las etiquetas y observa los efectos en caliente.

---

## ✅ Validación del aprendizaje

* La política `deny-all` bloquea todo el tráfico entrante.
* La política `allow-from-granted` permite tráfico solo desde pods con una etiqueta concreta.
* El alumno comprende cómo usar `podSelector` para definir reglas granulares de ingreso.

Esta fase sienta las bases para asegurar el tráfico interno entre servicios de forma declarativa y escalable.
