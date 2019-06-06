;    nasm -f elf -g -F stabs PA06.asm
;    gcc -m32 PA06.o -o PA06

%macro Print 2					; 
	push	%2					; pushing the format
	push	%1					; pushing the value
	call	printf				; printing out the value
	add	esp,8					; clean stack, two parms
%endmacro

SECTION .bss
Start	equ	01h					; defining the start
Mask	equ	0Ch 				; define LFSR mask for  x^4+x^3+1
	

SECTION .data
outputPrint		db 	"Hex: 0x0%xh --- Dec: %d",10

SECTION .text

global main
extern printf

main:
	xor	eax,eax					; resetting the register to 0
	xor	ebx,ebx					; resetting the register to 0
	mov	eax,Start				; eax=Start

Loop:
	call	LFSR				; calling the LFSR method
	push	eax					; save eax on the stack
	Print outputPrint, eax		; sending the print message + the value
	pop	eax						; get eax
	cmp	eax,Start				; comparing eax with the start
	jne	Loop					; continue loop

	mov	al,1					; setting al to 1
	xor	ebx,ebx					; resetting the register to 0
	int	80h						; make kernel call

LFSR:
	mov	ebx,eax					; save eax in ebx
	and	ebx,1					; ebx=ebx AND 1
	shr	eax,1					; shift right eax with 1
	cmp	ebx,1					; compare ebx with 1
	jne	end						; if not equal, end
	mov	ebx,Mask				; if equal, ebx=mask and
	xor	eax,ebx					; apply mask to eax

end:	
	ret