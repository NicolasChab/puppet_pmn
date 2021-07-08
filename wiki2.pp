package {
  'installation apache2':
    name   => 'apache2',
    ensure => present;

  'installation php7.3':
    name   => 'php7.3',
    ensure => present;

}
-> service {
  'service apache2':
    name   => 'apache2',
    ensure => running;
}

#exec { 
#  'download docuwiki':
#    path    => ['/usr/bin', '/usr/sbin'],
#    command => 'wget -O /usr/src/dokuwiki.tgz \
#    https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz';
#
#  'unZip du fichier':
#    cwd     => '/usr/src',
#    path    => ['/usr/bin', '/usr/sbin'],
#    command => 'tar -xavf dokuwiki.tgz';
#}

-> file {
  'download docuwiki':
    checksum_value => '8867b6a5d71ecb5203402fe5e8fa18c9',
    ensure => present,
    path   => '/usr/src/dokuwiki.tgz',
    source => 'https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz';
  'deplacement de dokuwiki':
    ensure  => present,
    path    => '/usr/src/dokuwiki',
    source  => '/usr/src/dokuwiki-2020-07-29',
    require => Exec['unZip dokuwiki'];
  'creation du repertoire politique-wiki':
    ensure  => present,
    path    => '/var/www/politique-wiki/',
    source  => '/usr/src/dokuwiki/',
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0750',
    recurse => true;
  'creation du repertoire recettes-wiki':
    ensure  => present,
    path    => '/var/www/recettes-wiki/',
    source  => '/usr/src/dokuwiki/',
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0750',
    recurse => true;
  'creation fichier conf politique-wiki':
    ensure  => present,
    name    => '/etc/apache2/sites-available/politique-wiki.conf',
    source  => '/etc/apache2/sites-available/000-default.conf',
    before  => Exec['configuration virtualHost politique-wiki'];
  'creation fichier conf recettes-wiki':
    ensure  => present,
    name    => '/etc/apache2/sites-available/recettes-wiki.conf',
    source  => '/etc/apache2/sites-available/000-default.conf',
    before  => Exec['configuration virtualHost recettes-wiki'];
}

exec {
  'unZip dokuwiki':
    cwd     => '/usr/src',
    path    => ['/usr/bin', '/usr/sbin'],
    command => 'tar -xavf dokuwiki.tgz';
  'configuration virtualHost politique-wiki':
    path    => ['/usr/bin', '/usr/sbin'],
    command => 'sed -i \'/s/html/politique-wiki/g\' /etc/apache2/sites-available/politique-wiki.conf';
  'configuration virtualHost recettes-wiki':
    path    => ['/usr/bin', '/usr/sbin'],
    command => 'sed -i \'/s/html/recettes-wiki/g\' /etc/apache2/sites-availables/recettes-wiki.conf';

#    
#  'activer politique-wiki':
#    path    => ['/usr/bin', '/usr/sbin'],
#    command => 'a2ensite politique-wiki',
#    require => Exec['configuration virtualHost politique-wiki'],
#    notify  => Exec['reload apache2'];
#  'reload apache2':
#    path    => ['/usr/bin', '/usr/sbin'],
#    command => 'systemctl reload apache2';
#  'activer recettes-wiki':
#    path    => ['/usr/bin', '/usr/sbin'],
#    command => 'a2ensite recettes-wiki',
#    require => Exec['configuration virtualHost recettes-wiki'],
#    notify  => Exec['reload apache2'];
#  'reload apache2':
#    path    => ['/usr/bin', '/usr/sbin'],
#    command => 'systemctl reload apache2';
#  'ajout politique DNS':
#    path    => ['/usr/bin', '/usr/sbin'],
#    command => 'echo "127.0.0.1	politique-wiki" >> /etc/hosts';
#  'ajout recettes DNS':
#    path    => ['/usr/bin', '/usr/sbin'],
#    command => 'echo "127.0.0.1	recettes-wiki" >> /etc/hosts';

}

