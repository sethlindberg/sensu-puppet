# = Class: sensu::repo::yum
#
# Adds Sensu YUM repo support
#
# == Parameters
#
# [*ensure*] - add 'absent' to remove. defaults to 'present'.

class sensu::repo::yum (
    $ensure = 'present'
  ) {

  $enabled = $ensure ? {
    'present' => 1,
    default   => 'absent'
  }

  # amazon linux uses centos 6 repository, but has no $releasever.
  $baseurl = $isamazon ? {
    false  => 'http://repos.sensuapp.org/yum/el/$releasever/$basearch/',
    'true' => 'http://repos.sensuapp.org/yum/el/6/$basearch/',
   }

  yumrepo { 'sensu':
    enabled  => $enabled,
    baseurl  => 'http://repos.sensuapp.org/yum/el/$releasever/$basearch/',
    gpgcheck => 0,
    name     => 'sensu',
    descr    => 'sensu',
    before   => Package['sensu'],
  }

}
