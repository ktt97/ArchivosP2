# Parcial 2 Telecomunicaciones 3 Universidad Autonoma de Occidente Santiago de Cali, 2021

---

## Integrantes

- Julian __Adolfo__ Vega
- Kevin __Armando__ Trujillo

## Shell Provisioner (Firewall)
El archivo provisioner contiene el script con el aprovisionamiento automatico de la maquina Firewall. En él se especifican los comandos necesarios para la configuracion del servicio.

- Inicialmente se detienen los servicios que pueden causar conflicto con el funcionamiento del fw.
- Luego, se inicia la instalación de la herramienta vim para la modificación de archivos.
- Se inicia el servicio fw

- Se establece el re envio de datos con el comando y el archivo: 

```apache
net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
``` 

- Luego se establecen las interfaces y las zonas que se van a trabajar en el servicio. En nuestro caso se usó la zona public e internal.
- Se añaden el enmascaramiento en las dos zonas.
- Se añaden los servicios ftp y dns en cada zona.
- Finalmente se realiza la apertura y redirección de los puertos a usar con sus respectivos protocolos.

## Shell FTP (FTP seguro y DNS slave)

- En este archivo, se agregan los comandos necesarios para configurar el servicio FTP seguro (FTPS). Para ello entonces se modifica el archivo named.conf. 
- Dentro del archivo se especifica el tipo de conexion con el comando 
```apache
"pasv_enable=YES" >> /etc/vsftpd/vsftpd.conf
``` 
- Tambien fue indispensable especificar los puertos por los cuales se realiza la conexion entre servidor y cliente, ademas de la ip por la cual se va a conectar.
```apache
"pasv_min_port=1024" >> /etc/vsftpd/vsftpd.conf
"pasv_max_port=1026" >> /etc/vsftpd/vsftpd.conf
"#pasv_address=192.168.1.106" >> /etc/vsftpd/vsftpd.conf
``` 
- Adicionalmente se establecen los tipos de versiones del protocolo TLS a usar.
- Finalmente se habilita el sistema de seguridad mediante certificado y archivo de claves.

##### NOTA: Los archivos de certificado y la creación de usuarios se realizó manualmente.
- En esta maquina se instala tambien el servicio named en configuración esclavo. Para lograr su correcto funcionamiento, en el archivo de configuracion se comentan las lineas que permiten la comunicacion con el master, adicionalmente se crean los comandos para leer las zonas que en este caso no serán creadas en esta maquina sino en el master.

## Shell DNS (DNS Master)
- En una tercera maquina virtual se realiza la configuracion del servicio named master. Este servicio contiene todas las configuraciones que se han venido realizando en el curso; creacion y configuración de zonas (master).
- En el archivo named.conf, adicionalmente, se agregan dos comandos donde se especifica la redirección de zonas especificando la IP del DNS slave. 