            .model small
            .stack 64
            .data

buffer      db  32
            db ?
            db 32 dup(0)
                  
point        db ". $"
space        db " $"
            
x_pos           dw  ?       
y_pos           dw  ?
len             dw  ? 

            .code
main        proc far
            mov ax, @data
            mov ds, ax                                       
            call get_input

            mov x_pos, ax
                        
            call get_input            
            mov y_pos, ax
            call get_input

            mov len, ax
            
================================; print new line until we reach the y position            
            mov bx, y_pos
loop4:      
            cmp bx, 0
            je next            
            mov dl, 10
            mov ah, 02h
            int 21h
            mov dl, 13
            mov ah, 02h
            int 21h
            ;
            dec bx
            jmp loop4
================================
next:       
            mov cx, len
            
while_true: 
            cmp cx, 0
            je _end    
            mov ax, x_pos

            ; space from the left side
            cmp ax, 0
            je point_start

            mov bx, cx
            mov cx, ax
loop3:      mov ah, 9
            mov dx, offset space
            int 21h
            loop loop3
            
            mov cx, bx


            ; print point with length of cx
point_start:            
            mov ax, cx

;           print point
            mov bx, cx            
            mov cx, ax
loop2:      
            mov ah, 9
            mov dx, offset point
            int 21h
            loop loop2            
            mov cx, bx
            
            ; go to new line         
            mov dl, 10
            mov ah, 02h
            int 21h
            mov dl, 13
            mov ah, 02h
            int 21h
            ;
            
            dec cx 
            jmp while_true        
_end:            
            mov ah, 4ch
            int 21h
main        endp

get_input     proc
            
            ; get string
            mov ah, 0Ah
            mov dx, offset buffer
            int 21h
            
            ; parse to int
            mov si, offset buffer + 1
            mov cl, [si]
            mov ch, 0
            mov ax, 0
            
loop1:      inc si
            mov bx, 10
            mul bx
            mov bl, [si]
            mov bh, 0
            add ax, bx
            sub ax, 30h
            loop loop1
            
            ret 
get_input     endp

            end main