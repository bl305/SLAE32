#!/bin/bash


echo '[+] Changing port to '$2' ...'
port=`printf %04X $2 |grep -o ..|tac|tr -d '\n'`
sed s/5C11/$port/ <$1.nasm >$1.nasm_$port

echo '[+] Assembling with Nasm ... '
nasm -f elf32 -o $1.o $1.nasm_$port

echo '[+] Linking ...'
ld -melf_i386 -o $1 $1.o

echo '[+] Objdump ...'
mycode=`objdump -d ./$1|grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\\x/g'|paste -d '' -s |sed 's/^/"/' | sed 's/$/"/g'`

echo '[+] Assemble shellcode C ...'

echo "#include<stdio.h>" >shellcode.c
echo "#include<string.h>" >>shellcode.c
echo "unsigned char code[] = \\" >>shellcode.c
echo $mycode";" >>shellcode.c
echo "main()" >>shellcode.c
echo "{" >>shellcode.c
echo "printf(\"Shellcode Length:  %d\n\", strlen(code));" >>shellcode.c
echo "  int (*ret)() = (int(*)())code;" >>shellcode.c
echo "  ret();" >>shellcode.c
echo "}" >>shellcode.c

echo '[+] Compile shellcode.c'

gcc -fno-stack-protector -z execstack shellcode.c -o shellcode

echo '[+] Done!'
