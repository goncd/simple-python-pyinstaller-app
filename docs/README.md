# Entregable 3, Virtualización de Sistemas 2024-2025

## Instalación y puesta en marcha de Jenkins y DinD
1. Creamos la imagen personalizada de Docker con Jenkins y los plugins necesarios: `docker build -t myjenkins-blueocean .`
2. Descargamos el proveedor de Docker necesario: `terraform init`
3. Aplicamos la configuración de Terraform: `terraform apply`
4. Accedemos al contenedor de Jenkins para poder obtener la contraseña necesaria para configurar el sistema:
```
docker exec -ti jenkins-blueocean cat /var/jenkins_home/secrets/initialAdminPassword
```
5. Accedemos a http://localhost:8080 y seguimos el instalador para configurar Jenkins:
    - Seleccionamos instalar los plugins sugeridos.
    - Creamos un usuario (aunque se puede usar el usuario administrador).
    - Reiniciamos el contenedor de Jenkins.

## Creación del pipelane
1. Hacemos clic en "Nueva tarea" en el menú de la izquierda.
2. Introducimos un nombre para la tarea, por ejemplo "Entrega 3", y seleccionamos "Pipeline".
3. Hacemos clic en "OK".
4. En la sección "Definición de Pipeline" seleccionamos "Pipeline script from SCM".
5. En SCM seleccionamos "Git".
6. En "Repository URL" ponemos la URL de mi repositorio, `https://github.com/goncd/simple-python-pyinstaller-app.git`.
7. En "Branches to build", añadimos la branch `main`, que es la que tiene la información de este entregable.
8. En "Script Path" ponemos `docs/Jenkinsfile`, que es la ruta donde se encuentra el fichero Jenkins dentro del repositorio.
9. Hacemos clic en "Guardar".
10. En el menú de la izquierda, hacemos clic en "Construir ahora".

También se puede utilizar la interfaz de Blue Ocean, accesible desde el menú de la izquierda.

Una vez se haya construido la aplicación, el artefacto generado se puede descargar accediendo al trabajo que se ha generado.

## Limpieza
Para limpiar todos los cambios en el sistema, basta con destruir la infraestructura ejecutando `terraform destroy` en el host.