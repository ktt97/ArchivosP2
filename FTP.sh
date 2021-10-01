echo "Instalar servicios"

sudo -i

sudo yum install vsftpd -y
sudo yum install bind-utils bind-libs bind-* -y

echo "Configuracion de archivo vsftpd.conf"

sudo sed -i 's|connect_from_port_20=YES|connect_from_port_20=NO|g' /etc/vsftpd/vsftpd.conf
sudo sed -i 's|#chroot_local_user=YES|chroot_local_user=YES|g' /etc/vsftpd/vsftpd.conf
sudo sed -i 's|#chroot_list_enable=YES|chroot_list_enable=YES|g' /etc/vsftpd/vsftpd.conf
sudo sed -i 's|#chroot_list_file=/etc/vsftpd/chroot_list|chroot_list_file=/etc/vsftpd/chroot_list|g' /etc/vsftpd/vsftpd.conf
sudo sed -i 's|listen=NO|listen=YES|g' /etc/vsftpd/vsftpd.conf
sudo sed -i 's|listen_ipv6=YES|#listen_ipv6=YES|g' /etc/vsftpd/vsftpd.conf

sudo touch /etc/vsftpd/chroot_list

sudo echo "allow_writeable_chroot=YES" >> /etc/vsftpd/vsftpd.conf
sudo echo "anon_root=/var/ftp/pub" >> /etc/vsftpd/vsftpd.conf
sudo echo "pasv_enable=YES" >> /etc/vsftpd/vsftpd.conf
sudo echo "pasv_min_port=1024" >> /etc/vsftpd/vsftpd.conf
sudo echo "pasv_max_port=1026" >> /etc/vsftpd/vsftpd.conf
sudo echo "#ssl_enable=YES" >> /etc/vsftpd/vsftpd.conf
sudo echo "#pasv_address=192.168.1.106" >> /etc/vsftpd/vsftpd.conf
sudo echo "#allow_anon_ssl=YES" >> /etc/vsftpd/vsftpd.conf
sudo echo "#force_local_data_ssl=YES" >> /etc/vsftpd/vsftpd.conf
sudo echo "#force_local_logins_ssl=YES" >> /etc/vsftpd/vsftpd.conf
sudo echo "#ssl_tlsv1=YES" >> /etc/vsftpd/vsftpd.conf
sudo echo "#ssl_sslv2=YES" >> /etc/vsftpd/vsftpd.conf
sudo echo "#ssl_sslv3=YES" >> /etc/vsftpd/vsftpd.conf
sudo echo "#require_ssl_reuse=NO" >> /etc/vsftpd/vsftpd.conf
sudo echo "#rsa_cert_file=/etc/pki/tls/certs/ca.crt" >> /etc/vsftpd/vsftpd.conf
sudo echo "#rsa_private_key_file=/etc/pki/tls/private/ca.key" >> /etc/vsftpd/vsftpd.conf

echo "configuramos gateway para los servicios en la máquina."

sudo echo "GATEWAY=192.168.50.6" >> /etc/sysconfig/network
service network restart

echo "Iniciando el servicios"

sudo service vsftpd start

echo "Establecer la gateway por default"

sudo ip route del default via 10.0.2.2 dev eth0 proto dhcp metric 100

echo "Configurar DNS esclavo"

sudo sed -i 's|listen-on port 53 { 127.0.0.1; };|#listen-on port 53 { 127.0.0.1; };|g' /etc/named.conf

sudo sed -i 's|listen-on-v6 port 53 { ::1; };|#listen-on-v6 port 53 { ::1; };|g' /etc/named.conf

sudo sed -i 's|allow-query     { localhost; };|#allow-query     { localhost; 192.168.50.0/24; };|g' /etc/named.conf


sudo echo "zone @ettv.com@ IN {" >> /etc/named.conf
sudo echo "type slave;" >> /etc/named.conf
sudo echo "masters { 192.168.50.8; };" >> /etc/named.conf
sudo echo "file @slaves/ettv.com.fwd@;" >> /etc/named.conf
sudo echo "};" >> /etc/named.conf

sudo sed -i 's|zone @ettv.com@ IN {|zone "ettv.com" IN {|g' /etc/named.conf
sudo sed -i 's|file @slaves/ettv.com.fwd@;|file "slaves/ettv.com.fwd";|g' /etc/named.conf

sudo echo "zone @50.168.192.in-addr.arpa@ IN {" >> /etc/named.conf
sudo echo "type slave;" >> /etc/named.conf
sudo echo "masters { 192.168.50.8; };" >> /etc/named.conf
sudo echo "file @slaves/ettv.com.rev@;" >> /etc/named.conf
sudo echo "};" >> /etc/named.conf

sudo sed -i 's|zone @50.168.192.in-addr.arpa@ IN {|zone "50.168.192.in-addr.arpa" IN {|g' /etc/named.conf
sudo sed -i 's|file @slaves/ettv.com.rev@;|file "slaves/ettv.com.rev";|g' /etc/named.conf


sudo service named start

exit