Vagrant.require_version ">= 1.7.0"

Vagrant.configure("2") do |config|
    config.vm.define "devsecops_ci_server" do |devsecops_ci_server|
      devsecops_ci_server.vm.box = "hashicorp/bionic64"
      devsecops_ci_server.vm.hostname = "devsecops-ci-server"
      devsecops_ci_server.vm.network :private_network, ip: "192.168.56.101"

      devsecops_ci_server.vm.provider :virtualbox do |v|
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--memory", 1024]
        v.customize ["modifyvm", :id, "--name", "devsecops_ci_server"]
      end
    end

    config.vm.define "devsecops_cd_server" do |devsecops_cd_server|
      devsecops_cd_server.vm.box = "hashicorp/bionic64"
      devsecops_cd_server.vm.hostname = "devsecops-cd-server"
      devsecops_cd_server.vm.network :private_network, ip: "192.168.56.102"

      devsecops_cd_server.vm.provider :virtualbox do |v|
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--memory", 1024]
        v.customize ["modifyvm", :id, "--name", "devsecops_cd_server"]
      end
    end

    config.vm.define "devsecops_apps" do |devsecops_apps|
      devsecops_apps.vm.box = "hashicorp/bionic64"
      devsecops_apps.vm.hostname = "devsecops-apps"
      devsecops_apps.vm.network :private_network, ip: "192.168.56.103"

      devsecops_apps.vm.provider :virtualbox do |v|
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--memory", 512]
        v.customize ["modifyvm", :id, "--name", "devsecops_apps"]
      end
    end
end