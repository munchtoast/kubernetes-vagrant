# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  # Change to add more workers
  NodeCount = 1
  
  # global requirements
  config.vm.provision "shell", path: "requirements.sh", :args => NodeCount
  config.vm.box = "bento/ubuntu-24.04" # change if needed 
  config.vm.synced_folder ".", "/vagrant", type: "nfs", mount_options: ["vers=3,tcp"]
  
  # Kubernetes Master
  config.vm.define "master" do |master|
    master.vm.hostname = "master"
    master.vm.network "private_network", ip: "192.168.10.100"
    master.vm.provider :libvirt do |libvirt|
      libvirt.cpus = 4
      libvirt.cpuset = '1-4,^3,6'
      libvirt.cputopology :sockets => '2', :cores => '2', :threads => '1'
      libvirt.memory = 4096
    end
    master.vm.provision "shell", path: "master.sh"
    master.vm.box_download_insecure = true
  end

  (1..NodeCount).each do |i|
    config.vm.define "worker#{i}" do |worker|
      worker.vm.hostname = "worker#{i}"
      worker.vm.network "private_network", ip: "192.168.10.#{i+1}"
      worker.vm.provider :libvirt do |libvirt|
        libvirt.cpus = 2
        libvirt.cpuset = '1-4,^3,6'
        libvirt.cputopology :sockets => '1', :cores => '2', :threads => '1'
        libvirt.memory = 4096
      end
      worker.vm.provision "shell", path: "worker.sh"
      worker.vm.box_download_insecure = true
    end
  end
end