class image::thinclient {
  case $operatingsystem {
    'Ubuntu': {
      case $lsbdistcodename {
        'trusty': {
	  include image::bundle::thinclient
        }
      }
    }
  }
}
