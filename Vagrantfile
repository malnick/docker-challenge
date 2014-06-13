Vagrant.configure("2") do |config|
config.vm.provider "virtualbox" do |v|
	v.customize ["modifyvm", :id, "--memory", 1024]
end
config.vm.define :nagios do |deploy|
	deploy.vm.box = "precise64"
	deploy.vm.hostname = "nginx.server.dev"
	deploy.vm.box_url = "http://files.vagrantup.com/precise64.box"
	deploy.vm.synced_folder "modules", "/etc/puppet/modules"
	deploy.vm.synced_folder "manifests", "/etc/puppet/manifests"
	deploy.vm.network :private_network, ip: "10.10.33.2" # Define static IP once dev completes
	#deploy.vm.network :public_network
	deploy.vm.provision :puppet, :module_path => "modules", :manifests_path => "manifests", :manifest_file => "deploy_nagios.pp"
	end
  
config.vm.provision "docker" do |d|
      d.pull_images "ubuntu"
      d.run "ubuntu"
      end
end
