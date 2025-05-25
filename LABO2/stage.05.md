# 🔐 Sesión 2 – Fase 5: Validación de conectividad

## 🎯 Objetivo

Comprobar el efecto práctico de las NetworkPolicies aplicadas en la fase anterior, observar el tráfico permitido/bloqueado y validar cómo las etiquetas modifican el comportamiento de las reglas.

---

## 📁 Escenario base

* Namespace: `seguridad`
* Pods:

  * `pod-frontend` (puede tener o no `access: granted`)
  * `pod-backend` (receptor de tráfico)
* NetworkPolicies:

  * `deny-all` (bloquea todo)
  * `allow-from-granted` (permite solo desde pods con etiqueta `access: granted`)

---

## 🧭 Pasos detallados

1. **Verificar el estado actual de las etiquetas:**

```bash
kubectl get pods -n seguridad --show-labels
```

2. **Probar conexión desde `pod-frontend` a `pod-backend`:**

```bash
kubectl exec -it pod-frontend -n seguridad -- sh
wget -O - pod-backend.seguridad.svc.cluster.local
```

3. **Quitar o modificar etiquetas y probar el efecto:**

```bash
kubectl label pod pod-frontend -n seguridad access-
kubectl exec -it pod-frontend -n seguridad -- sh
wget -O - pod-backend.seguridad.svc.cluster.local
```

(la conexión debe fallar al eliminar la etiqueta)

4. **Observar eventos relacionados:**

```bash
kubectl describe pod pod-backend -n seguridad
```

---

## 🔥 Reto opcional

* Crea un nuevo pod (`pod-externo`) sin etiquetas y verifica que no puede comunicarse con `pod-backend`.
* Cambia dinámicamente las etiquetas de `pod-backend` y observa si pierde acceso autorizado.

```yaml
# pod-externo.yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-externo
  namespace: seguridad
spec:
  containers:
  - name: busybox
    image: busybox
    command: ["sh", "-c", "sleep 3600"]
```

---

## ✅ Validación del aprendizaje

* El tráfico entre pods está estrictamente regulado por las NetworkPolicies.
* Las etiquetas definen dinámicamente qué pods pueden comunicarse.
* Los alumnos comprenden que una política sin reglas de `ingress` **equivale a denegar todo el tráfico entrante**.

Esta validación práctica consolida el concepto de **seguridad a nivel de red** en Kubernetes.
