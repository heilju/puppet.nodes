node 'd-web02.meema.lan' {
    
    # remove firewall
    package { 'firewalld':
        ensure => 'absent',
    }
    
    # install some libraries
    package { ['php-mcrypt', 'php-pdo', 'php-mysql', 'php-xml', 'yum-utils']:
        ensure => 'present',
    }

    ##############################################################
    # install base modules/packages
    ##############################################################
    
    include ntp
    include apache
    class { 'php': }
    class {'::apache::mod::php':}
    

    ##############################################################
    # vhost: laravel-tutorial.meema.lan
    ##############################################################
    
    # setting up vhost root directory and vhost log root
    file { ["/var/www/d-sunpower.meema.lan", "/var/www/d-sunpower.meema.lan/docs", "/var/www/d-sunpower.meema.lan/logs"]:
        ensure => 'directory',
        owner  => 'apache',
        group  => 'apache',
    }

    apache::vhost { "d-sunpower.meema.lan":
        port            => '80',
        docroot         => "/var/www/d-sunpower.meema.lan/docs/public",
        logroot         => "/var/www/d-sunpower.meema.lan/logs",
        override        => ['All'],
        suphp_engine    => 'off',
    }

    ##############################################################
    # mysql-server
    ##############################################################

    class { '::mysql::server':
        root_password    => 'eTcJ0708=',
        override_options => {
            'mysqld' => {
                'bind-address' => '0.0.0.0',
            }
        },

        databases => {
            'sunpower' => {
                ensure  => 'present',
                charset => 'utf8',
            },
        },

        users => {
            'admin@10.0.0.17' => {
                ensure                   => 'present',
                max_connections_per_hour => '0',
                max_queries_per_hour     => '0',
                max_updates_per_hour     => '0',
                max_user_connections     => '0',
                password_hash            => '*A4A00DC274E651E5575A158F2F5AFF8FEBE6AB84',
            },

            'app_sunpower@localhost' => {
                ensure                   => 'present',
                max_connections_per_hour => '0',
                max_queries_per_hour     => '0',
                max_updates_per_hour     => '0',
                max_user_connections     => '0',
                password_hash            => '*A4A00DC274E651E5575A158F2F5AFF8FEBE6AB84',
            },
        },

        grants => {
            'admin@10.0.0.17/sunpower.*' => {
                ensure     => 'present',
                options    => ['GRANT'],
                privileges => ['ALL'],
                table      => 'sunpower.*',
                user       => 'admin@10.0.0.17',
            },

            'app_sunpower@localhost/sunpower.*' => {
                ensure     => 'present',
                options    => ['GRANT'],
                privileges => ['SELECT', 'INSERT', 'UPDATE', 'DELETE'],
                table      => 'sunpower.*',
                user       => 'app_sunpower@localhost',
            },
        }
    }
}