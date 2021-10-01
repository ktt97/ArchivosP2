Vagrant.configure("2") do |config|
config.vm.define :firewall do |firewall|
firewall.vm.box = "bento/centos-7.9"
firewall.vm.network "public_network", ip: "192.168.10.20"
firewall.vm.network :private_network, ip: "192.168.50.6"
firewall.vm.provision "shell", path: "provisioner.sh"
firewall.vm.hostname = "firewall"
end

config.vm.define :servidor do |servidor|
servidor.vm.box = "bento/centos-7.9"
servidor.vm.network :private_network, ip: "192.168.50.7"
servidor.vm.hostname = "servidor"
end

config.vm.define :servidorDNS do |servidorDNS|
servidorDNS.vm.box = "bento/centos-7.9"
servidorDNS.vm.network :private_network, ip: "192.168.50.8"
servidorDNS.vm.hostname = "servidorDNS"
end
end