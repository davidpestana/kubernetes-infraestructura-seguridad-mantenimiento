### Fase 3: Aplicar NetworkPolicy para segmentar acceso

---

### 🎯 Objetivo

Restringir el acceso a los pods del microservicio mediante NetworkPolicies basadas en etiquetas y namespaces, aplicando el principio de mínimo privilegio a nivel de red.

---

### 🧰 Requisitos

* CNI compatible con NetworkPolicies (por ejemplo, Calico)
* Microservicio desplegado en el namespace `demo`
* Al menos un pod lanzado desde otro namespace para simular tráfico externo

---

### 🔧 Pasos

1. Confirmar que no hay NetworkPolicies aplicadas:

   ```bash
   kubectl get networkpolicy -n demo
   ```

2. Crear una política que niegue todo el tráfico de entrada:

   ```yaml
   kubectl apply -n demo -f - <<EOF
   apiVersion: networking.k8s.io/v1
   kind: NetworkPolicy
   metadata:
     name: deny-all-ingress
   spec:
     podSelector: {}
     policyTypes:
     - Ingress
   EOF
   ```

3. Comprobar que el microservicio ya no es accesible:

   ```bash
   kubectl run curltest --image=curlimages/curl -it --rm --restart=Never \
     --command -- curl nginx-service.demo.svc.cluster.local
   ```

4. Crear una política que permita solo tráfico del mismo namespace:

   ```yaml
   kubectl apply -n demo -f - <<EOF
   apiVersion: networking.k8s.io/v1
   kind: NetworkPolicy
   metadata:
     name: allow-same-namespace
   spec:
     podSelector:
       matchLabels:
         app: nginx-demo
     policyTypes:
     - Ingress
     ingress:
     - from:
       - podSelector: {}
   EOF
   ```

5. Comprobar que ahora solo los pods dentro del namespace `demo` pueden acceder:

   * Desde otro namespace: ❌ bloqueado
   * Desde `demo`: ✅ permitido

---

### 🔥 Retos

* **Crea una NetworkPolicy que solo permita acceso desde un pod específico con label `role=frontend`**
  💡 Usa `from → podSelector → matchLabels`.

* **Permite únicamente tráfico TCP por el puerto 80**
  💡 Añade un bloque `ports` con `port: 80`.

* **Aplica una política e inspecciona los logs o métricas para confirmar que se bloquea tráfico no deseado**
  💡 Usa `kubectl logs` o Prometheus.

---

### ✅ Validaciones

* El tráfico queda bloqueado por defecto al aplicar `deny-all`
* Solo los pods permitidos por las reglas acceden al servicio
* Se comprenden los conceptos de `podSelector`, `from`, y `policyTypes` en NetworkPolicy
