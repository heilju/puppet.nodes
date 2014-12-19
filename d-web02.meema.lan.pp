node 'd-web02.meema.lan' {
    
    # remove firewall
    package { 'firewalld':
        ensure => 'absent',
    }
    
    
    ##############################################################
    # install base modules/packages
    ##############################################################
    
    include ntp
    include apache
    class { 'php': }
    class {'::apache::mod::php':}
    
    ##############################################################
    # vhost: yii-tutorial.meema.lan
    ##############################################################
    
    # define some directories and files
    $vhost_name = "yii-tutorial.meema.lan"
    $vhost_root = "/var/www/${vhost_name}"
    $vhost_log_root = "/var/www/${vhost_name}/logs"


    # setting up vhost root directory and vhost log root
    file { [$vhost_root, $vhost_log_root]:
        ensure => 'directory',
        owner  => 'apache',
        group  => 'apache',
    }

    apache::vhost { $vhost_name:
        port            => '80',
        docroot         => "${vhost_root}/docs",
        logroot         => $vhost_log_root,
        suphp_engine    => 'off',
    }

    # create index.php to test php availability
    file { "${vhost_root}/docs/index.php":
        ensure => 'present',
        content => "<?php phpinfo(); ?>",
    }

    ##############################################################
    # mysql-server
    ##############################################################

    class { '::mysql::server':
        root_password    => 'eTcJ0708=',
        override_options => $override_options,

        databases => {
            'somedb' => {
                ensure  => 'present',
                charset => 'utf8',
            },
        },

        users => {
            'someuser@localhost' => {
                ensure                   => 'present',
                max_connections_per_hour => '0',
                max_queries_per_hour     => '0',
                max_updates_per_hour     => '0',
                max_user_connections     => '0',
                password_hash            => '*F3A2A51A9B0F2BE2468926B4132313728C250DBF',
            },
        },

        grants => {
            'someuser@localhost/somedb.*' => {
                ensure     => 'present',
                options    => ['GRANT'],
                privileges => ['SELECT', 'INSERT', 'UPDATE', 'DELETE'],
                table      => 'somedb.*',
                user       => 'someuser@localhost',
            },
        }
    }
    
    ##############################################################
    # ftp 
    ##############################################################
}