.model small
            .stack 64
            .data

result      dw      0h, 0h, 0h, 0h, 0h, 0h

num1        dw      2224h, 5444h, 4322h ; 4322 5444 2224h                                                    
num2        dw      1111h, 7444h, 3336h ; 1111 7444 3336h

            .code
main        proc far
            mov ax, @data
            mov ds, ax
            call multiple
            
            mov ah, 4ch
            int 21h
main        endp

multiple    proc
            
            mov si, 0
    loop1:  cmp si, 8
            jle start  
            ret

    start:
            mov cx, si
    loop2:  mov bp, si
            sub bp, cx
            
            cmp bp, 4
            jg loop1_break
            
            cmp cx, 4
            jg loop2_break
            
            mov dx, 0
            mov ax, ds:num1[bp]
            mov di, cx
            mov bx, num2[di]
            mul bx
            
            add result[si], ax
            adc dx, 0
            add result[si + 2], dx
            
            cmp cx, 0
            je loop1_break
            
loop2_break:   
            dec cx
            dec cx
            jmp loop2

loop1_break:      
            inc si
            inc si
            jmp loop1 
multiple    endp
            end main