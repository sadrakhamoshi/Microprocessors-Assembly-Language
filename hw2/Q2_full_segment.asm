; ****** stack segment
stseg   segment
        db      64 dup(?)
stseg   ends

; ****** data segment
dataseg   segment

nums DB 5h, 5h, 5h, 3h, 4h, 5h, 6h, 7h, 1h, 9h
sum  DB ?
mean DB ?
min  DB ?
max  DB ?

dataseg   ends
    

; ****** code segment    
codeseg segment

; sum
sum_proc proc
    
    mov si, 00h
    mov cx, 0Ah  ; 10 number
    
    sum_label: mov al, [si]
               add sum, al
               inc si
               loop sum_label
    ret   
sum_proc endp


; mean
mean_proc proc
    
    mov bl, 10
    mov al, sum
    mov ah, 0
    div bl
    mov mean, al
    
    ret

mean_proc endp

; min
min_proc proc
    
    mov si, 0h
    mov cx, 10
    
    mov min, 0ffh
    
    min_label: mov al, [si]
               cmp min, al
               ja  min_swap
               inc  si
               loop min_label              
               ret
               
    min_swap: mov min, al
              inc si
              loop min_label
              ret            
min_proc endp
          
             
; max
max_proc proc


    mov si, 0h
    mov cx, 10
    
    mov max, 00h
    
    max_label: mov al, [si]
               cmp max, al
               jb  max_swap
               inc  si
               loop max_label              
               ret
               
    max_swap: mov max, al
              inc si
              loop max_label
              ret    
    
max_proc endp                       

     
; main program
main proc FAR                                
    
     ASSUME  cs:codeseg, ds:dataseg, ss:stseg
     mov ax, dataseg
     mov ds, ax
     mov si, offset nums
     
     call sum_proc
     call mean_proc
     call min_proc 
     call max_proc    
    
    
     mov ah, 4ch
     int 21H
main endp

end main  

codeseg ends


