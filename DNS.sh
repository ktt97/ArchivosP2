echo "Instalar servicios"

sudo -i 

sudo yum install bind-utils bind-libs bind-* -y

echo “Configurar DNS maestro”

sudo sed -i 's|listen-on port 53 { 127.0.0.1; };| listen-on port 53 { 127.0.0.1; 192.168.50.8; };|g' /etc/named.conf

sudo sed -i 's|allow-query     { localhost; };|allow-query     { localhost; 192.168.50.0/24; };allow-transfer { 192.168.50.7; };also-notify { 192.168.50.4; };|g' /etc/named.conf

sudo echo "zone @ettv.com@ IN {" >> /etc/named.conf
sudo echo "type master;" >> /etc/named.conf
sudo echo "file @ettv.com.fwd@;" >> /etc/named.conf
sudo echo "};" >> /etc/named.conf

sudo sed -i 's|zone @ettv.com@ IN {|zone "ettv.com" IN {|g' /etc/named.conf
sudo sed -i 's|file @ettv.com.fwd@;|file "ettv.com.fwd";|g' /etc/named.conf

sudo echo "zone @50.168.192.in-addr.arpa@ IN {" >> /etc/named.conf
sudo echo "type master;" >> /etc/named.conf
sudo echo "file @ettv.com.rev@;" >> /etc/named.conf
sudo echo "};" >> /etc/named.conf

sudo sed -i 's|zone @50.168.192.in-addr.arpa@ IN {|zone "50.168.192.in-addr.arpa" IN {|g' /etc/named.conf
sudo sed -i 's|file @ettv.com.rev@;|file "ettv.com.rev";|g' /etc/named.conf


echo "Creando zonas"

sudo touch /var/named/ettv.com.fwd
sudo touch /var/named/ettv.com.rev

sudo chmod 755 /var/named/ettv.com.fwd
sudo chmod 755 /var/named/ettv.com.rev

sudo echo "@ORIGIN ettv.com." >> /var/named/ettv.com.fwd
sudo echo "@TTL 3H" >> /var/named/ettv.com.fwd

sudo sed -i 's|@ORIGIN ettv.com.|$ORIGIN ettv.com.|g' /var/named/ettv.com.fwd
sudo sed -i 's|@TTL 3H|$TTL 3H|g' /var/named/ettv.com.fwd


sudo echo "@       IN SOA  serverm.ettv.com. root@ettv.com. (" >> /var/named/ettv.com.fwd
sudo echo "                                        2       ; serial" >> /var/named/ettv.com.fwd
sudo echo "                                        1D      ; refresh" >> /var/named/ettv.com.fwd
sudo echo "                                        1H      ; retry" >> /var/named/ettv.com.fwd
sudo echo "                                        1W      ; expire" >> /var/named/ettv.com.fwd
sudo echo "                                        3H )    ; minimum" >> /var/named/ettv.com.fwd
sudo echo "@       IN      NS      serverm.ettv.com." >> /var/named/ettv.com.fwd
sudo echo "@       IN      NS      servers.ettv.com." >> /var/named/ettv.com.fwd

sudo echo "serverm IN      A       192.168.50.8" >> /var/named/ettv.com.fwd
sudo echo "servers IN      A       192.168.50.7" >> /var/named/ettv.com.fwd

sudo echo "fwpriv IN       A       192.168.50.6" >> /var/named/ettv.com.fwd
sudo echo "fwpub IN        A       192.168.10.20" >> /var/named/ettv.com.fwd

sudo echo "phone   IN      A       192.168.10.25" >> /var/named/ettv.com.fwd

sudo echo "@ORIGIN 50.168.192.in-addr.arpa." >> /var/named/ettv.com.rev
sudo echo "@TTL 3H" >> /var/named/ettv.com.rev

sudo sed -i 's|@ORIGIN 50.168.192.in-addr.arpa.|$ORIGIN 50.168.192.in-addr.arpa.|g' /var/named/ettv.com.rev
sudo sed -i 's|@TTL 3H|$TTL 3H|g' /var/named/ettv.com.rev

sudo echo "@       IN SOA  serverm.ettv.com. root@ettv.com. (" >> /var/named/ettv.com.rev
sudo echo "                                        2       ; serial" >> /var/named/ettv.com.rev
sudo echo "                                        1D      ; refresh" >> /var/named/ettv.com.rev
sudo echo "                                        1H      ; retry" >> /var/named/ettv.com.rev
sudo echo "                                        1W      ; expire" >> /var/named/ettv.com.rev
sudo echo "                                        3H )    ; minimum" >> /var/named/ettv.com.rev
sudo echo "@       IN      NS      serverm.ettv.com." >> /var/named/ettv.com.rev
sudo echo "@       IN      NS      servers.ettv.com." >> /var/named/ettv.com.rev

sudo echo "8 IN      PTR       serverm.ettv.com." >> /var/named/ettv.com.rev
sudo echo "7 IN      PTR       servers.ettv.com." >> /var/named/ettv.com.rev

sudo echo "6 IN      PTR       fwpriv.ettv.com." >> /var/named/ettv.com.rev

sudo service named start

exit