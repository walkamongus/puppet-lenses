# @api private
#
# @summary Download Lenses tarball from a source and install into /opt
#
class lenses::install (
  $version,
  $download_source,
  $checksum,
  $checksum_type,
  $download_proxy,
){

  assert_private()

  file { "/opt/lenses-${version}":
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   =>  '0755',
  }

  archive { "/tmp/lenses-${version}-linux64.tar.gz":
    ensure        => present,
    extract       => true,
    extract_path  => "/opt/lenses-${version}",
    source        => $download_source,
    checksum      => $checksum,
    checksum_type => $checksum_type,
    creates       => "/opt/lenses-${version}/lenses",
    cleanup       => true,
    proxy_server  => $download_proxy,
    require       => File["/opt/lenses-${version}"],
  }

  file { '/opt/lenses':
    ensure    => link,
    target    => "/opt/lenses-${version}/lenses",
    subscribe => Archive["/tmp/lenses-${version}-linux64.tar.gz"],
  }

}
