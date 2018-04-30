section .text
	global _start

section .text

_start:

		push eax
		mov eax, 0		
		call tribonacci
		
		
		

tribonacci:	       
		push ebp				;saves old frame pointer
	    mov ebp, esp			;sets new frame pointer
	     
		mov ecx, [ebp+8]		;retrieving parameter
	     
		cmp ecx, 0				;if parameter is 0
		jle return				;moves to end of program

		cmp ecx, 1				;if parameter is 1
		je basecase	
	      
		cmp ecx, 2				;if parameter is 2
		je basecase

		mov edx, 1
		sub ecx, edx			;n - 1
	    push ecx				;passes in parameter n - 1
	    call tribonacci			;makes recursive call
       	pop ecx					;retrieves parameter


       	mov edx, 1	
       	sub ecx, edx			;n - 2
       	push ecx 				;passes in parameter n - 2
       					
       	call tribonacci			;makes recursive call
		pop ecx				

   		mov edx, 1
		sub ecx, edx			;n - 3
   		push ecx				;passes in parameter n - 3

      	call tribonacci			;makes recursive call
		pop ecx

	    jmp return				;moves to end of program

	       

basecase:     
        mov edx, 1		
       	add eax, edx			;adds 1 to return value
	       
return:        
       	mov esp, ebp			;reset stack pointer
       	pop ebp    				;restore old frame pointer
       	ret