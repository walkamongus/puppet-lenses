# @api private^[[>65;6003;1c^[]10;rgb:0000/ffff/0000^G^[]11;rgb:0000/0000/0000^G^[P1$r0 q^[\^[[?12;4$y
#
# @summary Configure the lenses.conf and security.conf files for Lenses
#
class lenses::config (
  $lenses_conf_file,
  $lenses_conf_content,
  $lenses_conf_source,
  $security_conf_file,
  $security_conf_content,
  $security_conf_source,
  $license_conf_file,
  $license_conf_content,
  $license_conf_source,
){

  assert_private()

  file {
    default:
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0640',
    ;
    $lenses_conf_file:
      content => $lenses_conf_content,
      source  => $lenses_conf_source,
    ;
    $security_conf_file:
      content => $security_conf_content,
      source  => $security_conf_source,
    ;
    $license_conf_file:
      content => $license_conf_content,
      source  => $license_conf_source,
    ;
  }
}
