SECTION .data
keyword: db "Atef Decryption Code"
len: equ $ - keyword
array TIMES 300 db 0

extern printf
extern getchar
extern putchar

SECTION .bss
SECTION .text

global main
main:

push ebp
mov ebp, esp

push ebx
xor ebx,ebx  ;let ebx be counter, set to 0

ReadLoop:    ;start reading from input file

call getchar
cmp eax,-1   ; if EOF
je Eof       ;   jump to Eof part
            ; else
mov BYTE [array+ebx],al ;store character to array
inc ebx ; increase ebx
jmp ReadLoop ;jump back to read again

Eof:

mov BYTE [array+ebx+1],-1 ;after reading the file
xor ebx,ebx   ;add a eof terminator at the end of array
xor eax,eax   ;reset the counter

Encry:

mov al, BYTE[array+ebx]
cmp al, -1
je Exit

cmp al, 'A'   ; if char is less than 'A'
jb Write      ;   print
cmp al, 'z'   ; else if char is above 'z'
ja Write      ;   print
cmp al, 'Z'   ; if char is less than 'Z'
jbe Upper      ;    process as a Upper
cmp al, 'a'   ; if char is above than 'a'
jae Lower      ;    process as a Lower
jmp Write     ; else print

Upper:

push ebx      ; save the counter
push eax      ; save the letter
mov eax, ebx  ; doing division
mov edx, 0    ; clear remainder
mov ebx, len  ; set divisor
div ebx
xor ebx,ebx
mov bl, BYTE [keyword+edx]
sub ebx,65    ; now ebx has the shifting number
pop eax       ; restore the letter
sub eax,ebx   ; shift
mov edx,ebx   ; let edx hold the shifting number
pop ebx       ; restore the counter
cmp eax,'A'   ; if eax is above 'A'
jae Write     ;     print
add eax,26    ; else correct it
jmp Write     ;     print


Lower:        ; similar case


push ebx      ; save the counter
push eax      ; save the letter
mov eax, ebx  ; doing division
mov edx, 0    ; clear remainder
mov ebx, len  ; set divisor
div ebx ; make the division on ebx
xor ebx,ebx
mov bl, BYTE [keyword+edx] ; check the number in edx and shift it 
sub ebx,65    ; now ebx has the shifting number
pop eax       ; restore the letter
sub eax,ebx   ; shift
mov edx,ebx   ; edx has shifting numbers
pop ebx       ; counter reset
cmp eax,'a'   ; above 'a'
jae Write     ;     go to exit and print 
add eax,26    ; correct it


Write:
push eax
call putchar
add esp,4

xor eax,eax
inc ebx
jmp Encry

Exit: ; exit and print from the program

mov esp,ebp ; the gcc code using 
pop ebp
Ret