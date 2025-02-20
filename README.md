# INFORMACIÓN IMPORTANTE
Esta imagen de docker lleva:
> - Visual Studio Code
> - Interfaz gráfica tight
> - Python
> - OpenSSH

*Derechos de: Àxel G*
 
 # Construir la imagen con docker build: 
 - Copiar el contenido del archivo llamado Dockerfile y xstartup
 - Poner el siguiente comando:
```
  docker build -t x .
```
*x = nombre de tu imagen*

En caso de querer  montar la imágen directamente, introducir lo siguiente:
```
  docker pull darmon04/actividad2:latest
```

# Ejecutar un nuevo contenedor con docker run: 
- Una vez ejecutado lo anteriormente mencionado, encendemos el contenedor con:
```
  docker run -d -p 5901:5901 -p 2222:22 --name x y
```
*x = nombre contenedor, y = nombre imagen*
 # Connectarse con un cliente VNC
 - Entramos a la APP llamada Remmina y introducimos lo siguiente:
```
  127.0.0.1:5901 
```
*La imagen se encuentra en:*
`https://hub.docker.com/repository/docker/darmon04/actividad2/tags`
