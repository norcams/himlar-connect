# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

unless defined? settings
  # Use nodes.yaml.local if it exists, else use nodes.yaml
  config = File.join(File.dirname(__FILE__), 'nodes.yaml')
  local = File.join(File.dirname(__FILE__), 'nodes.yaml.local')
  if File.exist?(local)
    config = local
    puts "NOTE: Local config file nodes.yaml.local present"
  end
  settings = YAML.load(File.open(config, File::RDONLY).read)

  # Check if any nodesets are present
  if settings.has_key?('nodesets')
    # Check if the value of env var HIMLAR_NODESET is a valid nodeset
    if ENV.key?('HIMLAR_NODESET')
      if settings['nodesets'].key?(ENV['HIMLAR_NODESET'])
        settings['nodes'] = settings['nodesets'][ENV['HIMLAR_NODESET']]
      else
        puts "WARNING: HIMLAR_NODESET not found, using default"
      end
    end
  end

  if settings['nodes'].nil?
    # Enable a single node with the role 'base' and autostart=true
    settings['nodes'] = Array.new(1, Hash.new)
    settings['nodes'][0]['name'] = 'base'
    settings['nodes'][0]['autostart'] = true
    settings['nodes'][0]['primary'] = true
  end

  # Map default settings to each node
  settings['nodes'].each do |n|
    n.merge!(settings['defaults']) { |key, nval, tval | nval }
  end
end

VAGRANTFILE_API_VERSION = '2'
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  settings['nodes'].each_with_index do |n, i|
    n['hostid'] = n.key?('role') ? n['name'] : 'box'
    n['role'] = n.key?('role') ? n['role'] : n['name']
    config.vm.define n['name'], autostart: n['autostart'], primary: n['primary'] do |box|
      box.vm.hostname = "%s-%s-%s.%s" % [ n['location'],n['role'],n['hostid'],n['domain'] ]
      box.vm.box = n['box']
      box.vm.box_url = n['box_url']
      n['networks'].each do |net|
        ip = settings['networks'][net]['net'] + ".#{i+11}"
        auto_config = settings['networks'][net]['auto_config']
        box.vm.network :private_network, ip: ip, libvirt__dhcp_enabled: auto_config, auto_config: auto_config
      end

      # Pass environment variables to the provisioning scripts
      ENV['HIMLAR_CERTNAME'] = "%s-%s-%s.%s" % [ n['location'],n['role'],n['hostid'],n['domain'] ]
      env_data = ENV.select { |k, _| /^HIMLAR_|^FACTER_/i.match(k) }
      args = env_data.map { |k, v| "#{k}=#{v}" }
      box.vm.provision :shell, :path => 'provision.sh', args: args

      box.vm.provider :virtualbox do |vbox|
        vbox.customize ['modifyvm', :id, '--ioapic', 'on']
        vbox.customize ['modifyvm', :id, '--cpus',   n['cpus']]
        vbox.customize ['modifyvm', :id, '--memory', n['memory']]
        vbox.customize ['modifyvm', :id, '--name',   n['name']]
      end

      box.vm.provider :libvirt do |libvirt|
        libvirt.driver = 'kvm'
        libvirt.nested = true
        libvirt.cpus   = n['cpus']
        libvirt.memory = n['memory']
      end
    end
  end

  config.vm.synced_folder '.', '/vagrant', disabled: true
  config.vm.synced_folder '.', '/opt/himlar', type: 'rsync',
    rsync__exclude: [ '.git/', '.vagrant/' ]


  if ENV['HIMLAR_BRIDGE']
    config.vm.network :public_network, dev: ENV['HIMLAR_BRIDGE'], mode: 'bridge', auto_config: false
  end

  # NAT rule for openstack dashboard
  config.vm.network "forwarded_port", guest: 443, host: 8433
  config.vm.network "forwarded_port", guest: 80, host: 8080

  # Optional plugins configuration
  if Vagrant.has_plugin?('vagrant-cachier')
    config.cache.scope = :machine
  end
end
