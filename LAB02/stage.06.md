# 🔐 Sesión 2 – Fase 6: Auditoría con `kubectl auth can-i`

## 🎯 Objetivo

Utilizar herramientas nativas como `kubectl auth can-i` para auditar permisos efectivos de usuarios, ServiceAccounts y roles en el clúster, y detectar posibles fallos de seguridad o privilegios innecesarios.

---

## 🧭 Pasos detallados

1. **Ver permisos de la ServiceAccount `lector-sa` en el namespace `seguridad`:**

```bash
kubectl auth can-i list pods \
  --as=system:serviceaccount:seguridad:lector-sa \
  -n seguridad
```

2. **Probar permisos fuera del namespace asignado:**

```bash
kubectl auth can-i get pods \
  --as=system:serviceaccount:seguridad:lector-sa \
  -n default
```

3. **Inspeccionar una acción concreta como borrar pods:**

```bash
kubectl auth can-i delete pods \
  --as=system:serviceaccount:seguridad:lector-sa \
  -n seguridad
```

4. **Ver acciones permitidas en todo el clúster para un rol ClusterRole (requiere configuración previa):**

```bash
kubectl auth can-i list nodes --as=usuario-ficticio
```

(Si el usuario o rol no existe, responderá `no`)

5. **Listar todos los RoleBindings en un namespace:**

```bash
kubectl get rolebindings -n seguridad
```

6. **Describir un RoleBinding para entender su vínculo:**

```bash
kubectl describe rolebinding lectura-pods -n seguridad
```

---

## 🔥 Reto opcional

* Crea una nueva ServiceAccount sin asignarle Role ni RoleBinding.
* Usa `kubectl auth can-i` para comprobar que no puede realizar ninguna operación.

```bash
kubectl create serviceaccount sin-permisos -n seguridad
kubectl auth can-i get pods \
  --as=system:serviceaccount:seguridad:sin-permisos \
  -n seguridad
```

---

## ✅ Validación del aprendizaje

* El alumno sabe auditar qué puede hacer una ServiceAccount concreta en un namespace dado.
* Conoce la sintaxis de `kubectl auth can-i` para simular accesos.
* Distingue entre permisos namespaced (Role) y permisos globales (ClusterRole).

Esta fase permite desarrollar una visión crítica sobre **principios de menor privilegio** y facilitar tareas de auditoría y hardening de seguridad.
