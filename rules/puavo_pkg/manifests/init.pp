class puavo_pkg {
  include packages

  $pkgbasedir = '/usr/share/puavo-pkg/packages'

  # This is the default PUAVO_PKG_ROOTDIR for puavo-pkg that can be changed
  # in /etc/puavo-pkg/puavo-pkg.conf.
  $pkgrootdir = '/var/lib/puavo-pkg/packages'

  define install {
    $pkgname = $title

    exec {
      "/usr/sbin/puavo-pkg install ${puavo_pkg::pkgbasedir}/${pkgname}.tar.gz":
        creates => "${puavo_pkg::pkgrootdir}/${pkgname}/installed",
        require => Package['puavo-pkg'];
    }
  }

  Package <| title == puavo-pkg |>
}
