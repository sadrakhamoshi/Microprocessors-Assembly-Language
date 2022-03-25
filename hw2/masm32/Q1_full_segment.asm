.386
.model flat,stdcall
option casemap:none

include D:\masm32\include\windows.inc
include D:\masm32\include\kernel32.inc
include D:\masm32\include\masm32.inc
include D:\masm32\include\masm32rt.inc

includelib D:\masm32\lib\kernel32.lib
includelib D:\masm32\lib\masm32.lib

stseg   segment
        db      64 dup(?)
stseg   ends

.DATA
dataseg SEGMENT
    resutl_string db 16 DUP (0)
    res db 00h
    num1 db 16h
    num2 db 03h

dataseg ENDS

.CODE
codeseg   SEGMENT
HEX_to_DEC PROC             ; ARG: EDI pointer to string buffer
    mov ebx, 10             ; Divisor = 10
    xor ecx, ecx            ; ECX=0 (digit counter)
  @@:                       ; First Loop: store the remainders
    xor edx, edx
    div ebx                 ; EDX:EAX / EBX = EAX remainder EDX
    push dx                 ; push the digit in DL (LIFO)
    add cl,1                ; = inc cl (digit counter)
    or  eax, eax            ; AX == 0?
    jnz @B                  ; no: once more (jump to the first @@ above)
  @@:                       ; Second loop: load the remainders in reversed order
    pop ax                  ; get back pushed digits
    or al, 00110000b        ; to ASCII
    stosb                   ; Store AL to [EDI] (EDI is a pointer to a buffer)
    loop @B                 ; until there are no digits left
    mov byte ptr [edi], 0   ; ASCIIZ terminator (0)
    ret                     ; RET: EDI pointer to ASCIIZ-string
HEX_to_DEC ENDP

multiple PROC   FAR    

    mov al, num1
    mov cl, num2        
	add_label: add res, al
    loop add_label

    movzx eax, res         
    lea edi, resutl_string      
    call HEX_to_DEC
    invoke StdOut, addr resutl_string

    movzx eax, res
    invoke ExitProcess, 0

multiple  ENDP
codeseg   ENDS
END   multiple