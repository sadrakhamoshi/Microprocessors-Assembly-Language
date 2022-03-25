; ***** stack segment
stseg   segment
        db      64 dup(?)
stseg   ends

; ***** data segment
dataseg   segment
       
    num1    DW  06h       ; define first  variable
    num2    DW  02h       ; define second variable
    res     DW  ?, 0      ; define result variable   
    ;
    
dataseg   ends

; ***** code segment
codeseg   segment
    
    main proc FAR
    ASSUME  cs:codeseg, ds:dataseg, ss:stseg
    mov ax, dataseg
    mov ds, ax
    
    
    mov ax, num1
    mov cx, num2
    
    add_label: add res, ax
    loop add_label
    
    
    mov ax, 4ch
    int 21h

main endp    
codeseg   ends
          END main