node 'd-foreman01.meema.lan' {
    include ntp

    # setup private git server

    include git

    user { "git":
        ensure      => "present",
        password    => '$1$RmxvQIiu$RdN08GQMHpIqzuDhGgyf2/',
        home        => '/home/git',
        managehome  => true,
    }

   file { "/home/git/.ssh":
        ensure => "directory",
        owner  => 'git',
        group  => 'git',
        mode   => '0644',
    }

    $keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzqD3teS5TTcY14OTG3rBs29RC5CxQSBAAVaCPY/L/z6XD1DJ1vwtpk81sj8lwWgEyrwvA0EWgZPpHq/UhRyrrTwOXObGCt/wDbOq/104Xeoy4Pv0PMxzsQMtt4LqOP2+4ImPxk/D/XZuf+AivFhfMAS8Wd5bYAjrU5O2WuzF0F0t1bop+rNk8+TIJKOMQehbu7Ks0DTs6nOcPt38wRexMbYrfe4APRXXv39B09LgEhwrETy0SWnnScqQjh3TCcHj+SfOjEzw/q339oQFkIMRwwGE93Oeb4ssttYY+6F2thnxEltNrb4amaNI7K4zJWQK3nD/95vSZBQZ16pI2ph55 juergen@meema.org"

    file { "/home/git/.ssh/authorized_keys":
        ensure => "present",
        owner  => 'git',
        group  => 'git',
        mode   => '0644',
        content => "$keys",
    }

    file { ['/srv/data', '/srv/data/repos']:
        ensure => "directory",
        owner  => 'git',
        group  => 'git',
        mode   => '0644'
    }

}