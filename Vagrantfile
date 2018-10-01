Vagrant.configure("2") do |config|
  config.vm.box = "geerlingguy/centos7"
  config.vm.provision "shell",
    inline: "curl -L https://bootstrap.saltstack.com -o install-salt.sh"

  config.vm.define "master" do |master|
    master.vm.provider :virtualbox do |vb|
                vb.customize ["modifyvm", :id, "--memory", "2048"]
    end
    master.vm.network "private_network", ip: "192.168.50.4"
    master.vm.hostname = "master"
    master.vm.synced_folder "src/", "/srv/salt"
    master.vm.synced_folder "pillar/", "/srv/pillar"
    master.vm.provision "shell",
      inline: "sudo sh install-salt.sh -M -A 127.0.0.1"
  end

  config.vm.define "openam1" do |openam|
    openam.vm.provider :virtualbox do |vb|
              vb.customize ["modifyvm", :id, "--memory", "4096"]
              vb.customize ["modifyvm", :id, "--cpus", "2"]
    end
    openam.vm.network "private_network", ip: "192.168.50.5"
    openam.vm.hostname = "openam1.local"
    openam.vm.provision "shell",
      inline: "sudo sh install-salt.sh -A 192.168.50.4"
  end

  config.vm.define "openidm1" do |openidm1|
    openidm1.vm.provider :virtualbox do |vb|
                  vb.customize ["modifyvm", :id, "--memory", "2048"]
    end
    openidm1.vm.network "private_network", ip: "192.168.50.6"
    openidm1.vm.hostname = "openidm1.local"
    openidm1.vm.provision "shell",
      inline: "sudo sh install-salt.sh -A 192.168.50.4"
  end

  config.vm.define "openig1" do |openig1|
    openig1.vm.provider :virtualbox do |vb|
                    vb.customize ["modifyvm", :id, "--memory", "1024"]
    end
    openig1.vm.network "private_network", ip: "192.168.50.8"
    openig1.vm.hostname = "openig1.local"
    openig1.vm.provision "shell",
      inline: "sudo sh install-salt.sh -A 192.168.50.4"
  end

  config.vm.define "opendj1" do |opendj1|
      opendj1.vm.provider :virtualbox do |vb|
                      vb.customize ["modifyvm", :id, "--memory", "1024"]
      end
      opendj1.vm.network "private_network", ip: "192.168.50.7"
      opendj1.vm.hostname = "opendj1.local"
      opendj1.vm.provision "shell",
        inline: "sudo sh install-salt.sh -A 192.168.50.4"
    end


end
