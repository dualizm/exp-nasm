global _start       ; объявление старта
    section .text ; секция текст
_start:  ; Старт
; вывод первой строки
    mov edx, len    ;message length
    mov ecx, msg    ;message to write
    mov ebx, 1      ;file descriptor (stdout)
    mov eax, 4      ;system call number (sys_write)
    int 0x80        ;call kernel
; Перевод символа '5' в целочисленое значение 
    mov ebx, [x]   ;file descriptor (stdin = 0)
    mov ecx, buf    ;buffer address
    mov edx, buflen ;buffer length
    mov eax, 3      ;system call number (sys_read)
    int 0x80        ;call kernel
    
Cycle:
    mul cx                ; умножаем eax на ecx
    dec cx                ; вычитаем из ecx еденицу
    cmp cx,1         ; проверяем не равен ли ECX еденице
    jne Cycle     ; JNE= JUMP if  NOT EQUAL - переход если неравно.  если ECX != 1 - переходим на следующую итерацию.
    ; запись результата в переменную F
    
    mov [F],ax
 
    ;вывод результата
    mov eax, [F]
    call ShowUInt32
 
    mov eax, 1      ;system call number (sys_exit)
    int 0x80        ;call kernel

;Процедура вывода беззнакового числа 32-разрядного (uint32) в консоль
;на входе:
;  eax - число для вывода
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
        int 0x80   
 
        pop ebx
        pop ecx
        pop edi
ret
section	.data
x db '5'
msg db  'Factorial :',0xa ;our dear string
len equ $ - msg         ;length of our dear string
 
    section .bss
        F resb 1
        buflen  resd    1               ;длина строки в буфере
        buf     resb    1024            ;буфер для ввода и вывода сообщений
        buffer  resb 256
