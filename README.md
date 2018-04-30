# Binaries

## Part 1


```
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
```

## Part 2
