
.MODEL SMALL
.STACK 64
.DATA

num1    DW  06h       ; define first  variable
num2    DW  02h       ; define second variable
res     DW  ?, 0      ; define result variable   
;

.CODE
multiple proc FAR
    
    mov ax, @DATA
    mov ds, ax
    
    
    mov ax, num1
    mov cx, num2
    
    add_label: add res, ax
    loop add_label
    
    
    mov ax, 4ch
    int 21h

multiple endp

         end multiple


