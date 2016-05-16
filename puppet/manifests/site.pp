class app_server {
  include ssh, git, user, nginx

  $node_version = "5.7.0"
  $osfamily = "Debian"
  $operatingsystem = "Ubuntu"
  $operatingsystemrelease = 14.04

  # Create the app deployment user
  user::deployer { "app":
    uid => "1001",
  }

  # Create the app deployment directory
  deploy::directory { "/home/app/fermentable":
    owner   => "app",
    group   => "deploy",
  }

  # Install rbenv in the home directory
  rbenv::install { "app":
    group => "deploy",
  }

  # Compile and install the desired ruby version
  class { 'nvm':
    user => "app",
    install_node => $node_version
  }

  # Set the local node version for the app user
  file { "/home/app/.node-version":
    ensure  => present,
    content => $node_version,
    owner   => "app",
    group   => "deploy",
    mode    => "640"
  }

  # Install FreeTDS
  package { "freetds-dev":
    ensure => present,
  }

  # Rotate logs
  logrotate::unicorn { "fermentable":
    app_directory => "/home/app/fermentable/current",
    pid_file => "/tmp/unicorn.fermentable.pid",
  }

  logrotate::nginx { "fermentable":
    app_directory => "/home/app/fermentable/current",
    pid_file => "/run/nginx.pid"
  }

  cron { 'restart nginx':
    name => "restart_nginx",
    ensure => present,
    command => "/bin/check_restart.sh",
    user => "root",
    minute => "*/5"
  }

  class { 'wkhtmltopdf': }
}

node default {
  include app_server

  file { "/etc/nginx/conf.d/fermentable.conf":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("nginx/conf.d/production.erb"),
    notify  => Class["nginx::service"],
  }
}
