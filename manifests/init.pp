#
# Class: activemq
#
# This module manages activemq
#
class activemq (

  $base                   = $::activemq::params::base,
  $msg_network            = $::activemq::params::msg_network,
  $sitename               = $::activemq::params::sitename,
  $max_rolled_logfiles    = $::activemq::params::max_rolled_logfiles,
  $keystore_password      = $::activemq::params::keystore_password,
  $truststore_password    = $::activemq::params::truststore_password,
  $jmx_admin_pass         = $::activemq::params::jmx_admin_pass,
  $jmx_monitor_pass       = $::activemq::params::jmx_monitor_pass,
  $jaas_guest_password    = $::activemq::params::jaas_guest_password,
  $jaas_jetty_password    = $::activemq::params::jaas_jetty_password,
  $jaas_monitor_password  = $::activemq::params::jaas_monitor_password,
  $jaas_system_password   = $::activemq::params::jaas_system_password,
  $jaas_apel_password     = $::activemq::params::jaas_apel_password,
  $additional_storage     = $::activemq::params::additional_storage,
  $brokers_in_my_network  = $::activemq::params::brokers_in_my_network,
  $jmx_min_memory         = $::activemq::params::jmx_min_memory,
  $jmx_max_memory         = $::activemq::params::jmx_max_memory,


) inherits activemq::params {

  # tom-mig-devel repo for activemq
  include yum::repo::tommigdevel

  # mbcg-utils package
  package { 'mbcg-utils':
    ensure     => latest,
  }

  # activemq package
  package { 'activemq':
    ensure  => 'present',
    require => Package['mbcg-utils'],
  }

  # activemq service
  service { 'activemq':
    ensure  => running,
    require => Package['activemq'],
  }

  # configurations
  file { '/etc/activemq/groups.properties.d':
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '0755',
    require => Package['activemq'],
  }
  file { '/etc/activemq/dns.properties.d':
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '0755',
    require => Package['activemq'],
  }
  file { '/etc/activemq/users.properties.d':
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '0755',
    require => Package['activemq'],
  }
  file { '/etc/activemq/groups.properties.d/static':
    ensure  => file,
    source  => 'puppet:///private/etc/activemq/groups.properties.d/static',
    owner   => root,
    group   => root,
    mode    => '0644',
    require => File['/etc/activemq/groups.properties.d'],
  }
  file { '/etc/activemq/dns.properties.d/static':
    ensure  => file,
    source  => 'puppet:///private/etc/activemq/dns.properties.d/static',
    owner   => root,
    group   => root,
    mode    => '0644',
    require => File['/etc/activemq/dns.properties.d'],
  }
  file { '/etc/activemq/users.properties.d/static':
    ensure  => file,
    content => template('activemq/etc/activemq/users.properties.d/static.erb'),
    owner   => root,
    group   => root,
    mode    => '0644',
    require => File['/etc/activemq/users.properties.d'],
  }
  file { '/etc/security/limits.d/activemq.conf':
    ensure => file,
    source => 'puppet:///modules/activemq/etc/security/limits.d/activemq.conf',
    owner  => root,
    group  => root,
    mode   => '0644',
  }
  file { '/etc/cron.d/glite-apel':
    ensure => file,
    source => 'puppet:///modules/activemq/etc/cron.d/glite-apel',
    owner  => root,
    group  => root,
    mode   => '0644',
  }
file { '/etc/cron.d/purge-broker':
    ensure => file,
    source => 'puppet:///modules/activemq/etc/cron.d/purge-broker',
    owner  => root,
    group  => root,
    mode   => '0644',
  }


  # Storege device
#  if $additional_storage == None {
    file { '/usr/share/activemq/tmp':
      ensure  => directory,
      owner   => activemq,
      group   => activemq,
      mode    => '0755',
      require => Package['activemq'],
    }
    file { '/var/lib/activemq/data':
      ensure  => directory,
      owner   => activemq,
      group   => activemq,
      mode    => '0755',
      require => Package['activemq'],
    }
#  }
#  else {
#    file { '$additional_storage/tmp':
#      ensure  => directory,
#      owner   => activemq,
#      group   => activemq,
#      mode    => '0755',
#      require => Package['activemq'],
#    }
#    file { '$additional_storage/data':
#      ensure  => directory,
#      owner   => activemq,
#      group   => activemq,
#      mode    => '0755',
#      require => Package['activemq'],
#    }
#    file { '/usr/share/activemq/tmp':
#      ensure  => link,
#      target  => '$additional_storage/tmp',
#      owner   => activemq,
#      group   => activemq,
#      mode    => '0755',
#      require => File['$additional_storage/tmp'],
#    }
#    file { '/var/lib/activemq/data':
#      ensure  => link,
#      target  => '$additional_storage/data',
#      owner   => activemq,
#      group   => activemq,
#      mode    => '0755',
#      require => File['$additional_storage/data'],
#    }
#  }
  # activeMQ binaries
  file { '/var/lib/activemq/bin':
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '0755',
    require => Package['activemq'],
  }
  file { '/usr/share/activemq/schema':
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '0755',
    require => Package['activemq'],
  }
  file { '/var/lib/activemq/bin/apel-sync':
    ensure  => file,
    source  => 'puppet:///modules/activemq/var/lib/activemq/bin/apel-sync',
    owner   => root,
    group   => root,
    mode    => '0755',
    require => File['/var/lib/activemq/bin'],
  }
  file { '/var/lib/activemq/bin/purge-broker':
    ensure  => file,
    source  => 'puppet:///modules/activemq/var/lib/activemq/bin/purge-broker',
    owner   => root,
    group   => root,
    mode    => '0755',
    require => File['/var/lib/activemq/bin'],
  }
  file { '/var/lib/activemq/bin/update-jaas':
    ensure  => file,
    source  => 'puppet:///modules/activemq/var/lib/activemq/bin/update-jaas',
    owner   => root,
    group   => root,
    mode    => '0755',
    require => File['/var/lib/activemq/bin'],
  }
  file { '/var/lib/activemq/bin/update-keystore':
    ensure  => file,
    content => template('activemq/var/lib/activemq/bin/update-keystore.erb'),
    owner   => root,
    group   => root,
    mode    => '0755',
    require => File['/var/lib/activemq/bin'],
  }

  # activeMQ httpd config
  file { '/etc/httpd/conf.d/activemq-webconsole.conf':
    ensure  => file,
    source  => 'puppet:///private/etc/httpd/conf.d/activemq-webconsole.conf',
    owner   => root,
    group   => root,
    mode    => '0644',
    require => Package['httpd'],
    notify  => Service['httpd'],
  }
  #  file { '/etc/httpd/conf.d/activemq-httpd.conf':
  #    ensure  => file,
  #    source  => 'puppet:///private/etc/httpd/conf.d/activemq-httpd.conf',
  #    owner   => root,
  #    group   => root,
  #    mode    => '0644',
  #    require => Package['httpd'],
  #    notify  => Service['httpd'],
  #  }
  file { '/etc/httpd/activemq-webconsole.users':
    ensure  => file,
    source  => 'puppet:///private/etc/httpd/activemq-webconsole.users',
    owner   => root,
    group   => root,
    mode    => '0644',
    require => Package['httpd'],
    notify  => Service['httpd'],
  }

  # activeMQ schema
  file { '/usr/share/activemq/schema/MIG.xsd':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    source  => 'puppet:///modules/activemq/usr/share/activemq/schema/MIG.xsd',
    require => Package['activemq'],
    notify  => Service['activemq'],
  }
  file { '/usr/share/activemq/lib/oat-activemq-patches-1.0.6.jar':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0755',
    source  => 'puppet:///modules/activemq/usr/share/activemq/lib/oat-activemq-patches-1.0.6.jar',
    require => Package['activemq'],
    notify  => Service['activemq'],
  }
  file { '/etc/activemq/login.config':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    source  => 'puppet:///modules/activemq/etc/activemq/login.config',
    require => Package['activemq'],
    notify  => Service['activemq'],
  }
  file { '/etc/activemq/jmx.access':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    source  => 'puppet:///private/etc/activemq/jmx.access',
    require => Package['activemq'],
    notify  => Service['activemq'],
  }
  file { '/etc/activemq/jmx.password':
    ensure  => present,
    owner   => activemq,
    group   => root,
    mode    => '0400',
    content => template('activemq/etc/activemq/jmx.password.erb'),
    require => Package['activemq'],
    notify  => Service['activemq'],
  }
  file { '/etc/activemq/activemq-wrapper.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('srce/activemq/etc/activemq/activemq-wrapper.conf.erb'),
    require => Package['activemq'],
    notify  => Service['activemq'],
  }
  file { '/etc/activemq/activemq.xml':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('srce/activemq/etc/activemq/activemq.xml.erb'),
    require => Package['activemq'],
    notify  => Service['activemq'],
  }

  file { '/etc/activemq/log4j.properties':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('activemq/etc/activemq/log4j.properties.erb'),
    require => Package['activemq'],
    notify  => Service['activemq'],
  }

  exec { '/var/lib/activemq/bin/update-keystore':
    subscribe   => File['/var/lib/activemq/bin/update-keystore'],
    refreshonly => true,
    require     => [ File['/var/lib/activemq/bin/update-keystore'], Class['gridcert'], ],
    notify      => Service['activemq'],
  }

  exec { '/var/lib/activemq/bin/update-jaas':
    subscribe   => File['/var/lib/activemq/bin/update-jaas','/etc/activemq/groups.properties.d/static','/etc/activemq/dns.properties.d/static','/etc/activemq/users.properties.d/static'],
    refreshonly => true,
    require     => File['/var/lib/activemq/bin/update-jaas'],
  }

}
