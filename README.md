# Practicas Administración de Servidores

Mediante el uso de contenedores Docker hemos creado una infraestructura que simula un entorno de desarrollo de una empresa real, teniendo en cuenta los requisitos y las funcionalidades que debe de cumplir el mismo.

Pero antes de todo, vamos a ver que es **Docker** y que lo compone.

## ¿Qué es Docker?

**_Docker_** es una plataforma de código abierto que revoluciona la forma de crear, desplegar y ejecutar aplicaciones mediante el uso de contenedores. Los contenedores Docker son unidades estandarizadas de software que encapsulan una aplicación junto con todas sus dependencias, bibliotecas y archivos de configuración necesarios para su ejecución. Algunos de los aspectos clave de Docker incluyen:
- **_Portabilidad_**: Las aplicaciones empaquetadas en contenedores Docker pueden ejecutarse de manera consistente en cualquier entorno que soporte Docker.
- **_Aislamiento_**: Cada contenedor funciona de forma independiente, lo que proporciona un entorno seguro y aislado para las aplicaciones.
- **_Eficiencia en recursos_**: Los contenedores comparten el kernel del sistema operativo anfitrión, lo que los hace más eficientes en términos de recursos.

### ¿Por qué Docker Compose?

Hemos hecho uso de **_Docker Compose_** debido a que es una herramienta esencial para el desarrollo y despliegue de aplicaciones multi-contenedor. Algunas de las razones clave para su uso incluyen:
- **_Simplicidad y automatización_**: Docker Compose permite definir y ejecutar aplicaciones complejas de varios contenedores de forma fácil y rápida.
- **_Consistencia en entornos_**: Proporciona entornos de desarrollo idénticos para todos los miembros del equipo, eliminando el problema de "funciona en mi máquina".
- **_Gestión de dependencias_**: Facilita la gestión de las dependencias entre contenedores, permitiendo definir el orden de inicio y las conexiones entre servicios.

Como veremos a continuación, nuestra infraestructura contendrá varias redes, las cuales tienen en su interior un cierto número de contenedores Docker con una funcionalidad específica. Por tanto, el uso de Docker Compose nos permite manejar con facilidad esta infraestructura multi-contenedor.

<!-- ## Requisitos de la infraestructura
El cliente nos comunicó que la infraestructura se debe de componer de los siguiente:

//Insertar imagen de la infra estructura con los componentes

### Red de Desarrollo

  //Poner que hace cada contenedor de la red (así en todos las redes)

### Red de Servicios

### Red de Producción

## Configuración de los Servicios Web y Bases de Datos

//Contenedores usados y explicar como y porque hemos hecho de esa manera el docker file para cada contenedor que contenga un web server y una base de datos.

## Configuración de las direcciones IP y VPN

//Poner imagen gns3 con las subredes con las IPs para explicar la configuración.

### Conectividad VPN y Configuración DHCP

//Porque hemos usado un contenedor docker con debian haciendo uso de openvpn y dhcp.
//Como se ha realizado la configuración.

### Resolución DNS y NAS

//Configuración del servidor DNS de la red de servicios y el NAS.
 -->
