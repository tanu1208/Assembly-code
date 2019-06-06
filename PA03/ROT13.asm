;    nasm -f elf -g -F stabs ROT13.asm
;    gcc -m32 ROT13.o -o ROT13

section .bss
Buff resb 1            ; hold the value of one char

section .data

section .text 
global _start

_start:
    nop                 ; This no-op keeps the debugger happy

Read: 
    mov eax,3           ; Specify sys_read call
    mov ebx,0           ; Specify File Descriptor 0: Standard Input (STDIN)
    mov ecx,Buff        ; Pass offset of the buffer to read to 
    mov edx,1           ; Tell sys_read to read one char from stdin 
    int 80H             ; Call sys_read

    cmp eax,0           ; Look at sys_read's return value in EAX
    je Exit             ; Jump If Equal to 0 (0 means EOF) to Exit
                        ; or fall through to test for lowercase

    cmp byte[Buff],61h  ; Test input char against 'a'
    jae checkLowerCase  ; check if the input char is in the lower case range

    cmp byte[Buff],41h  ; Test input char against 'A' 
    jae checkUpperCase  ; check if the input char is in the upper case range

    jmp Write           ; jump to Write if it is any other signs

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
    mov eax,4           ; Specify sys_write call
    mov ebx,1           ; Specify File Descriptor 1: Standard output (STDOUT)
    mov ecx,Buff        ; Pass address of the character to write 
    mov edx,1           ; Pass number of chars to write
    int 80h             ; Call sys_write...
    jmp Read            ; then go to the beginning to get another char 

Exit: 
    mov eax,1           ; Code for Exit Syscall
    mov ebx,0           ; Return a code of zero to Linux 80H ; Make kernel call to exit program
    int 80H             ; Make kernel call to exit program