# https://collectd.org/wiki/index.php/Plugin:AMQP
class collectd::plugin::amqp (
  Enum['present', 'absent'] $ensure  = 'present',
  Boolean $manage_package            = $collectd::manage_package,
  Stdlib::Host $amqphost             = 'localhost',
  Stdlib::Port $amqpport             = 5672,
  String $amqpvhost                  = 'graphite',
  String $amqpuser                   = 'graphite',
  String $amqppass                   = 'graphite',
  Collectd::Amqp::Format $amqpformat = 'Graphite',
  Boolean $amqpstorerates            = false,
  String $amqpexchange               = 'metrics',
  Boolean $amqppersistent            = true,
  Optional[Array] $amqproutingkeys   = undef,
  String $graphiteprefix             = 'collectd.',
  String[1] $escapecharacter         = '_',
  Optional[Integer[1]] $interval     = undef,
  Boolean $graphiteseparateinstances = false,
  Boolean $graphitealwaysappendds    = false,
  Optional[String] $amqpqueue        = undef,
  Boolean $amqppublish               = false,
  Boolean $amqpsubscribe             = false,
) {

  include collectd

  if $manage_package {
    if $facts['os']['family'] == 'RedHat' {
      package { 'collectd-amqp':
        ensure => $ensure,
      }
    } elsif $::osfamily == 'Debian' {
      package { 'amqp-tools':
        ensure => $ensure,
      }
    }
  }

  collectd::plugin { 'amqp':
    ensure   => $ensure,
    content  => template('collectd/plugin/amqp.conf.erb'),
    interval => $interval,
  }
}
