class cartoweb3::base {

  package {
    [
      'php5-common',
      'php5-cli',
      'php5-gd',
      'libapache2-mod-php5',
      'php5-pgsql',
      'php5-curl',
      'php5-sqlite',
      'php5-mysql',
      'php5-mapscript',
    ]: ensure => present,
  }

  package {'php5-json':
    ensure => absent,
  }

  file {'/usr/local/bin/cartoweb3-clean.sh':
    ensure  => file,
    mode    => '0755',
    content => file('cartoweb3/usr/local/bin/cartoweb3-clean.sh'),
  }

  cron { 'cartoweb3 clean images cache':
    ensure  => absent,
    command => '/usr/local/bin/cartoweb3-clean.sh',
    user    => 'root',
    hour    => 4,
    minute  => 0,
    require => File['/usr/local/bin/cartoweb3-clean.sh'],
  }

  cron { 'cw3 clean images cache':
    command => '/usr/local/bin/cartoweb3-clean.sh',
    user    => 'www-data',
    hour    => '*/3',
    minute  => '0',
    require => [ File['/usr/local/bin/cartoweb3-clean.sh'], User['www-data'] ],
  }

  file {'/etc/php5/conf.d/cartoweb3.ini':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => "enable_dl = On\n",
    require => [Package['php5-common'], Package['httpd']],
    notify  => Service['httpd'],
  }

}
