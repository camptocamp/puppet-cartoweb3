class cartoweb3::base {

  package {
    [ 
      "php5-common",
      "php5-cli",
      "php5-gd",
      "libapache2-mod-php5",
      "php5-pgsql",
      "php5-curl",
      "php5-sqlite",
      "php5-mysql",
    ]: ensure => present,
  }

  package {"php5-json":
    ensure => absent,
  }

  file {"/usr/local/bin/cartoweb3-clean.sh":
    ensure => present,
    mode   => 755,
    source => "puppet:///modules/cartoweb3/usr/local/bin/cartoweb3-clean.sh"
  }

  cron { "cartoweb3 clean images cache":
    command => "/usr/local/bin/cartoweb3-clean.sh",
    user    => "root",
    hour    => 4,
    minute  => 0,
    require => File["/usr/local/bin/cartoweb3-clean.sh"],
    ensure  => absent,
  }

  cron { "cw3 clean images cache":
    command => "/usr/local/bin/cartoweb3-clean.sh",
    user    => "www-data",
    hour    => "*/3",
    minute  => "0",
    require => [ File["/usr/local/bin/cartoweb3-clean.sh"], User["www-data"] ],
  }

  file {"/etc/php5/conf.d/cartoweb3.ini":
    ensure => present,
    owner => root,
    group => root,
    mode => 644,
    content => "enable_dl = On\n",
    require => [Package["php5-common"], Package["apache"]],
    notify => Service["apache"],
  }

}
