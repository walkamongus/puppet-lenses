# @summary This class installs, configures, and starts Lenses for Apache Kafka
#
# @example
#   include lenses
#
# @param version
#   Specifies the version of Lenses
#
# @param download_source
#   Specifies the full URL download location of the Lenses tarball
#
# @param download_proxy
#   Specifies proxy for downloading files if necessary
#
# @param checksum
#   Specifies the checksum of the Lenses installation file
#
# @param checksum_type
#   Specifies the type of checksum for the installation file such as 'md5', 'sha256', etc.
class lenses (
  Pattern[/\d+\.\d+\.\d+/] $version,
  Variant[Stdlib::Httpurl, Undef] $download_proxy,
  Variant[String, Undef] $checksum,
  Variant[String, Undef] $checksum_type,
  Stdlib::Unixpath $lenses_conf_file,
  Stdlib::Unixpath $security_conf_file,
  Stdlib::Unixpath $license_conf_file,
  Stdlib::Unixpath $environment_file,
  Hash $environment_options,
  Variant[String, Undef] $lenses_conf_content,
  Variant[Stdlib::Filesource, Undef] $lenses_conf_source,
  Variant[String, Undef] $security_conf_content,
  Variant[Stdlib::Filesource, Undef] $security_conf_source,
  Variant[String, Undef] $license_conf_content,
  Variant[Stdlib::Filesource, Undef] $license_conf_source,
  Stdlib::Httpurl $download_source = "https://archive.lenses.io/lenses/${regsubst($version,'^(\\d+)\\.(\\d+)\\.(\\d+)$','\\1.\\2')}/lenses-${version}-linux64.tar.gz",
){

  class { 'lenses::install':
    version         => $version,
    download_source => $download_source,
    checksum        => $checksum,
    checksum_type   => $checksum_type,
    download_proxy  => $download_proxy,
  }

  class { 'lenses::config':
    lenses_conf_file      => $lenses_conf_file,
    lenses_conf_content   => $lenses_conf_content,
    lenses_conf_source    => $lenses_conf_source,
    security_conf_file    => $security_conf_file,
    security_conf_content => $security_conf_content,
    security_conf_source  => $security_conf_source,
    license_conf_file     => $license_conf_file,
    license_conf_content  => $license_conf_content,
    license_conf_source   => $license_conf_source,
  }

  class { 'lenses::service':
    environment_file    => $environment_file,
    environment_options => $environment_options,
    lenses_conf_file    => $lenses_conf_file,
  }

  Class['lenses::install']
  ~> Class['lenses::config']
  ~> Class['lenses::service']

}
