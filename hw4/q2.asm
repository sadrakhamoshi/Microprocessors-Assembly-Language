            .model small
            .stack 64
            .data

buffer      db  32
            db ?
            db 32 dup(0)

menu_str    db "0: Add, 1: Sub, 2: Mul, 3: Div, 4: e$"
            
num1        dw  ?       
num2        dw  ? 

            .code
main        proc far
            mov ax, @data
            mov ds, ax              
            
            call get_input
            mov num1, ax
            
            call get_input
            mov num2, ax
            
while_true: 
            mov si, offset menu_str
            mov ah, 9
            mov dx, si
            int 21h
            
            ; print new line
            mov dl, 10
            mov ah, 02h
            int 21h
            mov dl, 13
            mov ah, 02h
            int 21h
            ;

            call get_input

ins0:       cmp ax, 0   ;add
            jne  ins1
            mov ax, num1
            mov cx, num2
            add ax, cx
            call print_result
            jmp while_true

ins1:       cmp ax, 1   ;sub
            jne  ins2
            mov ax, num1
            mov cx, num2
            cmp ax, cx
            jle  bx_ax
            
ax_bx:      sub ax, cx
            call print_result
            jmp while_true
 
bx_ax:      sub cx, ax
            mov ax, cx
            call print_result
            jmp while_true

ins2:       cmp ax, 2    ;mul
            jne  ins3
            mov ax, num1
            mov cx, num2
            mul cx
            call print_result
            jmp while_true


ins3:       cmp ax, 3   ;div
            jne  ins4
            mov ax, num1
            mov cx, num2
            mov dx, 0
            div cx
            call print_result
            jmp while_true


ins4:       cmp ax, 4   ;end
            jne  while_true
            mov ah, 4ch
            int 21h          
main        endp


print_result   proc            
            ; parse to string
            mov si, offset buffer + 31
            mov [si], '$'
            
loop2:      dec si
            mov bx, 10
            mov dx, 0
            div bx
            add dx, 30h
            mov [si], dl
            cmp ax, 0
            jne loop2               

            ; print intrupt
            mov ah, 9
            mov dx, si
            int 21h
            
            ; print new line
            mov dl, 10
            mov ah, 02h
            int 21h
            mov dl, 13
            mov ah, 02h
            int 21h
            ;
            ret
print_result   endp
        
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
            
            mov cx, ax

            ; print new line
            mov dl, 10
            mov ah, 02h
            int 21h
            mov dl, 13
            mov ah, 02h
            int 21h
            ;
            mov ax, cx
            
            ret 
get_input     endp

            end main
        
    
    