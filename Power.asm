global _start       ; объявление старт
    section .text ; секция текст
 
    _start:  ; Старт
 
; вывод первой строки
    mov edx, len    ;длина сообщения
    mov ecx, msg    ;сообщение для написания
    mov ebx, 1      ;file descriptor (stdout)
    mov eax, 4      ;system call number (sys_write)
    int 0x80        ;call kernel

;Первый вызов
    mov al,1
	mov bl,2
	mov cl,2
	
	call Power
	
	call Calling_output
	
	call Tab
	
;Второй вызов

	mov al,1
	mov bl,2
	mov cl,8
	
	call Power
	
	XOR cl,cl
	XOR bl,bl
	
	call Calling_output_double
	
	call Tab
	
;Третий вызов

	mov al,1
	mov bl,3
	mov cl,2
	
	call Power
	
	
	call Calling_output
	
	call Tab
	
	
	
	;конец работы
    mov eax, 1      ;system call number (sys_exit)
    int 0x80        ;call kernel
	

Power: ; Степень числа
    
Pow:

    mul bl
    dec cl
    cmp cl,0
    jne Pow
    
ret

Calling_output_double:

    mov bl,10
    
Calculations:
    inc cl ; Считываем значение счётчика
    div bl ; Делим AX на BL
    mov [F],al ; ЗАНОСИМ значение al в F
    XOR al,al ; очищаем al = 0
    push ax ; убираем из AX -> AH
    XOR ah,ah ; Очищаем ah
    mov al,[F] ; Возвращаем значение из F в Al
    cmp al,0 ; Сравниваем al == 0
    jne Calculations ; al != 0 ? cal : ret

    
OutPut:

    pop ax ; возвращаем ah в ax
    mov [B],cl ; cl -> [B]
    
    add ah, '0' 
	mov [buf],ah
    mov edx, 1    ;длина сообщения
    mov ecx, buf    ;сообщение для написания
    mov ebx, 1      ;file descriptor (stdout)
    mov eax, 4      ;system call number (sys_write)
    int 0x80        ;call kernel
    
    mov cl,[B] ; записываем очищеное значение счётчика в cl
    dec cl ; проверяем количество выводов
    cmp cl,0
    jne OutPut
    
    
ret

Calling_output: ; вывод строки
    add al, '0' 
	mov [buf],al
    mov edx, 1    ;длина сообщения
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

section	.data

msg	db	'Result: ',0xa	;our dear string
len	equ	$ - msg			;length of our dear string
tab db ' '

section .bss
    F resd 1
    B resd 1
    buf  resd    1               ;длина строки в буфере