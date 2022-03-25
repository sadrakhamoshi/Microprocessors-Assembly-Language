; INCLUDE \masm32\irvine\Irvine32.inc

.386
INCLUDE \masm32\include\masm32rt.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc

includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

option casemap:none


.data
nums word 10, 2, 3, 4, 0, 6, 7, 8, 9, 1    
sum dw 0 
avg db 0    
max dw 0   
min dw 0

.CODE
start:    
    ; compute sum of array  ****************************
    mov edi, OFFSET nums
    mov ecx, LENGTHOF nums - 1    ; start from end of array
    mov ax, 0
    
    loop1:
        add ax, [edi + ecx * 2]     ; get number from warray
    loop loop1
    add ax, [edi]

    mov sum, ax
    printf ("sum: %u\n", sum)

    ; compute average of nums **************************
    mov bl, 10
    mov ax, sum
    div bl
    mov avg, al
    printf("average is %u\n", avg)


    ; compute the minimum of nums *************************
    mov edi, OFFSET nums
    mov ecx, LENGTHOF nums - 1    ; start from end of array
    mov ax, 0
    mov min, 65535

    min_label:
        mov ax, [edi + ecx * 2]             ; get number from warray
        cmp min, ax
        jb  min_swap
        mov min, ax
        min_swap:
            loop min_label
    
    mov ax, [edi]
    cmp min, ax
    jb  pri1
    mov min, ax 
    pri1:
        printf("minimum is %u\n", min)

    ; compute the maximum of nums *************************
    mov edi, OFFSET nums
    mov ecx, LENGTHOF nums - 1    ; start from end of array
    mov ax, 0
    mov max, 0

    max_label:
        mov ax, [edi + ecx * 2]             ; get number from warray
        cmp max, ax
        ja  max_swap
        mov max, ax
        max_swap:
            loop max_label
    
    mov ax, [edi]
    cmp max, ax
    ja  pri2
    mov max, ax 
    pri2:
        printf("maximum is %u", max)
end start