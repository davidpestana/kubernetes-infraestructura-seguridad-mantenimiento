# 🔐 Sesión 2 – Fase 3: Pruebas de acceso desde un pod restringido

## 🎯 Objetivo

Verificar las capacidades reales de una ServiceAccount con permisos restringidos accediendo manualmente a la API de Kubernetes desde dentro de un pod.

---

## 📁 Recurso base: Pod `pod-restringido`

Usaremos el pod creado en la Fase 2 con ServiceAccount `lector-sa`, ya desplegado en el namespace `seguridad`.

---

## 🧭 Pasos detallados

1. **Entrar al pod:**

```bash
kubectl exec -it pod-restringido -n seguridad -- sh
```

2. **Inspeccionar el token montado:**

```bash
cat /var/run/secrets/kubernetes.io/serviceaccount/token | head -c 50
```

(Solo se muestra una parte por seguridad)

3. **Hacer una petición GET permitida (listar pods en su namespace):**

```bash
wget --no-check-certificate \
  --header="Authorization: Bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
  https://kubernetes.default.svc/api/v1/namespaces/seguridad/pods -O -
```

4. **Intentar acceder a otro recurso fuera del permiso:**

```bash
wget --no-check-certificate \
  --header="Authorization: Bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
  https://kubernetes.default.svc/api/v1/namespaces/default/pods -O -
```

5. **Observar respuestas (403 Forbidden o similar):**

---

## 🔥 Reto opcional

Acceder directamente a `/api`, `/api/v1`, `/apis` y enumerar qué recursos son accesibles:

```bash
wget --no-check-certificate \
  --header="Authorization: Bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
  https://kubernetes.default.svc/api -O -
```

Anotar y discutir:

* ¿Qué se muestra?
* ¿Qué endpoints están habilitados?
* ¿Qué información se filtra?

---

## ✅ Validación del aprendizaje

* El token montado en el pod da acceso únicamente a los recursos definidos en el Role `pod-reader`
* Las peticiones a recursos no autorizados devuelven errores 403 (Forbidden)
* La API responde correctamente a las limitaciones impuestas por RBAC

---

## 📌 Tip

Si se necesita más herramientas dentro del pod para hacer pruebas (por ejemplo, `curl`, `jq`, `httpie`), se puede usar una imagen como `praqma/network-multitool` o `alpine/curl`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: multitool
  namespace: seguridad
spec:
  serviceAccountName: lector-sa
  containers:
  - name: tool
    image: praqma/network-multitool
    command: ["sleep", "3600"]
```

```bash
kubectl exec -it multitool -n seguridad -- sh
```
