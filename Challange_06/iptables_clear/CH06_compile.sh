#!/bin/bash


echo '[+] Assembling with Nasm ... '
nasm -f elf32 -o $1.o $1.nasm

echo '[+] Linking ...'
ld -o $1 $1.o

echo '[+] Objdump ...'
#mycode1=`objdump -d ./$1|grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\\x/g'|paste -d '' -s |sed 's/^/"/' | sed 's/$/"/g'`
#echo $mycode1

#mycode2=`objdump -d ./$1|grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\\x/g'|paste -d '' -s |sed 's/^/"/' | sed 's/$/"/g'`
#echo $mycode2

>tmp.txt
for i in `objdump -d $1|tr '\t' ' '|tr ' ' '\n'|grep -Eo '^[0-9a-f]{2}$'` ; do echo -n "\x$i" >>tmp.txt ; done
mycode=`cat tmp.txt`
#echo $mycode

echo '[+] Assemble shellcode C ...'

echo "#include<stdio.h>" >shellcode.c
echo "#include<string.h>" >>shellcode.c
echo "unsigned char code[] = \"\\" >>shellcode.c
echo $mycode"\";" >>shellcode.c
echo "main()" >>shellcode.c
echo "{" >>shellcode.c
echo "printf(\"Shellcode Length:  %d\n\", strlen(code));" >>shellcode.c
echo "  int (*ret)() = (int(*)())code;" >>shellcode.c
echo "  ret();" >>shellcode.c
echo "}" >>shellcode.c

echo '[+] Compile shellcode.c'

gcc -fno-stack-protector -z execstack shellcode.c -o shellcode

echo '[+] Done!' 
