# = Define: sensu::check
#
# Defines Sensu checks
#
# == Parameters
#
# [*command*] - the command to be run by the check. Necessary, no defaults.
# [*ensure*] - defaults to 'present', when removing a check replace with 'absent'
# [*type*] - What type of check this is. i.e., 'metric'
# [*handers*] - List of handlers the check can call. i.e. ['pagerduty', 'irc'].
# [*standalone*] - true = Client will run check w/o server broadcast. for use with
# check that would be added to every client.
# [*sla*] - custom variable for notifu.
# [*interval*] - the rate the check in seconds. Defaults to once per minute.
# [*subscribers*] - what servers are subscribed to this check. i.e., 'webservers'.
# [*notification*] - Check description used by many handlers in their notification.
# [*low_flap_threshold*] - If below this percent, check is flapping.
# [*high_flap_threshold*] - if above this percent, check is flapping.
# [*refresh*] -
# [*aggregate*] - Enables check aggregation.
# [*occurrences*] - How many checks should fail before alerting.
# [*config*] - Specific Check configuration for the client to use.
# [*purge_config*] - force configuration replacement.

define sensu::check(
  $command,
  $ensure               = 'present',
  $type                 = undef,
  $handlers             = [],
  $standalone           = undef,
  $interval             = '60',
  $subscribers          = [],
  $sla                  = [],
  $notification         = undef,
  $low_flap_threshold   = undef,
  $high_flap_threshold  = undef,
  $refresh              = undef,
  $aggregate            = undef,
  $occurrences          = undef,
  $config               = undef,
  $purge_config         = 'false',
) {

  if $purge_config {
    file { "/etc/sensu/conf.d/checks/${name}.json": ensure => $ensure, before => Sensu_check[$name] }
  }

  sensu_check { $name:
    ensure              => $ensure,
    type                => $type,
    standalone          => $standalone,
    command             => $command,
    handlers            => $handlers,
    interval            => $interval,
    subscribers         => $subscribers,
    sla                 => $sla,
    notification        => $notification,
    low_flap_threshold  => $low_flap_threshold,
    high_flap_threshold => $high_flap_threshold,
    refresh             => $refresh,
    aggregate           => $aggregate,
    occurrences         => $occurrences,
    config              => $config,
    require             => File['/etc/sensu/conf.d/checks'],
  }

}
