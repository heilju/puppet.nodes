node 'd-web02.meema.lan' {
    
    # remove firewall
    package { 'firewalld':
        ensure => 'absent',
    }
    
    # install php mcrypt library
    package { 'php-mcrypt':
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
    file { ["/var/www/laravel-tutorial.meema.lan", "/var/www/laravel-tutorial.meema.lan/docs", "/var/www/laravel-tutorial.meema.lan/logs"]:
        ensure => 'directory',
        owner  => 'apache',
        group  => 'apache',
    }

    apache::vhost { "laravel-tutorial.meema.lan":
        port            => '80',
        docroot         => "/var/www/laravel-tutorial.meema.lan/docs/public",
        logroot         => "/var/www/laravel-tutorial.meema.lan/logs",
        suphp_engine    => 'off',
    }

    # create index.php to test php availability
    file { "/var/www/laravel-tutorial.meema.lan/docs/index.php":
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