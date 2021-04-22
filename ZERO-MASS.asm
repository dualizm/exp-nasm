global _start       ; объявление старт
    section .text ; секция текст
 
    _start:  ; Старт
 
; вывод первой строки
    mov edx, len    ;длина сообщения
    mov ecx, msg    ;сообщение для написания
    mov ebx, 1      ;file descriptor (stdout)
    mov eax, 4      ;system call number (sys_write)
    int 0x80        ;call kernel
 
    XOR eax,eax
    mov ecx,10
    mov edx,0
    mov ebx,0
cycle:
    
    cmp byte [x+ecx],0
    je plus
    
e:
    loop cycle
 
    
    call show
    
    ;конец работы
    mov eax, 1      ;system call number (sys_exit)
    int 0x80        ;call kernel
 
plus:
 
    add edx,1
    
    jmp e
 
show:

    add edx,'0'
    mov [buf],edx
    mov edx, 1   ;длина сообщения
    mov ecx, buf    ;сообщение для написания
    mov ebx, 1      ;file descriptor (stdout)
    mov eax, 4      ;system call number (sys_write)
    int 0x80        ;call kernel
ret
 
 
section .data
 
msg db  'Result: ',0xa  ;our dear string
len equ $ - msg         ;length of our dear string
 
global x
 
x: 
    db 1
    db 2
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    
section .bss
    section .bss
    F resb 1
    buf resb 1
