### Fase 5: Identificar pods con recursos mal definidos

---

### 🎯 Objetivo

Detectar pods que no tienen límites o peticiones de recursos establecidos correctamente, lo que puede afectar a la estabilidad y predictibilidad del clúster.

---

### 🧰 Requisitos

* Clúster en funcionamiento con múltiples pods
* `kubectl` y `metrics-server` instalados
* Conocimientos básicos de `resources.requests` y `resources.limits`

---

### 🔧 Pasos

1. Listar todos los pods con sus namespaces:

   ```bash
   kubectl get pods -A
   ```

2. Inspeccionar los recursos de un pod:

   ```bash
   kubectl get pod <nombre> -n <namespace> -o jsonpath='{.spec.containers[*].resources}'
   ```

3. Alternativamente, usar `kubectl describe pod` y buscar la sección de recursos:

   ```bash
   kubectl describe pod <nombre> -n <namespace>
   ```

4. Identificar pods sin `requests` ni `limits` definidos:

   * `requests: null`
   * `limits: null` o ausentes

5. Revisar el consumo real con `kubectl top` y comparar con la configuración declarada.

---

### 🔥 Retos

* **Encuentra todos los pods sin `limits` definidos en todo el clúster**
  💡 Usa un bucle como:

  ```bash
  kubectl get pods -A -o json | jq '.items[] | select(.spec.containers[].resources.limits == null) | .metadata.name'
  ```

* **Implementa una política que exija definir límites con `LimitRange`**
  💡 Aplica un `LimitRange` en un namespace y lanza un pod sin definir recursos.

* **Compara dos pods idénticos, uno con límites ajustados y otro sin ellos, bajo carga**
  💡 Lanza ambos y monitorea con `kubectl top`.

---

### ✅ Validaciones

* Se han identificado pods sin `requests` o `limits` definidos
* Se comprende el impacto de no configurar correctamente los recursos
* Se ha validado al menos un ejemplo de consumo excesivo debido a ausencia de límites
