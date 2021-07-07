file {
  '/tmp/hello':
    ensure => 'present',
    content => 'Hello Wooooorld',
    path => '/tmp/myFile',
    group => 'root',
    owner => 'root';
}
