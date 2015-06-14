#!/usr/bin/perl
$ip=$ARGV[0];
($ip1,$ip2,$ip3,$ip4)=split/\./,$ip;
$str=sprintf ("%02X",$ip4).sprintf ("%02X",$ip3).sprintf ("%02X",$ip2).sprintf ("%02X",$ip1);
print $str;
