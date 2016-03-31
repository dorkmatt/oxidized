class Cumulus < Oxidized::Model

  prompt /^((\w*)@(.*)([>#$]\s)+)$/
  comment  '# '


  #add a comment in the final conf
  def add_comment comment
    "\n###### #{comment} ######\n"
  end

  cmd :all do |cfg|
    cfg.each_line.to_a[1..-2].join
  end

  #show the persistent configuration
  pre do
    cfg = add_comment 'VERSION'
    cfg += cmd 'cat /etc/os-release'

    # TODO: sudo
    cfg += add_comment 'decode-syseeprom output'
    cfg += cmd '/usr/cumulus/bin/decode-syseeprom'

    cfg += add_comment 'cl-license output'
    cfg += cmd '/usr/cumulus/bin/cl-license'

    cfg += cmd 'for dir in `find /etc/cumulus -maxdepth 1 -type d -not -name init -not -name etc\.replace -not -name ssmonitor\.d`; do find $dir -type f -printf \'\n###### %h/%f ######\n\n\' -exec cat {} \; ; done ;'

    cfg += add_comment '/etc/hostname file'
    cfg += cmd 'cat /etc/hostname'

    cfg += add_comment '/etc/hosts file'
    cfg += cmd 'cat /etc/hosts'

    cfg += add_comment '/etc/resolv.conf'
    cfg += cmd 'cat /etc/resolv.conf'

    cfg += add_comment '/etc/ntp.conf'
    cfg += cmd 'cat /etc/ntp.conf'

    cfg += add_comment 'MOTD'
    cfg += cmd 'cat /etc/motd'

    cfg += add_comment 'PASSWD'
    cfg += cmd 'cat /etc/passwd'

    cfg += add_comment '/etc/network/interfaces representation'
    cfg += cmd '/sbin/ifquery -a'

    cfg += add_comment 'lldp output'
    cfg += cmd '/usr/sbin/lldpctl'

    cfg += add_comment '/etc/snmp/snmpd.conf'
    cfg += cmd 'cat /etc/snmp/snmpd.conf'

    cfg += add_comment 'QUAGGA DAEMONS'
    cfg += cmd 'cat /etc/quagga/daemons'

    cfg += add_comment 'QUAGGA ZEBRA'
    cfg += cmd 'cat /etc/quagga/zebra.conf'

    cfg += add_comment 'QUAGGA BGP'
    cfg += cmd 'cat /etc/quagga/bgpd.conf'

    cfg += add_comment 'QUAGGA OSPF'
    cfg += cmd 'cat /etc/quagga/ospfd.conf'

    cfg += add_comment 'QUAGGA OSPF6'
    cfg += cmd 'cat /etc/quagga/ospf6d.conf'
  end

  cfg :telnet do
    username /^Username:/
    password /^Password:/
  end

  cfg :telnet, :ssh do
    pre_logout 'exit'
  end

end
