#!/usr/bin/perl
$SERVICEID=$ARGV[0];
$WANIP=$ARGV[1];
$WANNETMASK=$ARGV[2];
$DFGW=$ARGV[3];

if (@ARGV) {
} else {
        print << "MAN";
usage: $0 [SERVICE ID] [WAN Public IP address for Router] [Public Network subnet Mask] [Default Gateway ISP]

# example: ./ENXOI881-baseconfig.pl CNSTRKIRP001 84.19.133.174 255.255.255.252 84.19.133.173

MAN
;
exit(0);
}

print << "EOL";

######### Internet over ENX C891 BASECONFIG ##########
conf t
!
hostname $SERVICEID
!
ip vrf internet
!
int GigabitEthernet0
description *** Internet VRF Vlan1 ***
no shut
!
interface Vlan1
 ip vrf forwarding internet
 ip address $WANIP $WANNETMASK
exit
!
ip route vrf internet 0.0.0.0 0.0.0.0 $DFGW
!
ip ssh version 2
! Later creation of RSA key for trustpoint will cause conflict with SSH RSA key
crypto key generate rsa general-keys label ssh-rsa-kpn modulus 2048
! Wait for key generation to be completed
!
ip ssh rsa keypair-name ssh-rsa-kpn
!
ip access-list standard 1
permit 134.222.0.0 0.0.255.255
permit 193.242.90.0 0.0.1.255
permit 193.141.42.0 0.0.0.63
permit 212.189.81.0 0.0.0.255
!
line vty 0 4
 access-class 1 in vrf-also
 privilege level 15
 password 0 mayday
 transport input all
end
!
wr
!
EOL
;
