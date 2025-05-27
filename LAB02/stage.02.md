# 🔐 Sesión 2 – Fase 2: ServiceAccount + Pod limitado

## 🎯 Objetivo

Desplegar un pod que use una ServiceAccount con permisos restringidos definidos en la fase anterior, y verificar sus capacidades desde dentro del contenedor.

---

## 📁 Recursos YAML

### 1. Pod con ServiceAccount `lector-sa`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-restringido
  namespace: seguridad
spec:
  serviceAccountName: lector-sa
  containers:
  - name: shell
    image: busybox
    command: ["sh", "-c", "sleep 3600"]
```

---

## 🧭 Pasos detallados

1. **Aplicar el pod:**

```bash
kubectl apply -f pod-restringido.yaml
```

2. **Esperar a que esté en estado Running:**

```bash
kubectl get pod pod-restringido -n seguridad
```

3. **Entrar al pod:**

```bash
kubectl exec -it pod-restringido -n seguridad -- sh
```

4. **Verificar variables de entorno relacionadas con la SA:**

```bash
env | grep KUBERNETES
```

5. **Probar acceso a recursos del API Server:**

```bash
wget --no-check-certificate --header="Authorization: Bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" https://kubernetes.default.svc/api/v1/namespaces/seguridad/pods -O -
```

O utilizando herramientas instaladas en la imagen:

```bash
nslookup kubernetes.default
```

---

## 🔥 Reto opcional

Instala (temporalmente) una imagen más completa con `curl` o `httpie` y verifica:

* ¿Qué ocurre si se intenta acceder a otros endpoints del API?
* ¿Qué respuestas da el servidor (403, 401)?

---

## ✅ Validación del aprendizaje

* El pod se ha desplegado en el namespace correcto con la SA restringida
* El acceso al API de Kubernetes está limitado según el Role definido
* El token montado en el pod corresponde con la `lector-sa`
* El acceso a recursos externos está sujeto a los permisos RBAC heredados

Puedes continuar con pruebas más avanzadas de acceso y denegación en la siguiente fase.
