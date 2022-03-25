
get_color   MACRO   color
            ; was red
            cmp color, 0
            je GREEN

            ; was green
            cmp color, 1
            je BLUE

            ; was blue
            cmp color, 2
            je  RED

    RED:
            mov al, 0
            mov color, al
            mov al, 1100b
            jmp _END

    GREEN:
            mov al, 1
            mov color, al
            mov al, 1010b
            jmp _END

    BLUE:
            mov al, 2
            mov color, al
            mov al, 1001b
            jmp _END

    _END:    

endm

print macro x, y, color, val
LOCAL   s_dcl, skip_dcl, s_dcl_end
    pusha
    mov dx, cs
    mov es, dx
    mov ah, 13h
    mov al, 1
    mov bh, 0
    mov bl, color
    mov cx, offset s_dcl_end - offset s_dcl
    mov dl, x
    mov dh, y
    mov bp, offset s_dcl
    int 10h
    popa
    jmp skip_dcl
    s_dcl DB val
    s_dcl_end DB 0
    skip_dcl:    
endm  


print_space macro num
    pusha
    mov ah, 9
    mov al, ' '
    mov bl, 0000_1111b
    mov cx, num
    int 10h
    popa
endm

org 100h

jmp pstart

x_pos dw -1
y_pos dw 0
color db 0


pstart:
        mov ah, 00
        mov al, 13h       ;Video Mode. 
        int 10h

        ; reset mouse and get its status:
        mov ax, 0
        int 33h
        cmp ax, 0

mouse_pressed:
        mov ax, 3
        int 33h
        shr cx, 1       ; x/2 - in this mode the value of CX is doubled.
        cmp bx, 1
        jne prnt_cursor_pos:

        get_color color  ; get color
        jmp draw_pixel  ;


prnt_cursor_pos:
        cmp x_pos, -1
        je mouse_released
        push cx
        push dx
        mov cx, x_pos
        mov dx, y_pos
        mov ah, 0dh     ; get pixel.
        int 10h
        xor al, 1111b   ; set pixel color
        mov ah, 0ch     ; set pixel
        int 10h

        ; print the x,y position of mouse
        print 0,0,0000_1110b,"X pos:"
        mov ax, cx
        call print_ax_register
        print_space 4
        print 0,1,0000_1110b,"Y pos:"
        mov ax, dx
        call print_ax_register
        print_space 4

        pop dx
        pop cx

mouse_released:
        mov ah, 0dh     
        int 10h
        xor al, 1111b   
        mov x_pos, cx
        mov y_pos, dx

draw_pixel:
        mov ah, 0ch     ; set pixel
        int 10h

check_esc_key:
        mov dl, 255
        mov ah, 6
        int 21h
        cmp al, 27
        jne mouse_pressed
        mov     ah,4ch  ; exit
        int     21h

print_ax_register   proc 
                cmp ax, 0
                jne print_ax_r
                push ax
                mov al, '0'
                mov ah, 0eh
                int 10h
                pop ax
                ret 
        print_ax_r:
                pusha
                mov dx, 0
                cmp ax, 0
                je end_p
                mov bx, 10
                div bx    
                call print_ax_r
                mov ax, dx
                add al, 30h
                mov ah, 0eh
                int 10h    

        end_p:
                popa  
                ret  
endp