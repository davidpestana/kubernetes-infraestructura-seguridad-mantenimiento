## Laboratorio 02: Despliegue de aplicaciones GitOps con Argo CD y Kustomize

🎯 **Objetivo general**

Aprender a desplegar y gestionar aplicaciones en Kubernetes usando el enfoque GitOps con Argo CD y Kustomize. Se utilizará un clúster existente y se configurará un flujo completo desde repositorio Git hasta despliegue automático.

---

🧰 **Requisitos previos**

- Clúster Kubernetes en funcionamiento (puede ser el de Kubespray del lab anterior)
- `kubectl` configurado y operativo
- `kustomize` instalado (`sudo apt install kustomize` o `brew install kustomize`)
- Acceso a un repositorio Git con manifiestos Kubernetes

---

🔬 **Fases del laboratorio**

### Fase 1: Instalación de Argo CD

🎯 **Objetivo:** Tener el servidor de Argo CD desplegado y accesible.

🔧 **Pasos:**

1. Crear namespace:

```bash
kubectl create namespace argocd
```

2. Aplicar manifiestos oficiales:

```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

3. Esperar a que todos los pods estén en estado `Running`:

```bash
kubectl get pods -n argocd
```

🔥 **Reto:** Usar `stern` para observar logs en vivo de `argocd-server`.

---

### Fase 2: Exponer la interfaz web de Argo CD

🎯 **Objetivo:** Acceder a la UI de Argo CD desde el navegador.

🔧 **Pasos:**

1. Usar port-forwarding:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

2. Acceder desde el navegador a `https://localhost:8080`

3. Obtener la contraseña inicial:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
```

Usuario: `admin`

🔥 **Reto:** Crear un Ingress o NodePort para acceso permanente.

---

### Fase 3: Crear una aplicación con Kustomize desde Git

🎯 **Objetivo:** Desplegar una app que usa `kustomize` directamente desde un repositorio Git.

🔧 **Pasos:**

1. Crear repositorio Git con estructura:

```
my-app/
├── base/
│   ├── deployment.yaml
│   └── kustomization.yaml
├── overlays/dev/
│   ├── kustomization.yaml
│   └── patch.yaml
```

2. Crear aplicación desde CLI:

```bash
argocd login localhost:8080 --username admin --password <obtenido antes> --insecure

argocd app create my-app \
  --repo https://github.com/tuusuario/mi-repo.git \
  --path overlays/dev \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace default \
  --directory-recurse
```

3. Sincronizar y verificar:

```bash
argocd app sync my-app
argocd app get my-app
```

🔥 **Reto:** Cambiar algo en el repo Git y verificar que Argo CD lo aplica automáticamente.

---

✅ **Validaciones finales**

- Argo CD desplegado y accesible vía navegador
- App desplegada correctamente vía Kustomize desde Git
- Se visualizan cambios en vivo desde la interfaz de Argo
- Flujo Git → Clúster completamente funcional (GitOps básico)

