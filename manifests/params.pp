#
# Class: activemq::params
#
# This module contains defaults for other activemq modules
#
class activemq::params {
  # general activemq settings
  $base                   = '/usr/share/activemq'
  $msg_network            = ''
  $sitename               = 'test.srce.hr'

  $max_rolled_logfiles    = '50'

  $keystore_password      = 'testpw'
  $truststore_password    = 'testpw'

  $jmx_admin_pass         = 'testpw'
  $jmx_monitor_pass       = 'testpw'

  $jaas_guest_password    = 'guest'
  $jaas_jetty_password    = 'testpw'
  $jaas_monitor_password  = 'testpw'
  $jaas_system_password   = 'testpw'
  $jaas_apel_password     = 'testpw'

  #$additional_storage     = 'None'

  $brokers_in_my_network  = []

  $jmx_min_memory         = '512m'
  $jmx_max_memory         = '2g'
}
