#!/bin/bash

echo '####################################################################'
echo 'Usage: ./compile.sh <egghunter> <shellcode> <egg>'
echo 'Example (without extensions!): ./compile.sh egghunter shellcode woof'
echo '####################################################################'
echo '[+] Changing egg to '$3' ...'
>eggcode.txt
for i in `echo -n $3|rev|tr -d '\n'|xxd -g 1 -c 1|cut -d " " -f2|grep -Eo '^[0-9a-f]{2}$'` ; do echo -n "$i" >>eggcode.txt ; done
echo '[+] New eggcode in hex little-endian:'
myegg=`cat eggcode.txt`
echo $myegg
cp $1.nasm $1.nasm_orig
sed s/0x696c6162/0x$myegg/g < $1.nasm_orig > $1.nasm

echo '[+] Assembling '$1' Egghunter with Nasm ... '
nasm -f elf32 -o $1.o $1.nasm

echo '[+] Linking ...'
ld -o $1 $1.o

echo '[+] Objdump ...'
>egghunter.txt
for i in `objdump -d $1|tr '\t' ' '|tr ' ' '\n'|grep -Eo '^[0-9a-f]{2}$'` ; do echo -n "\x$i" >>egghunter.txt ; done
myegghunter=`cat egghunter.txt`
echo $myegghunter


###########################################################################
#changing egg plaintext
cp $2.nasm $2.nasm_orig
sed s/balibali/$3$3/g < $2.nasm_orig > $2.nasm

echo '[+] Assembling '$2' payload shellcode with Nasm ... '
nasm -f elf32 -o $2.o $2.nasm

echo '[+] Linking ...'
ld -o $2 $2.o

echo '[+] Objdump ...'
>shellcode.txt
for i in `objdump -d $2|tr '\t' ' '|tr ' ' '\n'|grep -Eo '^[0-9a-f]{2}$'` ; do echo -n "\x$i" >>shellcode.txt ; done
myshellcode=`cat shellcode.txt`
echo $myshellcode

echo '[+] Assemble shellcode C ...'
#myshellcode="AABBCCDDEEFFABCD"
echo "#include<stdio.h>" >shellcode.c
echo "#include<string.h>" >>shellcode.c
#echo "#include<stdio.h>" >>shellcode.c
echo "unsigned char egg[] = \"$3\";" >>shellcode.c
echo "unsigned char egghuntercode[] = \"\\" >>shellcode.c
echo $myegghunter"\";" >>shellcode.c
echo "unsigned char shellcode[] = \"\\" >>shellcode.c
echo $myshellcode"\";" >>shellcode.c
echo "main()" >>shellcode.c
echo "{" >>shellcode.c
echo "printf(\"Egghuntercode Length:  %d\n\", strlen(egghuntercode));" >>shellcode.c
echo "printf(\"Shellcode Length    :  %d\n\", strlen(shellcode));" >>shellcode.c
echo "char *heap;" >> shellcode.c
echo "heap=malloc(400);" >> shellcode.c
echo "printf(\"Memory address of shellcode: %p\n\",heap);" >> shellcode.c
echo "memcpy(heap+0,egg,4);" >> shellcode.c
echo "memcpy(heap+4,egg,4);" >> shellcode.c
echo "memcpy(heap+8,shellcode, sizeof(shellcode)-1);" >> shellcode.c
echo "  int (*ret)() = (int(*)())egghuntercode;" >>shellcode.c
echo "  ret();" >>shellcode.c
echo "}" >>shellcode.c

echo '[+] Compile shellcode.c'

gcc -fno-stack-protector -z execstack shellcode.c -o shellcode

echo '[+] Done!' 
