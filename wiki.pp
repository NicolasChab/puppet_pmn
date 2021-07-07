package {
  'installation apache2':
    name   => 'apache2',
    ensure => present;

  'installation php7.3':
    name   => 'php7.3',
    ensure => present;

}

service {
  'service apache2':
    name   => 'apache2',
    ensure => running; 
}

#exec { 
#  'download docuwiki':
#    path    => '/usr/bin',
#    command => 'wget -O /usr/src/dokuwiki.tgz \
#    https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz';
#
#  'unZip du fichier':
#    cwd     => '/usr/src',
#    path    => '/usr/bin',
#    command => 'tar -xavf dokuwiki.tgz';
#}

file {
  'download docuwiki':
    checksum_value => '8867b6a5d71ecb5203402fe5e8fa18c9',
    ensure => directory,
    path   => '/usr/src',
    source => 'https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz';
    
}

exec {
  'unZip du fichier':
    cwd     => '/usr/src',
    path    => '/usr/bin',
    command => 'tar -xavf dokuwiki.tgz';
}

file {
  'deplacement de dokuwiki':
    ensure => directory,
    path   => '/usr/src/dokuwiki',
    source => '/usr/src/dokuwiki-2020-07-29',
}
