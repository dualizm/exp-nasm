section	.text
	global _start       ;must be declared for using gcc
_start:                     ;tell linker entry point
	
	call StrRes
	call Carret
	
	mov ecx,3
	call doubleM
	
	mov ecx,0

printfs:
	
	mov al,[x+ecx]
	call ShowUInt32
	
	inc ecx
	
	cmp ecx,3
	jne printfs
	
	call Carret
	
mov ecx,0
	
printfs_2:
	
	mov al,[y+ecx]
	call ShowUInt32
	
	inc ecx
	
	cmp ecx,3
	jne printfs_2
	

	
	mov	eax, 1	    ;system call number (sys_exit)
	int	0x80        ;call kernel
	
	

	
	
ShowUInt32:
        push    edi
        push    ecx
        push    ebx
 
        ;преобразование числа в строку
        ;строка сохраняется в глобальной переменной buf,
        ;а её длина - в переменной buflen
        lea     edi,    [buf]
        xor     ecx,    ecx
        mov     ebx,    10
        .do:
                xor     edx,    edx
                div     ebx
                add     dl,     '0'     ;преобразуем число (от 0 до 9) в символ цифры
                push    edx             ;заносим в стек для последующего вывода в порядке слева направо
                inc     ecx
                test    eax,    eax
        jnz     .do
        mov     [buflen],ecx            ;запоминаем длину строки
        .store:
                pop     eax             ;извлекаем символ цифры
                stosb                   ;сохраняем его в строке и увеличиваем адрес указателя (edi) на 1
        loop .store
 
        ;вывод строки в консоль средствами операционной системы Linux
        mov edx, [buflen]               ;message length
        mov ecx, buf                    ;message to write
        mov ebx, 1                      ;file descriptor (stdout)
        mov eax, 4                      ;system call number (sys_write)
        int 0x80                        ;call kernel
 
        pop ebx
        pop ecx
        pop edi
ret

doubleM:

    mov bl,2

cycle:
    mov al,[x+ecx-1]
    mul bl
    mov [y+ecx-1],al
    loop cycle

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

section	.data

msg	db	'Result: '	;our dear string
len	equ	$ - msg			;length of our dear string

tab db ' '
crt db '',0xa

global x

x:
    db 12
    db 6
    db 6
    
global y

y times 3 db 0

section .bss
        buflen  resd    1               ;длина строки в буфере
        buf     resb    1024            ;буфер для ввода и вывода сообщений
    hold db 1