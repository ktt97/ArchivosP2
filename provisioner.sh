echo "Se detienen servicios"

service NetworkManager stop
chkconfig NetworkManager off

echo "Instalando vim en server firewall"

sudo yum install vim -y

echo "Iniciamos servicio firewalld"

service firewalld start

echo "Configuracion del archivo systcl.conf, FORWARDING"

sudo echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf

echo "configuraciones de zonas public e internal"

firewall-cmd --set-default-zone=public
firewall-cmd --zone=public --add-interface=eth1
firewall-cmd --zone=internal --add-interface=eth2

firewall-cmd --zone=public --add-masquerade
firewall-cmd --zone=internal --add-masquerade


echo "configuraciones de servicios en zonas public e internal"

firewall-cmd --zone=public --add-service=ftp
firewall-cmd --zone=public --add-service=dns
firewall-cmd --zone=internal --add-service=ftp
firewall-cmd --zone=internal --add-service=dns

echo "Redireccion de puertos"

firewall-cmd --zone=public --add-forward-port=port=21:proto=tcp:toport=21:toaddr=192.168.50.7
firewall-cmd --zone=public --add-forward-port=port=53:proto=udp:toport=53:toaddr=192.168.50.7
firewall-cmd --zone=public --add-forward-port=port=1024:proto=tcp:toport=1024:toaddr=192.168.50.7
firewall-cmd --zone=public --add-forward-port=port=1025:proto=tcp:toport=1025:toaddr=192.168.50.7
firewall-cmd --zone=public --add-forward-port=port=1026:proto=tcp:toport=1026:toaddr=192.168.50.7

echo "apertura de puerto 21"

firewall-cmd --zone=public --add-port=21/tcp
firewall-cmd --zone=public --add-port=20/tcp
firewall-cmd --zone=public --add-port=53/udp
firewall-cmd --zone=public --add-port=1024-1034/tcp