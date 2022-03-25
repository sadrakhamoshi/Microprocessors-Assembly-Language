.model small
.data    
scores  db  04H,03H,08H,08H,14H,11H,10H,10H,10H,09H,06H,11H,15H,10H,14H,07H,12H,02H,10H,13H 
length  dw  14H 

middle  db  ?
max     db  ?
20_value    db  20H
diff     db  ?
 
sum         dw  ?
sum_hex_before     dw  ?
sum_hex_after     dw  ?
avg_before    db  ?
avg_after    db  ? 
avg_bcd_before dw  ?   
avg_bcd_after dw  ?

.code
MAIN    proc    FAR 
        mov     AX,@data
        mov     DS,AX
        mov     SI,offset scores
        call    FUNC_SUM
        mov     DX, sum
        mov     sum_hex_before, DX
        mov     length,14H

        mov     AX,sum_hex_before
        xor     DX, DX
        div     length
        mov     avg_before, AL

        mov     AL,avg_before
        call    FUNC_AVG_IN_BCD
        mov     avg_bcd_before,BX
        
        call    FUNC_SORT
        
        mov     BX, OFFSET scores
                add BX,09H  
                mov AX,WORD PTR [BX]
                add BX,01H
                add AX,WORD PTR [BX]  
                DAA
                mov AH,0H
                mov BL,02H
                div BL
                mov middle,AL

                mov     SI,0H
                mov     CX,length
                mov     max,0H
                
        LOOP_M:  
                mov     AL,[SI]
                cmp     AL,max
                ja      LOOP_GREATE
        LOOP4:      
                inc     SI
                loop    LOOP_M
                jmp     TAG1
                
        LOOP_GREATE:
                mov     max,AL 
                jmp     LOOP4
        
        TAG1:   
                mov CX,01
                mov BX,00
                CLC
        BACK:       
                mov AL,BYTE PTR 20_value[BX]
                sbb AL,BYTE PTR max[BX]
                das 
                mov BYTE PTR diff[BX],AL
                inc BX
                loop BACK

                mov SI,0H
                mov CX,length
                
        LOOP3:          
                mov AL,[SI]
                cmp AL,middle
                ja  LOOP5
        LOOP6:        
                inc SI
                loop LOOP3                                
                jmp TAG2

        LOOP5:
                add AL,diff
                DAA
                mov BYTE PTR scores[SI],AL
                jmp LOOP6
        
        TAG2: 
        call    FUNC_SUM
        mov     DX, sum
        mov     sum_hex_after, DX         
        mov     length,14H

        mov     AX,sum_hex_after
        xor     DX, DX
        div     length
        mov     avg_after, AL

        mov     AL,avg_after        
        call    FUNC_AVG_IN_BCD
        mov     avg_bcd_after,BX
        
        mov     AH,4CH
        int     21H
MAIN    ENDP    
 
FUNC_SORT proc 
     mov    CX,length
     
LOOP1:  mov SI,0H
            mov DI,0H
            inc DI
            jmp LOOP2
            RET
                         
LOOP2:    mov   AL,[SI]
              mov   BL,[DI]
              cmp   AL,BL
              ja    SWAP 
              inc   DI
              inc   SI
              cmp   DI,CX
              jl   LOOP2
              loop LOOP1
              RET
                            
SWAP:   mov [SI],BL
        mov [DI],AL
        mov AL,BL  
        inc   DI
        inc   SI
        cmp   DI,CX
        jl   LOOP2
        loop LOOP1
        RET
    
FUNC_SORT    ENDP  


FUNC_AVG_IN_BCD    proc
            mov AH,0H 
            mov CL,64H
            div CL
            mov BH,AL
            mov AL,AH 
            mov AH,0H
            mov CL,0AH
            div CL
            mov CL,04H
            rol AL,CL
            add AL,AH
            mov BL,AL
            RET
FUNC_AVG_IN_BCD    ENDP 


FUNC_SUM    proc          
        mov sum, 0
        mov SI,0H     
        mov AH,0H
        
LOOP_S:  
        mov BL,[SI]
        and BL,0FH
        mov AL,[SI]
        and AL,11110000B
        mov CL,04
        ror AL,CL
        mov DL,0AH
        mul DL
        add AL,BL         
        add sum,AX
        inc SI 

        dec length
        cmp length,0H
        jnz LOOP_S        
        RET
FUNC_SUM    ENDP


END MAIN   