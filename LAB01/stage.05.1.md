## Laboratorio 01 - Fase 6: Servicios y Balanceo de Carga para Deployments

🎯 **Objetivo**
Comprender el funcionamiento de los `Service` en Kubernetes, su relación con los `Deployment`, y cómo se gestiona el balanceo de carga interno.

🛠️ **Descripción**
Se expondrá un Deployment de NGINX mediante un `Service` de tipo ClusterIP. Se realizarán pruebas de accesibilidad interna y observación del balanceo entre réplicas.

🔧 **Pasos**

1. **Reutilizar el namespace y Deployment anterior**  
Asegúrate de que el Deployment `nginx-deploy` del laboratorio anterior sigue activo.

2. **Crear un Service para exponer el Deployment**  
```bash
kubectl expose deployment nginx-deploy \
  --name=nginx-service \
  --port=80 \
  --target-port=80 \
  --namespace=deploy-test
```

3. **Obtener la IP del ClusterIP service y verificar**  
```bash
kubectl get svc nginx-service -n deploy-test
```

4. **Lanzar un pod temporal para probar el acceso al servicio**  
```bash
kubectl run -i --tty curl --image=curlimages/curl --rm --restart=Never --namespace=deploy-test -- sh
```
Una vez dentro del pod:
```sh
curl nginx-service
```

5. **Observar el balanceo entre réplicas**  
Repite varias veces el `curl` y revisa los logs de cada pod:
```bash
kubectl logs -n deploy-test -l app=nginx --tail=5
```

🔥 **Retos**

- Cambia el Service a tipo `NodePort` y accede desde el exterior del clúster si es posible
- Añade un header personalizado en la respuesta NGINX para identificar el pod que responde  
  🔧 Tip: Puedes modificar el configmap o la imagen para incluir `add_header Hostname $hostname;`

✅ **Validaciones**

- El servicio de tipo ClusterIP está creado y funcional
- Se puede acceder desde otro pod usando el nombre DNS del servicio
- El balanceo de carga distribuye las peticiones entre varias réplicas del Deployment
- Se han revisado los logs para validar el tráfico entre pods
