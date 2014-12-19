node 'd-web02.meema.lan' {
    include ntp
    include apache
    apache::vhost { 'first.example.com':
        port         => '80',
        docroot      => '/var/www/first',
        suphp_engine => 'off',
    }

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
}