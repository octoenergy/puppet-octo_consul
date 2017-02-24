class octo_consul (
    $encrypt_key,
    $datacenter = "eu-west-1",
    $data_dir = "/opt/consul",
) {
    package { "zip":
        ensure => installed    
    }

    # We set service_ensure to false to avoid Consul starting up when
    # provisioning the AMI. If it does, then it sets the cluster IP address
    # which causes a problem when a new server is built using the AMI.
    class { "::consul":
        service_ensure  => false,
        config_hash     => {
            "data_dir"      => $data_dir,
            "datacenter"    => $datacenter,
            "log_level"     => "INFO",
            "encrypt"       => $encrypt_key,
            "retry_join"    => ["consul.octoenergy.internal"],
        },
        pretty_config   => true,
        init_style      => "upstart",
        require         => Package["zip"],
    }
}
