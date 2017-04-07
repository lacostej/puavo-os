class packages::pinned {
  define pin_package ($version, $taglist) {
    $package = $title

    @package {
      'vtun':
	ensure  => $version,
	require => Apt::Pin[$package],
	tag     => $taglist;
    }

    ::apt::pin {
      $package:
	version => $version;
    }
  }

  ::packages::pinned::pin_package {
    # XXX puavo-wlanap needs a particular version of vtun (from Wheezy)
    'vtun':
      taglist => [ 'tag_network', 'tag_debian', ],
      version => '3.0.2-4+b1';
  }
}