#!/bin/bash
echo 'Usage: CH05_compile.sh shellcode'

echo '[+] Read code ...'

echo '[+] Assemble shellcode C ...'

echo "#include<stdio.h>" >shellcode.c
echo "#include<string.h>" >>shellcode.c
cat $1 >> shellcode.c
echo "main()" >>shellcode.c
echo "{" >>shellcode.c
echo "printf(\"Shellcode Length:  %d\n\", strlen(buf));" >>shellcode.c
echo "  int (*ret)() = (int(*)())buf;" >>shellcode.c
echo "  ret();" >>shellcode.c
echo "}" >>shellcode.c

echo '[+] Compile shellcode.c'

gcc -fno-stack-protector -z execstack shellcode.c -o shellcode

echo '[+] Done!' 
