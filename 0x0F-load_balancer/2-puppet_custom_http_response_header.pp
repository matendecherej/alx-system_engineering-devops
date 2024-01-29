# Update packages
exec { 'apt-get-update':
  command => '/usr/bin/apt-get update',
}

# Install Nginx
package { 'nginx':
  ensure  => installed,
  require => Exec['apt-get-update'],
}

# Configure Nginx with custom HTTP header and redirect
file_line { 'add_custom_header':
  ensure => 'present',
  path   => '/etc/nginx/sites-available/default',
  line   => 'add_header X-Served-By $hostname;',
  require => Package['nginx'],
}

file_line { 'perform_redirect':
  ensure => 'present',
  path   => '/etc/nginx/sites-available/default',
  line   => 'rewrite ^/redirect_me https://www.youtube.com/watch?v=QH2-TGUlwu4 permanent;',
  require => Package['nginx'],
}

# Create sample index.html
file { '/var/www/html/index.html':
  content => 'Hello World!',
  require => Package['nginx'],
}

# Enable and start Nginx service
service { 'nginx':
  ensure  => running,
  enable  => true,
  require => Package['nginx'],
}
