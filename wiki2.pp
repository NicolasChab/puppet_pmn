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
    ensure  => directory,
    name    => '/var/www/politique-wiki',
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0750',
    before  => Exec['installation politique-wiki'];
  'creation du repertoire recettes-wiki':
    ensure  => directory,
    name    => '/var/www/recettes-wiki',
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0750',
    before  => Exec['installation recettes-wiki'];
}

exec {
  'unZip dokuwiki':
    cwd     => '/usr/src',
    path    => ['/usr/bin', '/usr/sbin'],
    command => 'tar -xavf dokuwiki.tgz';
  'installation politique-wiki':
    cwd     => '/',
    path    => ['/usr/bin', '/usr/sbin'],
    command => 'rsync -av /usr/src/dokuwiki /var/www/politique-wiki';
  'installation recettes-wiki':
    cwd     => '/',
    path    => ['/usr/bin', '/usr/sbin'],
    command => 'rsync -av /usr/src/dokuwiki /var/www/recettes-wiki';
#  'fichier de conf politique-wiki':
#    
#  'activer politique-wiki':
#    cwd     => '/',
#    path    => ['/usr/bin', '/usr/sbin'],
#    command => 'a2ensite politique-wiki',
#    notify  => Exec['reload apache2'];
#  'reload apache2':
#    cwd     => '/',
#    path    => ['/usr/bin', '/usr/sbin'],
#    command => 'systemctl reload apache2';
}

