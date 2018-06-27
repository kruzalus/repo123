Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.provider :virtualbox do |vb|
	  vb.customize ["modifyvm", :id, "--memory", 4096]
	  vb.customize ["modifyvm", :id, "--cpus", 2]
  end
  config.vm.synced_folder "./", "/home/vagrant/repo" 
  config.vm.provision :shell, path: "install_nginx.sh"
  config.vm.provision :shell, path: "install_mysql.sh"
  config.vm.provision :shell, path: "configure_php.sh"
  config.vm.network :forwarded_port, guest: 80, host: 4167
end