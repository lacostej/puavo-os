class xorg::inputs_calibration {
  include ::packages,
          ::puavo_conf

  ::puavo_conf::definition {
    'puavo-xorg-inputs-calibration.json':
      source => 'puppet:///modules/xorg/puavo-xorg-inputs-calibration.json';
  }

  ::puavo_conf::script {
    'setup_xorg_inputs_calibration':
      require => [ Package['xserver-xorg-input-evdev']
                 , Puavo_conf::Definition['puavo-xorg-inputs-calibration.json'] ],
      source  => 'puppet:///modules/xorg/setup_xorg_inputs_calibration';
  }

  Package <| title == xserver-xorg-input-evdev |>
}
