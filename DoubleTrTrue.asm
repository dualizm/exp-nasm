global _start       ; объявление старт
    section .text ; секция текст
 
    _start:  ; Старт
 
; вывод первой строки
    mov edx, len    ;длина сообщения
    mov ecx, msg    ;сообщение для написания
    mov ebx, 1      ;file descriptor (stdout)
    mov eax, 4      ;system call number (sys_write)
    int 0x80        ;call kernel

    mov al,0 
    mov bl,1
    mov cl,7
    mov [res],cl
    
    call First ; Выводим первое число ряда
    call Two ; выводим второе число ряда
    
    call Fib ; считаем и выводим ряд до предела
    
	;конец работы
    mov eax, 1      ;system call number (sys_exit)
    int 0x80        ;call kernel
	

Fib:
    
L1: add al, bl
    push ax
loop L1


    call Callingres
    
ret


Callingres:
mov cl,[res]
KEK:
    pop ax
    mov [F],cl ; cl -> [b]
    XOR cl,cl ; cl = 0
    
    add al, '0' 
	mov [buf],al
    mov edx, 1    ;длина сообщения
    mov ecx, buf    ;сообщение для написания
    mov ebx, 1      ;file descriptor (stdout)
    mov eax, 4      ;system call number (sys_write)
    int 0x80        ;call kernel
    
    mov cl,[F] ; записываем очищеное значение счётчика в cl
    loop KEK
    
ret

Tab:
    mov edx, 1    ;длина сообщения
    mov ecx, tab    ;сообщение для написания
    mov ebx, 1      ;file descriptor (stdout)
    mov eax, 4      ;system call number (sys_write)
    int 0x80        ;call kernel
ret


First:
    add al,'0'
    mov [buf],al
    mov edx, 1   ;длина сообщения
    mov ecx, buf    ;сообщение для написания
    mov ebx, 1      ;file descriptor (stdout)
    mov eax, 4      ;system call number (sys_write)
    int 0x80        ;call kernel
    call Tab
ret

Two:
    add bl,'0'
    mov [buf],bl
    mov edx, 1   ;длина сообщения
    mov ecx, buf    ;сообщение для написания
    mov ebx, 1      ;file descriptor (stdout)
    mov eax, 4      ;system call number (sys_write)
    int 0x80        ;call kernel
    call Tab

ret

section	.data

msg	db	'Result: ',0xa	;our dear string
len	equ	$ - msg			;length of our dear string

tab db ' '

section .bss
    res resb 1
    F resb 1
    buf  resd    1               ;длина строки в буфере