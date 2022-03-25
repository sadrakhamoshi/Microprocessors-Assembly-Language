.386
.model flat,stdcall
option casemap:none

include D:\masm32\include\windows.inc
include D:\masm32\include\kernel32.inc
include D:\masm32\include\masm32.inc
include D:\masm32\include\masm32rt.inc

includelib D:\masm32\lib\kernel32.lib
includelib D:\masm32\lib\masm32.lib


.data
	num1	db 16h
	num2	db 03h
	res		db ?
.code


start :
    mov al, num1
    mov cl, num2        
	add_label: add res, al
    loop add_label
    movzx eax, res
	printf ("The result is : %u\n",eax)


    invoke ExitProcess, 0
end start