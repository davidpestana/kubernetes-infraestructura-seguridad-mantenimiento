# Laboratorio 01 - Fase 3: Networking básico entre pods

## 🎯 Objetivo

Comprobar la conectividad entre pods dentro del mismo namespace y entender el modelo de red plano de Kubernetes.

## 🛠️ Descripción

Se desplegarán pods de tipo `busybox` para realizar pruebas de conectividad mediante `ping`, `nslookup` y `wget`. El objetivo es visualizar cómo Kubernetes permite que todos los pods se comuniquen entre sí por defecto.

## 🔧 Pasos

1. Crear un nuevo namespace de pruebas:

   ```bash
   kubectl create namespace net-test
   ```

2. Lanzar dos pods de tipo `busybox` en el namespace:

   ```bash
   kubectl run busybox-a --image=busybox:1.28 --namespace=net-test --restart=Never --tty -i -- sh
   # dentro del pod, mantenerlo abierto o abrir otro terminal para el segundo pod

   kubectl run busybox-b --image=busybox:1.28 --namespace=net-test --restart=Never --tty -i -- sh
   ```

3. En uno de los pods, intentar hacer ping al otro:

   ```sh
   ping busybox-b
   ```

   (sal del pod con Ctrl+C y luego `exit`)

4. Alternativamente, usar `nslookup` o `wget` si están disponibles:

   ```sh
   nslookup busybox-b
   wget busybox-b
   ```

5. Salir del pod escribiendo `exit`

## 🔥 Retos

* **Comprueba que los pods pueden resolverse por DNS dentro del namespace**
  🔧 *Tip:* Prueba también con `busybox-b.net-test.svc.cluster.local`

* **Verifica que los pods no se comunican si están en namespaces distintos**
  🔧 *Tip:* Crea un pod en otro namespace y comprueba que el DNS no resuelve por nombre corto

* **Usa `kubectl exec` en lugar de `--tty` para ejecutar comandos puntuales**
  🔧 *Tip:* `kubectl exec -n net-test busybox-a -- ping -c 3 busybox-b`

## ✅ Validaciones

* Los pods pueden resolverse entre sí usando nombres DNS
* El ping entre pods en el mismo namespace funciona
* Se ha probado al menos una resolución con FQDN
* Se ha identificado que la comunicación entre namespaces depende del nombre completo
