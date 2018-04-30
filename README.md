# Binaries

## Part 1



The code in ```re1.s```:
```

section .text

global _start

section .text
do_this:
  push ebp          ;pushes the base pointer to the stack so that it can be returned to later
  mov ebp, esp      ;set the base pointer to the same location of the stack pointer, effectively creating a new frame

  mov ecx, 4        ;setting the register ecx with the value of 4, to be used in the loop below
  mov dl, 0ffh      ;setting the lower 8 bits of register dx to be 11111111 11111111

f:
  shl eax, 8        ;shifting eax left by 8 bits
  or al, dl         ;bitwise or operation between the lower 8 bits of ax and lower 8 bits of dx
  loop f            ;loops 4 times, the value in ecx, and sets all 32 bites of eax to 1

  mov ecx, 8        ;sets the register ecx with the value 8
  mov dx, 6761h     ;sets the lower 16 bits of edx to this binary value (0110 0111 0110 0001)
  shl edx, cl       ;shifting edx left by the value in cl, which is 8
  shl edx, cl       ;shifting edx left by the value in cl, which is 8
  mov dx, 6c66h     ;sets the lower 16 bits of edx to this binary value (0110 1100 0110 0110)

  xor eax, edx      ;bitwise xor operation between eax and edx, result stored in eax
  not eax           ;bitwise negation

  mov esp, ebp      ;moving the position of the stack pointer back to the base pointer
  pop ebp           ;poping the previous location of the base pointer
  ret               ;return call
  
_start:

  do_this
```


This code returns the value: ```67616c66h```


The code in ```re2.s```:

```
; what does this return?
section .text
do_this:
  push ebp            ;pushes the base pointer to the stack so that it can be returned to later
  mov ebp, esp        ;set the base pointer to the same location of the stack pointer, effectively creating a new frame
  push edi            ;pushes the value at edi onto stack

  mov al, 33h         ;sets the value of the lower part of the register ax with the binary value 0011 0011
  mov cl, 4           ;sets the value of the lower part of the register cx with the value 4
  lea edi, [x]        ;loads the address of x into register edi

  rep stosb           ;repeats the instruction until ecx is zero, which happend 4 times, each time moving the value at al (33h) into x

  xor BYTE [x], 0     ;xors the value at [x] with 0 = 33h
  xor BYTE [x+1], 0bh ;xors the value ot [x+1] with 0bh = 38h
  xor BYTE [x+2], 0ah ;xors the value at [x+2] with 0ah = 39h
  xor BYTE [x+3], 61h ;xors the value at [x+3] with 61h = 52h

  mov eax, [x]        ;sets the value of eax with the value at x which is now 33383952h

  pop edi             
  mov esp, ebp        ;returns the stack pointer to the address of the base pointer
  pop ebp             ;returns the base pointer back to its previous address
  ret                 ;return call, returns the value at eax

section .data         ;where data x is stored
x dd 0
```

This code returns the value: ```33383952h```






## Part 2


```
section .text
	global _start

section .text

_start:

		push eax
		mov eax, 0		
		call tribonacci
		
		
		

tribonacci:	       
		      push ebp			      ;saves old frame pointer
	        mov ebp, esp	      ;sets new frame pointer
	     
		      mov ecx, [ebp+8]		;retrieving parameter
	     
		      cmp ecx, 0			    ;if parameter is 0
		      jle return			    ;moves to end of program

		      cmp ecx, 1			    ;if parameter is 1
		      je basecase	
	      
		      cmp ecx, 2			    ;if parameter is 2
		      je basecase

		      mov edx, 1
		      sub ecx, edx			  ;n - 1
	       	push ecx			      ;passes in parameter n - 1
	       	call tribonacci			;makes recursive call
	       	pop ecx				      ;retrieves parameter


	       	mov edx, 1	
	       	sub ecx, edx			  ;n - 2
	       	push ecx 			      ;passes in parameter n - 2
	       					
	       	call tribonacci			;makes recursive call
		      pop ecx				

	       	mov edx, 1
		      sub ecx, edx			  ;n - 3
	       	push ecx			      ;passes in parameter n - 3

	      	call tribonacci			;makes recursive call
		      pop ecx

	       	jmp return			    ;moves to end of program

	       

basecase:     
          mov edx, 1		
	       	add eax, edx			    ;adds 1 to return value
	       
return:        
          mov esp, ebp			    ;reset stack pointer
	       	pop ebp    			      ;restore old frame pointer
	       	ret
```
