class packages {
  package {
    'apache2':
      ensure => 'present';
    'php7.3':
      ensure => 'installed';
  }

  service {
    'apache2':
      ensure => running,
      enable => true;
  }
}

class extract_dokuwiki {
  require packages

  file {
    'download-dokuwiki':
      ensure         => 'present',
      source         => 'https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz',
      path           => '/usr/src/dokuwiki.tgz',
      checksum_value => '8867b6a5d71ecb5203402fe5e8fa18c9';
    'deplacement-dokuwiki':
      ensure => present,
      path   => '/usr/src/dokuwiki',
      source => '/usr/src/dokuwiki-2020-07-29',
      recurse => true,
      require => Exec['extraction-dokuwiki'];
  }

  exec {
    'extraction-dokuwiki':
      cwd     => '/usr/src',
      command => 'tar -xzvf dokuwiki.tgz',
      creates => '/usr/src/dokuwiki',
      path    => ['/usr/bin', '/usr/sbin'],
      require => File['download-dokuwiki'];
  }

}

class install_dokuwiki ($hostname, $sitename) {
  require extract_dokuwiki

  host {
    $hostname:
     ip => '127.0.0.1',
  }

  file {
    'creation repertoire site':
      ensure  => present,
      owner   => 'www-data',
      group   => 'www-data',
      mode    => '0755',
      source  => '/usr/src/dokuwiki',
      path    => "/var/www/${sitename}",
      require => File['deplacement-dokuwiki'];
    'change-permission':
      ensure => 'directory',
      path   => "/var/www/${sitename}/data",
      mode   => '0755',
      before => File['create-conf-apache'];

    'create-conf-apache':
      ensure => 'present',
      source => '/etc/apache2/sites-available/000-default.conf',
      path   => "/etc/apache2/sites-available/${sitename}.conf",
      before => Exec['changement-conf'];
  }

  exec {
    'changement-conf':
      path    => ['/usr/bin', '/usr/sbin'],
      command =>  "sed -i 's/html/${sitename}/g' /etc/apache2/sites-available/${sitename}.conf && sed -i 's/#ServerName www.example.com/ServerName ${hostname}/g' /etc/apache2/sites-available/${sitename}.conf";

    'start':
      path    => ['/usr/bin/', '/usr/sbin'],
      command => "a2ensite ${sitename}";
  }
}


node 'server0' {
  class { 'install_dokuwiki':
    hostname => 'politique.wiki',
    sitename => 'politique',
  }
  include packages
  include extract_dokuwiki
  include install_dokuwiki
}

node 'server1' {
  class { 'install_dokuwiki':
    hostname => 'recettes.wiki',
    sitename => 'recettes',
  }
  include packages
  include extract_dokuwiki
  include install_dokuwiki
}
