.data 

    words db "word1$", "word1$", "word2$", "word3$", "word3$", "word3$", "word4$", "word4$", "word4$" , "word4$", "word5$", "word5$", "word6$", "word6$", "word7$" , "word6$", "word4$","word7$" , "word7$", "word9$"
    occurs db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    size equ $-words ; compute size
    
.code  
main:
    mov ax, @data
    mov ds, ax 
    
    mov bx, 0
    mov bp, 0
    
    _loop:         
        
        mov si, bx
        mov di, 0

        loop_cmp:        
            cmp di, size
            jge loop_go_next
            
            mov ah, words[si] 
            cmp ah, words[di]
            jne loop_not_equal

            ; end of the word        
            cmp words[si], '$'
            je loop_equal
            
            inc si
            inc di
            jmp loop_cmp
        
        loop_not_equal:            
            inc di
            cmp words[di-1], '$'
            jne loop_not_equal
            
            mov si, bx
            jmp loop_cmp
        
        loop_equal:
            inc occurs[bp]
            inc di
            mov si, bx
            jmp loop_cmp
          
    
        loop_go_next:
            inc bx
            cmp words[bx-1], '$'
            jne loop_go_next

            inc bp
            cmp bx, size
            jge _end
        
            jmp _loop            
    _end: 
                          
end main