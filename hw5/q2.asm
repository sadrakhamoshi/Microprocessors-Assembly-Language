s_bl_cl      macro          ;swap bl, cl
        mov     al,bl
        mov     bl,cl
        mov     cl,al
        endm

s_ch_cl      macro           ; swap ch, cl
        mov     al,ch
        mov     ch,cl
        mov     cl,al
        endm

m_print macro   source,dest
        
        mov from, '0'
        add from, source
        mov to, '0'
        add to, dest
        lea dx, move
        mov ah, 09
        int 21H
        endm

        .MODEL  SMALL
        .STACK  64
        .data


move db "mov:  "
from db ?
tmp db " --> "
to db ?
NEWLINE db 0AH, 0DH, '$'
        
        .code   
main    proc    FAR
        mov     ax,@data
        mov     ds,ax        
        
        mov     bh,10  ; n = 10
        mov     bl,1 ; source
        mov     ch,3 ; dest
        mov     cl,2 ; help
        call    solve
        mov     ah,4ch
        int     21h       
main    endp

solve  proc
        cmp     bh,1
        je     _end 

        ; call sovle
        push    bx
        push    cx
        dec     bh
        s_ch_cl
        call solve

        ; print the direction
        pop     cx
        pop     bx
        push    bx
        push    cx
        m_print bl,ch

        ; call solve
        pop     cx
        pop     bx
        s_bl_cl
        dec     bh
        call solve  
_end:   
        m_print bl,ch
        ret

solve   endp    
        end     main