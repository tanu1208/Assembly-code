;    nasm -f elf -g -F stabs ROT13.asm
;    gcc -m32 ROT13.o -o ROT13

SECTION .bss
Buff:    resb 1      ; Hold the value for encrypted text


SECTION .data
CountMsg:   db 10,"%d characters read",10,10,0
fileFmt: 	db "%c",0
Count:      dd 0       ; Character count

SECTION .text

global main
extern getchar
extern puts 
extern printf

main:
    nop                 ; This no-op keeps the debugger happy
    mov edi, Buff       ; Initialization

Read: 
    call getchar        ; Read a character
    cmp eax,0           ; End of input file?
    jl Write
    mov [edi],al        ; Store character in buffer
    inc edi
    inc dword [Count]   ; Increment count
    cmp dword [Count],199   ; Check for buffer overflow

    cmp byte[Buff],61h  ; Test input char against 'a'
    jae checkLowerCase  ; check if the input char is in the lower case range

    cmp byte[Buff],41h  ; Test input char against 'A' 
    jae checkUpperCase  ; check if the input char is in the upper case range

    jge Write           ; jump to Write if it is any other signs
    jmp Read

checkUpperCase:
    cmp byte[Buff],5Ah  ; Test input char against 'Z'
    jbe add13Upper      ; jump to label if cmp is below or equal

checkLowerCase:
    cmp byte[Buff],7Ah  ; Test input char against 'z'
    jbe add13Lower      ; jump to label if cmp is below or equal

add13Lower:
    cmp byte[Buff],6Eh  ; Test input char against 'n'
    jae sub13           ; jump to label if the input is greater than n
    add byte[Buff],0Dh  ; adds 13, because the value is less than n
    jmp Write           ; Write the char to the file

add13Upper:
    cmp byte[Buff],4Eh  ; Test input char against 'N'
    jae sub13           ; jump to label if the input is greater than N
    add byte[Buff],0Dh  ; adds 13, because the value is less than N
    jmp Write           ; Write the char to the file

sub13:
    sub byte[Buff],0Dh  ; subtract 13 because value is higher than the input value
    jmp Write           ; Write the char to the file

Write: 
    mov byte [edi],0    ; Put null at end of string

    push Buff        	; Address of Buff
    call puts      	 	; Print
    add esp,4       	; Clean stack, one parm
    push dword [Count]  ; Value of Count
    push CountMsg       ; Format string
    call printf
    add esp,8       	; Clean stack, two parms


    ret         		; Done, return