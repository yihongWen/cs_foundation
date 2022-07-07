;实验13，分别在屏幕的2、4、6、8行显示4句英文诗，补全程序
assume cs:codesg
codesg segment
    s1:    db   'Good,better,best,$'
    s2:    db   'Never let it rest,$'
    s3:    db   'Till goog is better,$'
    s4:    db   'And better,best.$'
    s:     dw   offset s1,offset s2,offset s3,offset s4
    row:   db   2,4,6,8

    start: 

    ;        mov  ax,0b800h
    ;        mov  es,ax
    ;        mov  bx,0
    ;        mov  cx,2000
    ;        mov  ax,0
    ; clear: 
    ;        mov  es:[bx],ax
    ;        add  bx,2
    ;        loop clear
                  
           mov  ax,cs
           mov  ds,ax
           mov  bx,offset s
           mov  si,offset row
           mov  cx,4
    ok:    mov  bh,0
    ;  行号
           mov  dh,ds:[si]
           mov  dl,0
           mov  ah,2
           int  10h

    ; 字符的指向
           mov  dx,ds:[bx]
           mov  ah,9
           int  21h
    ; 指向next行、以及字符串首地址
           inc  si
           add  bx,2
           loop ok
    
           mov  ax,4c00h
           int  21h
codesg ends
end start