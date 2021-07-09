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
  file {
    'download-dokuwiki':
      ensure         => 'present',
      source         => 'https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz',
      path           => '/usr/src/dokuwiki.tgz',
      checksum_value => '8867b6a5d71ecb5203402fe5e8fa18c9';
  }

  exec {
    'extraction-dokuwiki':
      cwd     => '/usr/src',
      command => 'tar -xzvf dokuwiki.tgz',
      creates => '/usr/src/dokuwiki',
      path    => ['/usr/bin', '/usr/sbin',],
      require => File['download-dokuwiki'];

    'copie-dokuwiki':
      cwd     => '/usr/src/',
      command => 'rsync -a dokuwiki/ /var/www/politique && rsync -a dokuwiki/ /var/www/recettes',
      path    => ['/usr/bin', '/usr/sbin',],
      require => Exec['extraction-dokuwiki'];
  }

}

class install_dokuwiki ($hostname, $version) {

  host {
    $hostname:
     ip => '127.0.0.1',
  }

  file {
    'change-permission':
      ensure => 'directory',
      path   => '/var/www/$version/data',
      mode   => '0755',
      before => File['create-conf-apache'];

    'create-conf-apache':
	    ensure => 'present',
	    source => '/etc/apache2/sites-available/000-default.conf',
	    path   => '/etc/apache2/sites-available/$version.conf',
      before => Exec['changement-conf'];
  }

  exec {
    'changement-conf':
      path    => ['/usr/bin', '/usr/sbin'],
      command =>  'sed -i \'s/html/$version/g\' /etc/apache2/sites-enabled/$version.conf && sed -i \'s/#ServerName www.example.com/ServerName $version.wiki/g\' /etc/apache2/sites-enabled/$version.conf';
      
    'start':
      path	  => ['/usr/bin/', '/usr/sbin'],
      command => 'a2ensite $version';
  }
}


node 'server0' {
  class { 'install_dokuwiki':
    hostname => 'politique.wiki',
    version  => 'politique',
  }
  include packages
  include extract_dokuwiki
  include install_dokuwiki
}

node 'server1' {
  class { 'install_dokuwiki':
    hostname => 'recettes.wiki',
    version  => 'recettes',
  }
  include packages
  include extract_dokuwiki
  include install_dokuwiki
}
