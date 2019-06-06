	.globl hms_to_sec
# Omformer et klokkeslett (angitt i timer, minutter og sekunder) til
# antall sekunder.
# gcc -o test-sec test-sec.c sec.s
# ./test-sec

hms_to_sec:
	movq %RDI,%R8	#Legger første param i en variabel R8
	imulq $3600,%R8	#Ganger med 3600 for å finne verdien i timer

	movq %RSI,%R9	#Legger andre param i en variabel R9
	imulq $60,%R9	#Ganger med 60 for å finne verdien i minutter

	movq %RDX,%R10	#legger tredje param i en variabel R10 (er i sekunder)
	
	addq %R8,%R9	#Legger verdien av timer sammen med minutter
	addq %R9,%R10	#Legger timer og minutter sammen med sekunder
	movq %R10,%RAX	#Flytter verdien i RAX slik at den blir printet ut.
	ret
	
	.globl	sec_to_h
# Gitt et tidspunkt (angitt som sekunder siden midnatt), finn timen.
	
sec_to_h:
	movq %RDI,%RAX	#Legger param i RAX
	movq $3600,%R8	#Legger 3600 i variabel R8
	cqo				
	idivq %R8		#Deler verdien i RAX med 3600 for å finne timer. Verdi etter deling ligger i RAX som blir printet.
	ret
	
	.globl	sec_to_s
# Gitt et tidspunkt (angitt som sekunder siden midnatt), finn minuttet.
	
sec_to_m:
	movq %RDX,%RAX	#Legger param i RAX
	movq $60,%R8	#Legger 60 i variabel R8
	cqo
	idivq %R8		#Deler verdien i RAX med 60 for å finne minutter. Verdi etter deling ligger i RAX som blir printet.
	ret

# Gitt et tidspunkt (angitt som sekunder siden midnatt), finn sekundet.
	
sec_to_s:
	movq %RDI,%RAX	#Legger param i RAX
	movq $60,%R8	#Legger 60 i variabel R8
	cqo
	idivq %R8		#Deler verdien i RAX med 60 for å finne minutter
	movq %RDX,%RAX	#Legger rest verdien i RAX, slik at den blir printet ut
	ret
	
	.globl	sec_to_m
