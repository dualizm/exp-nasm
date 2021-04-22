global _start       ; объявление старт

    section .text ; секция текст

    _start:  ; Старт

; вывод первой строки
    mov edx, len    ;длина сообщения
    mov ecx, msg    ;сообщение для написания
    mov ebx, 1      ;file descriptor (stdout)
    mov eax, 4      ;system call number (sys_write)
    int 0x80        ;call kernel
; перевод '5' -> 5
; вычисление факториала числа
    mov al,[x]
    sub al,'0'
    
	mov cl,al       
    mov al,1             
    cycle:
    mul cl
    dec cl
    cmp cl,1
    jne cycle
    
    call    ShowInt32
    
    call    NewLine
;Процедура вывода 32-разрядного числа со знаком (int32) в консоль
;на входе:
;  eax - число для вывода
ShowInt32:
        push    edi
        push    ecx
        push    ebx
 
        ;преобразование числа в строку
        ;строка сохраняется в глобальной переменной buf,
        ;а её длина - в переменной buflen
        lea     edi,    [buf]
        xor     ecx,    ecx
        mov     [buflen],ecx
        mov     ebx,    10
        test    eax,    eax             ;если число отрицательное, то
        jns     .do                     ;поместим в строку символ "-"
                neg     eax             ;и возьмём абсолютное значение
                mov     [edi],  byte '-'
                mov     [buflen],       byte 1
                inc     edi
        .do:
                xor     edx,    edx
                div     ebx
                add     dl,     '0'     ;преобразуем число (от 0 до 9) в символ цифры
                push    edx             ;заносим в стек для последующего вывода в порядке слева направо
                inc     ecx
                test    eax,    eax
        jnz     .do
        add     [buflen],ecx            ;запоминаем длину строки
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
 

;Процедура перевода строки
NewLine:
        mov     [buf],  byte 0Ah        ;код управляющего символа "перевод строки"
        mov     [buflen], dword 1       ;занимает 1 байт
        mov     edx,    [buflen]        ;message length
        mov     ecx,    buf             ;message to write
        mov     ebx,    1               ;file descriptor (stdout)
        mov     eax,    4               ;system call number (sys_write)
        int     0x80                    ;call kernel
ret

;конец работы
    mov eax, 1      ;system call number (sys_exit)
    int 0x80        ;call kernel


    section	.data
        x db '5'
        msg db  'Factorial :',0xa ;our dear string
        len equ $ - msg         ;length of our dear string

    section .bss
            buflen  resd    1               ;длина строки в буфере
            buf     resb    1024            ;буфер для ввода и вывода сообщений