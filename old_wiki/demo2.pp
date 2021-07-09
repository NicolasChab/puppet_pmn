file {
  '/tmp/hello':
    ensure => 'present',
    content => 'Hello Wooooorld',
    group => 'root',
    owner => 'root';
}
