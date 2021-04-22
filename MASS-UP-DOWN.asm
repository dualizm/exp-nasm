section	.text
	global _start       ;must be declared for using gcc
_start:                     ;tell linker entry point
	
	call StrRes
	
	mov al,[x]
	sub al,'0'
	
	call PrintfUp
	call Tab
	
	mov al,[y]
	sub al,'0'
	
	call PrintfDown
	call Tab
	
	call Carret
	call MsString
	
	mov ecx,0
	call PrintfStringUp
	
	call Carret
	call MsString
	
	mov ecx,0
	call PrintfStringDown
	
	mov	eax, 1	    ;system call number (sys_exit)
	int	0x80        ;call kernel
	
PrintfStringUp:

upstr:
    mov al,[mstrD+ecx]
    sub al,'0'
    
    mov [hold],ecx
    XOR ecx,ecx
    
    sub al,32
    add al,'0'
    mov [buf],al
    mov edx, 1   ;длина сообщения
    mov ecx, buf    ;сообщение для написания
    mov ebx, 1      ;file descriptor (stdout)
    mov eax, 4      ;system call number (sys_write)
    int 0x80        ;call kernel
    
    mov ecx,[hold]
    inc ecx
    
    cmp ecx,5
    jne upstr

ret

PrintfStringDown:

downstr:
    mov al,[mstrU+ecx]
    sub al,'0'
    
    mov [hold],ecx
    XOR ecx,ecx
    
    add al,32
    add al,'0'
    mov [buf],al
    mov edx, 1   ;длина сообщения
    mov ecx, buf    ;сообщение для написания
    mov ebx, 1      ;file descriptor (stdout)
    mov eax, 4      ;system call number (sys_write)
    int 0x80        ;call kernel
    
    mov ecx,[hold]
    inc ecx
    
    cmp ecx,5
    jne downstr

ret
	
PrintfUp:
    sub al,32
    add al,'0'
    mov [buf],al
    mov edx, 1   ;длина сообщения
    mov ecx, buf    ;сообщение для написания
    mov ebx, 1      ;file descriptor (stdout)
    mov eax, 4      ;system call number (sys_write)
    int 0x80        ;call kernel

ret

PrintfDown:
    add al,32
    add al,'0'
    mov [buf],al
    mov edx, 1   ;длина сообщения
    mov ecx, buf    ;сообщение для написания
    mov ebx, 1      ;file descriptor (stdout)
    mov eax, 4      ;system call number (sys_write)
    int 0x80        ;call kernel

ret

Tab:
    mov edx, 1    ;длина сообщения
    mov ecx, tab    ;сообщение для написания
    mov ebx, 1      ;file descriptor (stdout)
    mov eax, 4      ;system call number (sys_write)
    int 0x80        ;call kernel
ret

Carret:
    mov edx, 1    ;длина сообщения
    mov ecx, crt    ;сообщение для написания
    mov ebx, 1      ;file descriptor (stdout)
    mov eax, 4      ;system call number (sys_write)
    int 0x80        ;call kernel
ret

StrRes:
	mov	edx, len    ;message length
	mov	ecx, msg    ;message to write
	mov	ebx, 1	    ;file descriptor (stdout)
	mov	eax, 4	    ;system call number (sys_write)
	int	0x80        ;call kernel
ret

MsString:
	mov	edx, lmassres    ;message length
	mov	ecx, massres    ;message to write
	mov	ebx, 1	    ;file descriptor (stdout)
	mov	eax, 4	    ;system call number (sys_write)
	int	0x80        ;call kernel
ret

section	.data

msg	db	'Result: '	;our dear string
len	equ	$ - msg			;length of our dear string

x db 'a'
tab db ' '
y db 'A'
crt db '',0xa

massres db 'Mass result: '
lmassres equ $ - massres

global mstrD

mstrD:
    db 'h' ;0
    db 'e' ;1
    db 'l' ;2
    db 'l' ;3
    db 'o' ;4
    
global mstrU

mstrU:
    db 'H' ;0
    db 'E' ;1
    db 'L' ;2
    db 'L' ;3
    db 'O' ;4


section .bss
    buf db 1
    hold db 1