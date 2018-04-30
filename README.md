# Binaries

## Part 1

__You are given two subroutines written in x86 assembly. Your task is to reverse engineer both of them to figure out what they are trying to accomplish. The main goal for each of them is listed as a comment in both files. Your submission should include a qualitative description of what subroutines are doing. Depending on how you came across your answers, please provide any supporting materials that show your understanding of the code snippets.__


So in order to start running this program I made ```_start``` global so that it is visible to the linker, and within my ```_start``` label I call ```do_this```, I then assemble the files using this command ```yasm -g dwarf2 -felf32 re1.x```, I use ```-g dwarf2``` to enable debugging. I then assembled the files using ```ld -m elf_i386 re1.o -o re1.x``` to turn the file into an executables. These executables I ran with gdb to find out what exactly they were doing.


![alt text](https://github.com/yreiss1/Binaries/blob/master/Screen%20Shot%202018-04-29%20at%209.22.08%20PM.png)


Using the ```info registers``` command I was able to see the value of each or all of the registers.

![alt text](https://github.com/yreiss1/Binaries/blob/master/Screen%20Shot%202018-04-29%20at%209.23.45%20PM.png)


I did the same process for both ```re1.s``` and ```re2.s``` and these are the results of my snoopings

![alt text](https://github.com/yreiss1/Binaries/blob/master/Screen%20Shot%202018-04-29%20at%209.39.16%20PM.png)

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


The code above returns the value: ```67616c66h```


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

This code above returns the value: ```33383952h```






## Part 2

__Write a function in x86 assembly 32-bit mode with the label tribonacci that computes the Tribonacci sequence. The sequence is defined as:

__T(0) = 0
T(1) = 1
T(2) = 1
T(n) = T(n-1) + T(n-2) + T(n-3)__


My code is adapted from some code from my CMSC216 class, I simply added another recursive call with parameter n-2, the code can be found [here](https://github.com/yreiss1/Binaries/blob/master/tribonacci.s)

