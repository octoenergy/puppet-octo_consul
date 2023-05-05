class octo_consul (
  $encrypt_key,
  $server_address,
  $datacenter = 'eu-west-1',
  $data_dir = '/opt/consul',
  $init_style = 'upstart',
) {
  package { 'zip':
    ensure => installed,
  }

  # We set service_ensure to false to avoid Consul starting up when
  # provisioning the AMI. If it does, then it sets the cluster IP address
  # which causes a problem when a new server is built using the AMI.
  class { 'consul':
    service_ensure => 'stopped',
    config_hash    => {
      'data_dir'   => $data_dir,
      # Note, this doesn't have to be an AWS region name.
      'datacenter' => $datacenter,
      'log_level'  => 'INFO',
      'encrypt'    => $encrypt_key,
      'retry_join' => [$server_address],
    },
    pretty_config  => true,
    init_style     => $init_style,
    require        => Package['zip'],
  }
  contain consul
}
