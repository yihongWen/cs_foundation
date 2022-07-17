; 对磁盘的读写
; 没有看到效果
data segment
    db 32 dup(0)
data ends

stacks segment
    db 32 dup(0)
stacks ends

codes segment
    assume cs:codes, ds:data, ss:stacks
start:  
        mov ax,data
        mov ds,ax
        mov ax,stacks
        mov ss,ax
        mov sp,32

        mov ax,0b800h
        mov es,ax
        mov bx,0

        mov al,8
        mov ch,0
        mov cl,1
        mov dl,81h
        mov dh,0
        mov ah,3
        int 13h

        ; call delay

        ; clear_screen: 
        ;           push bx
        ;           push es
        ;           push cx
        ;           mov  bx,0b800h
        ;           mov  es,bx
        ;           mov  bx,0
        ;           mov  cx,2000
        ; clear_screens:
        ;           mov  byte ptr es:[bx],' '
        ;           add  bx,2
        ;           loop clear_screens
        ;           pop  cx
        ;           pop  es
        ;           pop  bx
        
        ; call delay

        mov ax,0b800h
        mov es,ax
        mov bx,0

        mov al,8
        mov ch,0
        mov cl,1
        mov dl,81h
        mov dh,0
        mov ah,2
        int 13h
        



        mov ax,4c00h
        int 21h
 delay:
          push   ax
          push   dx
   
          mov    dx,0005h
    d1:   
          dec    dx
          cmp    dx,0
          je     d_end
          mov    ax,0ffffh
    d2:   
          dec    ax
          cmp    ax,0
          jne    d2
          jmp    d1
    d_end:
          pop    dx
          pop    ax
          ret
    
codes ends
end start