Vagrant.configure("2") do |config|

  config.vm.define "db" do |db|
    db.vm.box = "ubuntu/bionic64" # os
    db.vm.network "forwarded_port", guest: 3306, host: 3306
    db.vm.network "private_network", ip: "192.168.10.21"
    db.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver2", "on"]
      v.memory = "1024"
      v.name = "db"
    end
    db.vm.provision "shell", path: "provision/db_provider.sh"
  end
  
  config.vm.define "app" do |app|
    app.vm.box = "ubuntu/bionic64"
    app.vm.network "forwarded_port", guest: 26112, host: 26110  
    app.vm.network "private_network", ip: "192.168.10.31"
    app.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver2", "on"]
      v.memory = "4096"
      v.name = "app"
    end
    app.vm.provision "shell", path: "provision/app_vm_provision.sh"

  end

#  config.vm.define "proxy" do |proxy|
#    proxy.vm.box = "centos/7"
#    proxy.vm.network "public_network"
#    proxy.vm.network "forwarded_port", guest: 80, host: 8080
#    proxy.vm.network "forwarded_port", guest: 443, host: 8888
#    proxy.vm.network "private_network", ip: "192.168.10.11"
#    proxy.vm.provider :virtualbox do |v|
#      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
#      v.memory = "2048"
#      v.name = "proxy"
#    end
#    proxy.vm.provision "shell", path: "provision/proxy_vm_provision.sh"
#  end


end